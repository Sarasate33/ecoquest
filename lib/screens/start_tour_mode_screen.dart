// lib/screens/start_tour_mode_screen.dart

import 'package:flutter/material.dart';
import 'dart:math';
import '../config/theme.dart';
import 'lobby_screen.dart';
import 'active_tour_screen.dart';

class StartTourModeScreen extends StatefulWidget {
  const StartTourModeScreen({super.key});

  @override
  State<StartTourModeScreen> createState() => _StartTourModeScreenState();
}

class _StartTourModeScreenState extends State<StartTourModeScreen> {
  final TextEditingController _lobbyCodeController = TextEditingController();

  // different function depending on selected mode
  void _createLobby() {
    final code = (100000 + Random().nextInt(900000)).toString(); // generate random 6-digit code
    Navigator.push(context, MaterialPageRoute(builder: (context) => LobbyScreen(lobbyCode: code, isHost: true)));
  }

  void _joinLobby() {
    // simple validation for 6-digit code
    if (_lobbyCodeController.text.length == 6) { // check code length
      Navigator.push(context, MaterialPageRoute(builder: (context) => LobbyScreen(lobbyCode: _lobbyCodeController.text, isHost: false)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid 6-digit code.")));
    }
  }

  void _startSolo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ActiveTourScreen())); // start active tour directly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start a tour", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Choose your mode:",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            ElevatedButton.icon(
              onPressed: _startSolo,
              icon: const Icon(Icons.person),
              label: const Text("Play Solo"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.all(16)),
            ),
            
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            
            Text(
              "Group Play",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            ElevatedButton.icon(
              onPressed: _createLobby,
              icon: const Icon(Icons.add),
              label: const Text("Create New Lobby"),
            ),
            const SizedBox(height: 20),
            Text("- OR -", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lobbyCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      hintText: "Enter Code",
                      counterText: "",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _joinLobby,
                  style: ElevatedButton.styleFrom(backgroundColor: ecoFreshOrange),
                  child: const Text("Join"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}