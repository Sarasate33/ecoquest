// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Center(
        child: Text("No favorites yet.", style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}