import 'package:flutter/material.dart';
import '../models/tour.dart';

class StartModeScreen extends StatelessWidget {
  final Tour tour;
  final VoidCallback? onStartSolo;

  const StartModeScreen({Key? key, required this.tour, this.onStartSolo})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Tour')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Prepare to start: ${tour.title}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onStartSolo,
              child: const Text('Start Solo'),
            ),
          ],
        ),
      ),
    );
  }
}
