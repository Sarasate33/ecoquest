// lib/services/beacon_service.dart

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/checkpoint.dart';

class BeaconService {
  static final BeaconService _instance = BeaconService._internal();
  factory BeaconService() => _instance;
  BeaconService._internal();

  final _checkpointTriggeredController =
      StreamController<Checkpoint>.broadcast();

  Stream<Checkpoint> get checkpointTriggered =>
      _checkpointTriggeredController.stream;

  final Map<int, Checkpoint> _beaconRegistry = {};
  final String _targetUuid = 'fda50693-a4e2-4fb1-afcf-c6eb07647825';
  final int _targetMajor = 10011;

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  final Set<int> _discoveredCheckpointIds = {};
  bool _isScanning = false;

  void registerCheckpoints(List<Checkpoint> checkpoints) {
    for (final checkpoint in checkpoints) {
      _beaconRegistry[checkpoint.beaconMinor] = checkpoint;
    }
  }

  Future<void> startScanning() async {
    if (_isScanning || _beaconRegistry.isEmpty) return;

    final granted = await _requestPermissions();
    if (!granted) return;

    try {
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) return;

      _isScanning = true;

      try {
        await FlutterBluePlus.stopScan();
      } catch (_) {}

      FlutterBluePlus.startScan(androidUsesFineLocation: true);

      _scanSubscription = FlutterBluePlus.scanResults.listen(
        _processScanResults,
        onError: (_) => _isScanning = false,
      );
    } catch (_) {
      _isScanning = false;
    }
  }

  Future<bool> _requestPermissions() async {
    final bluetoothScan = await Permission.bluetoothScan.request();
    final bluetoothConnect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    return bluetoothScan.isGranted &&
        bluetoothConnect.isGranted &&
        (location.isGranted || location.isLimited);
  }

  void _processScanResults(List<ScanResult> results) {
    for (var result in results) {
      final ibeacon = _parseIBeacon(result);
      if (ibeacon == null) continue;

      final uuid = ibeacon['uuid'] as String;
      final major = ibeacon['major'] as int;
      final minor = ibeacon['minor'] as int;

      if (uuid.toLowerCase() != _targetUuid.toLowerCase()) continue;
      if (major != _targetMajor) continue;
      if (_discoveredCheckpointIds.contains(minor)) continue;

      final checkpoint = _beaconRegistry[minor];
      if (checkpoint == null) continue;

      _discoveredCheckpointIds.add(minor);
      _checkpointTriggeredController.add(checkpoint);
    }
  }

  Map<String, dynamic>? _parseIBeacon(ScanResult result) {
    try {
      final manufacturerData = result.advertisementData.manufacturerData;
      if (manufacturerData.isEmpty) return null;

      for (var entry in manufacturerData.entries) {
        final companyId = entry.key;
        final data = entry.value;

        // Apple company id 0x004C, iBeacon prefix 0x02 0x15
        if (companyId == 0x004C &&
            data.length >= 23 &&
            data[0] == 0x02 &&
            data[1] == 0x15) {
          final uuid = _bytesToUuid(data.sublist(2, 18));
          final major = (data[18] << 8) | data[19];
          final minor = (data[20] << 8) | data[21];
          final txPower = data[22];

          return {
            'uuid': uuid,
            'major': major,
            'minor': minor,
            'txPower': txPower,
            'rssi': result.rssi,
          };
        }
      }
    } catch (_) {}
    return null;
  }

  String _bytesToUuid(List<int> bytes) {
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  Future<void> stopScanning() async {
    _isScanning = false;
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    try {
      await FlutterBluePlus.stopScan();
    } catch (_) {}
  }

  void resetDiscoveredCheckpoints() {
    _discoveredCheckpointIds.clear();
  }

  void dispose() {
    stopScanning();
    _checkpointTriggeredController.close();
  }

  List<Checkpoint> getAllCheckpoints() => _beaconRegistry.values.toList();
}
