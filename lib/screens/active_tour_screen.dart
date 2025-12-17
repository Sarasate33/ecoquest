// lib/screens/active_tour_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../config/theme.dart';
import '../services/beacon_service.dart';

class ActiveTourScreen extends StatefulWidget {
  const ActiveTourScreen({super.key});

  @override
  State<ActiveTourScreen> createState() => _ActiveTourScreenState();
}

class _ActiveTourScreenState extends State<ActiveTourScreen> {
  final BeaconService _beaconService = BeaconService();
  StreamSubscription? _detectedSub;
  StreamSubscription? _triggeredSub;
  
  int discoveredCheckpoints = 0;
  int totalCheckpoints = 16;
  List<String> detectedBeaconNames = [];
  String statusMessage = "Searching for checkpoints...";

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  Future<void> _startScanning() async {
    await _beaconService.startScanning();

    _detectedSub = _beaconService.detectedCheckpoints.listen((checkpoints) {
      setState(() {
        detectedBeaconNames = checkpoints.map((cp) => cp.name).toList();
        statusMessage = "${checkpoints.length} beacon(s) in range";
      });
    });

    _triggeredSub = _beaconService.checkpointTriggered.listen((checkpoint) {
      if (!mounted) return;
      setState(() {
        discoveredCheckpoints++;
        statusMessage = "Checkpoint reached: ${checkpoint.name}";
      });
      _showCheckpointDialog(checkpoint.name, checkpoint.description);
    });
  }

  void _showCheckpointDialog(String name, String description) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Checkpoint Discovered!", style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: ecoPrimaryGreen, size: 60),
            const SizedBox(height: 10),
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Great!"))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _detectedSub?.cancel();
    _triggeredSub?.cancel();
    _beaconService.stopScanning();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Tour", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discovered:", style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  "$discoveredCheckpoints/$totalCheckpoints",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(statusMessage, style: Theme.of(context).textTheme.bodySmall),
          ),
          
          const SizedBox(height: 16),
          
          if (detectedBeaconNames.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Beacons in Range:", style: Theme.of(context).textTheme.titleMedium),
                    ),
                    ...detectedBeaconNames.map((name) => ListTile(
                      leading: const Icon(Icons.bluetooth, color: ecoPrimaryGreen),
                      title: Text(name, style: Theme.of(context).textTheme.bodyMedium),
                      dense: true,
                    )),
                  ],
                ),
              ),
            ),
          
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              color: ecoGrey,
              child: Center(
                child: Text("Map View", style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          ),
        ],
      ),
    );
  }
}