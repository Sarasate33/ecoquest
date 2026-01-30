// lib/screens/explore_screen.dart

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/data_service.dart';
import 'tour_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}
// filters and filter logic
class _ExploreScreenState extends State<ExploreScreen> {
  String selectedFilter = "All";
  final List<String> filters = ["All", "Nature", "History", "Urban", "Group"];

  @override
  Widget build(BuildContext context) {
    final displayTours = selectedFilter == "All"
        ? DataService.tours
        : DataService.tours.where((t) => t['category'] == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Places",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: filters.map((filter) {
                final isSelected = selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: ecoPrimaryGreen,
                    backgroundColor: ecoSoftSage.withOpacity(0.3),
                    labelStyle: TextStyle(
                      fontFamily: fontTitle,
                      color: isSelected ? Colors.white : ecoTextBlack,
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: displayTours.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final tour = displayTours[index];
                return _buildTourCard(context, tour);
              },
            ),
          ),
        ],
      ),
    );
  }

// build card for each tour, data provided by data_sercvice.dart
  Widget _buildTourCard(BuildContext context, Map<String, dynamic> tour) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TourDetailScreen(tour: tour)),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: ecoGrey,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: AssetImage(tour['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          tour['category'],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: ecoSoftSage.withOpacity(0.2),
                      ),
                      const Icon(Icons.favorite_border, size: 20),
                    ],
                  ),
                  Text(
                    tour['title'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    tour['subtitle'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, //prevent overflow
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      Text(
                        " ${tour['distance']}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}