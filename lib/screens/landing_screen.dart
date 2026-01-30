// lib/screens/landing_screen.dart

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/data_service.dart';
import 'main_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _enterApp() {
    if (_nameController.text.isNotEmpty) {
      DataService.currentUserName = _nameController.text;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name to start.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontFamily: fontTitle,
      fontWeight: FontWeight.w700,
      fontSize: 32,
    );

    return Scaffold(
      backgroundColor: ecoPrimaryGreen,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Icon
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 24),

              // EcoQuest Text mit orangem Q
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Eco',
                      style: titleStyle.copyWith(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'Q',
                      style: titleStyle.copyWith(color: ecoFreshOrange),
                    ),
                    TextSpan(
                      text: 'uest',
                      style: titleStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),

              Text(
                "Discover Nature & History",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name...",
                  prefixIcon: Icon(Icons.person, color: ecoPrimaryGreen),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _enterApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ecoFreshOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Start Journey",
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}