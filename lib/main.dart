// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/explore_screen.dart';
import 'screens/tour_detail_screen.dart';
import 'screens/start_mode_screen.dart';
import 'screens/active_tour_screen.dart';
import 'screens/settings_screen.dart';
import 'models/tour.dart';
import 'models/checkpoint.dart';

void main() {
  runApp(const EcoQuestApp());
}

class EcoQuestApp extends StatelessWidget {
  const EcoQuestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoQuest',
      theme: ThemeData(
        primaryColor: const Color(0xFF246024),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const MainNavigator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  Tour? _selectedTour;
  bool _isInActiveTour = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isInActiveTour = false;
    });
  }

  void _selectTour(Tour tour) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourDetailScreen(
          tour: tour,
          onStartTour: () => _showStartMode(tour),
        ),
      ),
    );
  }

  void _showStartMode(Tour tour) {
    setState(() {
      _selectedTour = tour;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartModeScreen(
          tour: tour,
          onStartSolo: () => _startActiveTour(tour),
        ),
      ),
    );
  }

  void _startActiveTour(Tour tour) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveTourScreen(
          tour: tour,
          onEndTour: () {
            setState(() {
              _isInActiveTour = false;
              _selectedIndex = 0;
            });
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          onOpenSettings: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ),
    );
  }

  Widget _getScreen() {
    if (_isInActiveTour && _selectedTour != null) {
      return ActiveTourScreen(
        tour: _selectedTour!,
        onEndTour: () {
          setState(() {
            _isInActiveTour = false;
            _selectedIndex = 0;
          });
        },
        onOpenSettings: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
      );
    }

    switch (_selectedIndex) {
      case 0:
        return ExploreScreen(onSelectTour: _selectTour);
      case 1:
        return _buildPlaceholderScreen('Favorites', Icons.favorite);
      case 2:
        return _buildPlaceholderScreen('Trail History', Icons.history);
      case 3:
        return _buildPlaceholderScreen('Profile', Icons.person);
      default:
        return ExploreScreen(onSelectTour: _selectTour);
    }
  }

  Widget _buildPlaceholderScreen(String title, IconData icon) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF246024),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: const Color(0xFF246024)),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This screen is not part of the demo',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF246024),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Inter'),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
