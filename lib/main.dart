// EcoQuest Prototyp - Fixed Errors & Updated Colors
//
// BENÖTIGTE PACKAGES (in pubspec.yaml hinzufügen für echte App):
// - flutter_blue_plus: ^1.30.0 (für echtes BLE)
// - permission_handler: ^11.0.0 (für Bluetooth Berechtigungen)

import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/landing_screen.dart';


void main() {
  runApp(const EcoQuestApp());
}

class EcoQuestApp extends StatelessWidget {
  const EcoQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoQuest Prototype',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LandingScreen(),
    );
  }
}