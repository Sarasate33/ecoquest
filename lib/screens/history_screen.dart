// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/data_service.dart';


// build history screen showing user's completed trails - mock data at the moment
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final user = DataService.userProfile;
    return Scaffold(
      appBar: AppBar(
        title: Text("Trail History", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("You have completed:", style: Theme.of(context).textTheme.bodyLarge),
            Text(
              "${user['trailsCompleted']} trails!",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(padding: const EdgeInsets.all(8), color: ecoSoftSage.withOpacity(0.3), child: Text("Nature: 8", style: Theme.of(context).textTheme.bodyMedium)),
                Container(padding: const EdgeInsets.all(8), color: ecoGrey.withOpacity(0.3), child: Text("Urban: 4", style: Theme.of(context).textTheme.bodyMedium)),
                Container(padding: const EdgeInsets.all(8), color: ecoFreshOrange.withOpacity(0.2), child: Text("History: 2", style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}