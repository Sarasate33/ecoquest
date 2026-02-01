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

  // stream of discovered checkpoints
  Stream<Checkpoint> get checkpointTriggered =>
      _checkpointTriggeredController.stream;

  // set values to compare beacons against - hardcoded at the moment
  final Map<int, Checkpoint> _beaconRegistry = {};
  final String _targetUuid = 'fda50693-a4e2-4fb1-afcf-c6eb07647825';
  final int _targetMajor = 10011;

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  final Set<int> _discoveredCheckpointIds = {};
  bool _isScanning = false;

  // register checkpoints to compare against
  void registerCheckpoints(List<Checkpoint> checkpoints) {
    for (final checkpoint in checkpoints) {
      _beaconRegistry[checkpoint.beaconMinor] = checkpoint;
    }
  }

  // start scanning for beacons
  Future<void> startScanning() async {
    if (_isScanning || _beaconRegistry.isEmpty) return;

    // request necessary permissions
    final granted = await _requestPermissions();
    if (!granted) return;

    try {
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) return;

      _isScanning = true;

      // stop any ongoing scan
      try {
        await FlutterBluePlus.stopScan();
      } catch (_) {}

      // start scanning
      FlutterBluePlus.startScan(androidUsesFineLocation: true);

      _scanSubscription = FlutterBluePlus.scanResults.listen(
        _processScanResults,
        onError: (_) => _isScanning = false,
      );
    } catch (_) {
      _isScanning = false;
    }
  }

  // request necessary Bluetooth and location permissions
  Future<bool> _requestPermissions() async {
    final bluetoothScan = await Permission.bluetoothScan.request();
    final bluetoothConnect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    return bluetoothScan.isGranted &&
        bluetoothConnect.isGranted &&
        (location.isGranted || location.isLimited);
  }

  // process scan results to identify target beacons
  void _processScanResults(List<ScanResult> results) {
    for (var result in results) {
      final ibeacon = _parseIBeacon(result);
      if (ibeacon == null) continue;

      final uuid = ibeacon['uuid'] as String;
      final major = ibeacon['major'] as int;
      final minor = ibeacon['minor'] as int;

      if (uuid.toLowerCase() != _targetUuid.toLowerCase()) continue; // check if beacon belongs to our app
      if (major != _targetMajor) continue; // check if beacon belongs to this tour
      if (_discoveredCheckpointIds.contains(minor)) continue; // check if already discovered

      final checkpoint = _beaconRegistry[minor];
      if (checkpoint == null) continue;

      _discoveredCheckpointIds.add(minor);
      _checkpointTriggeredController.add(checkpoint);
    }
  }

  /* 
  iBeacon format:

  [0x4C 0x00] (Apple company id) [0x02] [0x15] [16 bytes UUID] [2 bytes Major] [2 bytes Minor] [1 byte txPower]
  
  _parseIBeacon checks for the Apple company id and the 0x02 0x15 prefix,
  then slices out the UUID, Major, Minor, and txPower. The UUID bytes get
  formatted into the standard xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx string by _bytesToUuid.
  */

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

  // stop scanning for beacons
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
