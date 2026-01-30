// lib/services/beacon_service.dart
// Updated: more robust single persistent scan + debug logging

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/checkpoint.dart';

class BeaconService {
  static final BeaconService _instance = BeaconService._internal();
  factory BeaconService() => _instance;
  BeaconService._internal();

  final _detectedCheckpointsController =
      StreamController<List<Checkpoint>>.broadcast();
  final _checkpointTriggeredController =
      StreamController<Checkpoint>.broadcast();

  Stream<List<Checkpoint>> get detectedCheckpoints =>
      _detectedCheckpointsController.stream;
  Stream<Checkpoint> get checkpointTriggered =>
      _checkpointTriggeredController.stream;

  final Map<int, Checkpoint> _beaconRegistry = {
    19641: const Checkpoint(
      id: 0,
      name: 'Memorial Stone',
      description: 'Learn about the 300-year-old oak and its ecosystem',
      beaconUuid: 'fda50693-a4e2-4fb1-afcf-c6eb07647825',
      beaconMajor: 10011,
      beaconMinor: 19641,
      experienceType: ExperienceType.information,
    ),
  };

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  final Map<int, Checkpoint> _currentlyDetected = {};
  final Map<int, DateTime> _lastTriggered = {};
  final Duration _debounceTime = const Duration(seconds: 10);
  bool _isScanning = false;

  // Target iBeacon identifiers (matches your screenshot)
  final String _targetUuid = 'fda50693-a4e2-4fb1-afcf-c6eb07647825';
  final int _targetMajor = 10011;

  // Toggle this to enable/disable debug prints
  final bool _debug = true;

  // Start scanning (single persistent scan; idempotent)
  Future<void> startScanning() async {
    if (_isScanning) {
      if (_debug) print('[BeaconService] startScanning: already scanning');
      return;
    }

    final granted = await _requestPermissions();
    if (!granted) {
      if (_debug)
        print('[BeaconService] startScanning: permissions not granted');
      return;
    }

    try {
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        if (_debug)
          print('[BeaconService] Bluetooth adapter not ON: $adapterState');
        return;
      }

      _isScanning = true;
      if (_debug) print('[BeaconService] Starting BLE scan (persistent)');

      // Ensure previous scan stopped
      try {
        await FlutterBluePlus.stopScan();
      } catch (_) {}

      // Start persistent scan. Avoid named params that may be unsupported by plugin version.
      FlutterBluePlus.startScan(androidUsesFineLocation: true);

      // Subscribe once to aggregated scanResults stream
      _scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          if (_debug) print('[BeaconService] scanResults: ${results.length}');
          _processScanResults(results);
        },
        onError: (e) {
          _isScanning = false;
          if (_debug) print('[BeaconService] scanResults error: $e');
        },
      );
    } catch (e) {
      _isScanning = false;
      if (_debug) print('[BeaconService] startScanning error: $e');
    }
  }

  Future<bool> _requestPermissions() async {
    final bluetoothScan = await Permission.bluetoothScan.request();
    final bluetoothConnect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    if (_debug) {
      print(
        '[BeaconService] permission status - bluetoothScan: ${bluetoothScan.isGranted}, bluetoothConnect: ${bluetoothConnect.isGranted}, location: ${location.isGranted}',
      );
    }

    return bluetoothScan.isGranted &&
        bluetoothConnect.isGranted &&
        (location.isGranted || location.isLimited);
  }

  void _processScanResults(List<ScanResult> results) {
    final currentlyDetectedIds = <int>{};

    for (var result in results) {
      // Debug: show device id/name and advertisement counts
      if (_debug) {
        final name = result.device.name.isNotEmpty
            ? result.device.name
            : result.advertisementData.localName;
        if (_debug)
          print(
            '[BeaconService] device: ${result.device.id.toString()} name="$name" rssi=${result.rssi}',
          );
      }

      // Try parsing iBeacon from manufacturer data
      final beaconData = _parseIBeacon(result);
      if (beaconData != null) {
        final minor = beaconData['minor'] as int;
        final checkpoint = _beaconRegistry[minor];
        if (checkpoint != null) {
          currentlyDetectedIds.add(checkpoint.id);
          final isNew = !_currentlyDetected.containsKey(checkpoint.id);
          _currentlyDetected[checkpoint.id] = checkpoint;
          if (isNew) {
            if (_debug)
              print(
                '[BeaconService] New beacon matched: ${checkpoint.name} (minor=$minor)',
              );
            _triggerCheckpoint(checkpoint);
          } else {
            if (_debug)
              print(
                '[BeaconService] Beacon still present: ${checkpoint.name} (minor=$minor)',
              );
          }
        } else {
          if (_debug)
            print('[BeaconService] beaconData minor=$minor not in registry');
        }
      } /*else {
        // Optionally log manufacturer map contents for debugging
        final manufacturerData = result.advertisementData.manufacturerData;
        if (_debug) {
          if (manufacturerData.isNotEmpty) {
            manufacturerData.forEach((companyId, data) {
              if (_debug) print('[BeaconService] manufacturerData - companyId=0x${companyId.toRadixString(16)} length=${data.length}');
            });
          }
        }
      }*/
    }

    // Remove ones no longer detected
    _currentlyDetected.removeWhere(
      (id, _) => !currentlyDetectedIds.contains(id),
    );

    // Emit current detected list
    _detectedCheckpointsController.add(_currentlyDetected.values.toList());
  }

  Map<String, dynamic>? _parseIBeacon(ScanResult result) {
    try {
      final manufacturerData = result.advertisementData.manufacturerData;
      if (manufacturerData.isEmpty) return null;

      // Look for Apple's company id 0x004C (decimal 76)
      for (var entry in manufacturerData.entries) {
        final companyId = entry.key;
        final data = entry.value;

        // Debug: show company id + first bytes
        if (_debug) {
          final preview = data
              .take(6)
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join(' ');
          print(
            '[BeaconService] parseIBeacon: company=0x${companyId.toRadixString(16)} dataLen=${data.length} firstBytes=[$preview]',
          );
        }

        if (companyId == 0x004C && data.length >= 23) {
          // iBeacon prefix bytes: 0x02 0x15
          if (data[0] == 0x02 && data[1] == 0x15) {
            final uuidBytes = data.sublist(2, 18);
            final uuid = _bytesToUuid(uuidBytes);
            final major = (data[18] << 8) | data[19];
            final minor = (data[20] << 8) | data[21];
            final txPower = data[22];

            if (_debug) {
              print(
                '[BeaconService] iBeacon parsed: uuid=$uuid major=$major minor=$minor tx=$txPower rssi=${result.rssi}',
              );
            }

            if (uuid.toLowerCase() == _targetUuid.toLowerCase() &&
                major == _targetMajor) {
              return {
                'uuid': uuid,
                'major': major,
                'minor': minor,
                'txPower': txPower,
                'rssi': result.rssi,
              };
            }
          }
        }
      }
    } catch (e) {
      if (_debug) print('[BeaconService] parseIBeacon error: $e');
    }
    return null;
  }

  String _bytesToUuid(List<int> bytes) {
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  void _triggerCheckpoint(Checkpoint checkpoint) {
    final last = _lastTriggered[checkpoint.id];
    if (last != null) {
      final elapsed = DateTime.now().difference(last);
      if (elapsed < _debounceTime) {
        if (_debug)
          print(
            '[BeaconService] Debounced checkpoint ${checkpoint.id} (${elapsed.inSeconds}s)',
          );
        return;
      }
    }
    _lastTriggered[checkpoint.id] = DateTime.now();
    _checkpointTriggeredController.add(checkpoint);
  }

  Future<void> stopScanning() async {
    if (_debug) print('[BeaconService] stopScanning');
    _isScanning = false;
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    try {
      await FlutterBluePlus.stopScan();
    } catch (_) {}
    _currentlyDetected.clear();
  }

  void dispose() {
    stopScanning();
    _detectedCheckpointsController.close();
    _checkpointTriggeredController.close();
  }

  List<Checkpoint> getAllCheckpoints() => _beaconRegistry.values.toList();
}
