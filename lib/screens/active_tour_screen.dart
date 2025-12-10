import 'dart:async';
import 'package:flutter/material.dart';
import '../models/tour.dart';
import '../models/checkpoint.dart';
import '../services/beacon_service.dart';

class ActiveTourScreen extends StatefulWidget {
  final Tour tour;
  final VoidCallback? onEndTour;
  final VoidCallback? onOpenSettings;

  const ActiveTourScreen({
    Key? key,
    required this.tour,
    this.onEndTour,
    this.onOpenSettings,
  }) : super(key: key);

  @override
  State<ActiveTourScreen> createState() => _ActiveTourScreenState();
}

class _ActiveTourScreenState extends State<ActiveTourScreen> {
  final BeaconService _beaconService = BeaconService();
  StreamSubscription<List<Checkpoint>>? _detectedSub;
  StreamSubscription<Checkpoint>? _triggeredSub;
  List<Checkpoint> _detected = [];
  final List<String> _events = [];

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  Future<void> _startScanning() async {
    await _beaconService.startScanning();

    _detectedSub = _beaconService.detectedCheckpoints.listen((list) {
      setState(() {
        _detected = list;
      });
    });

    _triggeredSub = _beaconService.checkpointTriggered.listen((cp) {
      if (!mounted) return;
      setState(() {
        _events.insert(
          0,
          'Triggered: ${cp.name} (${DateTime.now().toLocal().toIso8601String().substring(11, 19)})',
        );
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Checkpoint reached: ${cp.name}')));
    });
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
        title: Text('Active: ${widget.tour.title}'),
        backgroundColor: const Color(0xFF246024),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onOpenSettings ?? () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Detected Checkpoints'),
                subtitle: Text('${_detected.length} detected'),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: _detected.length,
                        itemBuilder: (context, i) {
                          final cp = _detected[i];
                          return ListTile(
                            title: Text(cp.name),
                            subtitle: Text(cp.description),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const ListTile(title: Text('Events')),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _events.length,
                              itemBuilder: (context, i) =>
                                  ListTile(title: Text(_events[i])),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                widget.onEndTour?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF246024),
              ),
              child: const Text('End Tour'),
            ),
          ],
        ),
      ),
    );
  }
}
