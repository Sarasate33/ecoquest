import 'package:flutter/material.dart';
import '../models/tour.dart';

class TourDetailScreen extends StatelessWidget {
  final Tour tour;
  final VoidCallback? onStartTour;

  const TourDetailScreen({Key? key, required this.tour, this.onStartTour})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tour.title),
        backgroundColor: const Color(0xFF246024),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tour.description),
            const SizedBox(height: 12),
            Text('Checkpoints: ${tour.totalCheckpoints}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  onStartTour ??
                  () {
                    Navigator.of(context).pop();
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF246024),
              ),
              child: const Text('Start Tour'),
            ),
          ],
        ),
      ),
    );
  }
}
