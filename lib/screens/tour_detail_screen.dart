// lib/screens/tour_detail_screen.dart

import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'start_tour_mode_screen.dart';

class TourDetailScreen extends StatelessWidget {
  final Map<String, dynamic> tour;
  const TourDetailScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tour['title'], style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: ecoGrey,
                image: DecorationImage(
                  image: AssetImage(tour['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tour['subtitle'], style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const StartTourModeScreen()));
                    },
                    child: const Text("Start an Adventure!"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}