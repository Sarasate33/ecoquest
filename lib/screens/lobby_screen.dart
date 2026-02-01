// lib/screens/lobby_screen.dart

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/data_service.dart';
import 'active_tour_screen.dart';

class LobbyScreen extends StatelessWidget {
  final String lobbyCode;
  final bool isHost;

  const LobbyScreen({super.key, required this.lobbyCode, required this.isHost});

  // build lobby screen showing lobby code and participants
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("Lobby Code", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: ecoGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ecoPrimaryGreen, width: 2),
              ),
              child: Text(
                lobbyCode,
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(letterSpacing: 4),
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Participants:",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: ecoPrimaryGreen,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                "${DataService.currentUserName} (You)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.check_circle, color: ecoPrimaryGreen),
            ),

            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                "Dilara (Waiting...)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                "Johanna (Ready!)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.check_circle, color: ecoPrimaryGreen),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                "Milo (Waiting...)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),

            // change button based on host or participant
            const Spacer(),
            if (isHost)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActiveTourScreen(),
                      ),
                    );
                  },
                  child: const Text("Start Game for Everyone"),
                ),
              )
            else
              Text(
                "Waiting for host to start...",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}
