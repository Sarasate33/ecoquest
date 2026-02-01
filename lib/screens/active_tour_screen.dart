// lib/screens/active_tour_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_demo/services/questions.dart';
import 'dart:async';
import '../config/theme.dart';
import '../services/data_service.dart';
import '../services/beacon_service.dart';
import 'package:flutter_application_demo/models/quiz_questions.dart';

// screen shown during an active tour, handles beacon scanning and quiz questions
class ActiveTourScreen extends StatefulWidget {
  const ActiveTourScreen({super.key});

  @override
  State<ActiveTourScreen> createState() => _ActiveTourScreenState();
}

class _ActiveTourScreenState extends State<ActiveTourScreen> {
  final BeaconService _beaconService = BeaconService();
  StreamSubscription? _triggeredSub;

  // tour state variables
  int discoveredCheckpoints = 9;
  int totalCheckpoints = 16;
  int currentPoints = 450;
  List<String> selectedAnswers = [];
  String statusMessage = "Searching for checkpoints...";
  String feedback = "";

  @override
  void initState() {
    super.initState();
    _beaconService.resetDiscoveredCheckpoints();
    _startScanning();
  }

  // start beacon scanning and listen for discovered checkpoints
  Future<void> _startScanning() async {
    // register checkpoints from data service
    _beaconService.registerCheckpoints(DataService.checkpoints);
    // start scanning
    await _beaconService.startScanning();
      // listen for discovered checkpoints
    _triggeredSub = _beaconService.checkpointTriggered.listen((checkpoint) {
      if (!mounted) return;
      setState(() {
        discoveredCheckpoints++;
      });
      _showCheckpointQuiz(
        checkpoint.name,
        checkpoint.description,
        checkpoint.id,
      );
    });
  }

  void answerQuestion(String selectedAnswer, QuizQuestion checkpointQuestion) {
    setState(() {
      selectedAnswers.add(selectedAnswer);
      if (selectedAnswer == checkpointQuestion.answers[0]) {
        currentPoints += 150; // award points for correct answer
        feedback = "Correct answer! +150 Points";
      } else {
        feedback = "Wrong answer. Try again next time!";
      }
    });
  }

  // Show dialog for discovered checkpoint - Quiz Questions
  void _showCheckpointQuiz(String name, String description, int id) {
    final checkpointQuestion = questions[id];
    showDialog(
      context: context,
      builder: (ctx) {
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
                Text(textAlign: TextAlign.center, checkpointQuestion.text), // question text
                const SizedBox(height: 10),
                ...shuffled.map((answer) { //answers
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      onPressed: answered
                          ? null
                          : () {
                              setStateDialog(() {
                                answered = true;
                              });
                              // Update parent state (awards points if correct)
                              answerQuestion(answer, checkpointQuestion);
                              if (Navigator.of(ctx).canPop()) {
                                Navigator.of(ctx).pop();
                              }
                            },
                      child: Text(answer),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // stop scanning and clean up
  @override
  void dispose() {
    _triggeredSub?.cancel();
    _beaconService.stopScanning();
    super.dispose();
  }

  // build UI
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              statusMessage,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
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
            child: Text(feedback, style: Theme.of(context).textTheme.bodySmall),
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
