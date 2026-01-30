// lib/screens/active_tour_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_demo/data/questions.dart';
import 'dart:async';
import '../config/theme.dart';
import '../services/beacon_service.dart';
import "package:flutter_application_demo/models/quiz_questions.dart";

class ActiveTourScreen extends StatefulWidget {
  const ActiveTourScreen({super.key});

  @override
  State<ActiveTourScreen> createState() => _ActiveTourScreenState();
}

class _ActiveTourScreenState extends State<ActiveTourScreen> {
  final BeaconService _beaconService = BeaconService();
  StreamSubscription? _detectedSub;
  StreamSubscription? _triggeredSub;

  int discoveredCheckpoints = 9;
  int totalCheckpoints = 16;
  int currentPoints = 450;
  List<String> detectedBeaconNames = [];
  List<String> selectedAnswers = [];
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
      _showCheckpointDialog(
        checkpoint.name,
        checkpoint.description,
        checkpoint.id,
      );
    });
  }

  void answerQuestion(String selectedAnswer, QuizQuestion checkpointQuestion) {
    // Update main screen state (do NOT close the dialog here so the dialog can show feedback)
    setState(() {
      selectedAnswers.add(selectedAnswer);
      if (selectedAnswer == checkpointQuestion.answers[0]) {
        currentPoints += 150; // award points for correct answer
        statusMessage = "Correct answer! +150 Points";
      } else {
        statusMessage = "Wrong answer. Try again next time!";
      }
    });
  }

  // Show dialog for discovered checkpoint - Quiz Questions
  void _showCheckpointDialog(String name, String description, int id) {
    final checkpointQuestion = questions[id];
    showDialog(
      context: context,
      builder: (ctx) {
        String? selected;
        bool answered = false;
        final shuffled = checkpointQuestion.getShuffledAnswers();
        return StatefulBuilder(
          builder: (ctx, setStateDialog) => AlertDialog(
            title: Text(
              "Checkpoint Discovered!",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(textAlign: TextAlign.center, checkpointQuestion.text),
                const SizedBox(height: 10),
                ...shuffled.map((answer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      onPressed: answered
                          ? null
                          : () {
                              setStateDialog(() {
                                selected = answer;
                                answered = true;
                              });
                              // Update parent state (awards points if correct)
                              answerQuestion(answer, checkpointQuestion);
                              // Close dialog after short delay so user sees feedback
                              Future.delayed(
                                const Duration(milliseconds: 800),
                                () {
                                  if (Navigator.of(ctx).canPop())
                                    Navigator.of(ctx).pop();
                                },
                              );
                            },
                      child: Text(answer),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
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
        title: Text(
          "Active Tour",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Beacons discovered:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  "$discoveredCheckpoints/$totalCheckpoints",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Points:", style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  "$currentPoints",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              statusMessage,
              style: Theme.of(context).textTheme.bodySmall,
            ),
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
                      child: Text(
                        "Beacons in Range:",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ...detectedBeaconNames.map(
                      (name) => ListTile(
                        leading: const Icon(
                          Icons.bluetooth,
                          color: ecoPrimaryGreen,
                        ),
                        title: Text(
                          name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              color: ecoGrey,
              child: Center(
                child: Text(
                  "Map View",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
