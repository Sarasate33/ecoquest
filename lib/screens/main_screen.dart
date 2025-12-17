// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ExploreScreen(),
    const FavoritesScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      backgroundColor: Color(0xFFdee7de),
      selectedItemColor: ecoPrimaryGreen,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/icon_explore.png', width: 33, height: 33, color: Colors.grey),
          activeIcon: Image.asset('assets/images/icon_explore.png', width: 33, height: 33, color: ecoPrimaryGreen),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/icon_favorites.png', width: 33, height: 33, color: Colors.grey),
          activeIcon: Image.asset('assets/images/icon_favorites.png', width: 33, height: 33, color: ecoPrimaryGreen),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/icon_history.png', width: 33, height: 33, color: Colors.grey),
          activeIcon: Image.asset('assets/images/icon_history.png', width: 33, height: 33, color: ecoPrimaryGreen),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/icon_profile.png', width: 33, height: 33, color: Colors.grey),
          activeIcon: Image.asset('assets/images/icon_profile.png', width: 33, height: 33, color: ecoPrimaryGreen),
          label: '',
        ),
      ],
    ),
    );
  }
}