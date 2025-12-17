// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../services/data_service.dart';
import 'landing_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Icon(Icons.account_circle, size: 80, color: Colors.grey)),
            const SizedBox(height: 10),
            Center(
              child: Text(
                DataService.currentUserName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            ListTile(
              title: Text("Privacy & Security", style: Theme.of(context).textTheme.bodyLarge),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
            ListTile(
              title: Text("Logout", style: Theme.of(context).textTheme.bodyLarge),
              trailing: const Icon(Icons.logout),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LandingScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}