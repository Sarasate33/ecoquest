import 'package:flutter/material.dart';
import '../models/tour.dart';
import '../models/checkpoint.dart';

class ExploreScreen extends StatefulWidget {
  final void Function(Tour) onSelectTour;

  const ExploreScreen({Key? key, required this.onSelectTour}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<Tour> _tours = [];

  void _createDemoTour(BuildContext context) {
    final checkpoint = const Checkpoint(
      id: 'oak-tree',
      name: 'Ancient Oak Tree',
      description: 'Learn about the 300-year-old oak and its ecosystem',
      beaconUuid: 'fda50693-a4e2-4fb1-afcf-c6eb07647825',
      beaconMajor: 10011,
      beaconMinor: 19641,
      experienceType: ExperienceType.information,
    );

    final tour = Tour(
      id: 'demo-tour-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Demo Trail (Oak Tree)',
      description: 'A short demo trail to test beacon detection.',
      checkpoints: [checkpoint],
      estimatedMinutes: 15,
      difficulty: 'easy',
    );

    setState(() {
      _tours.insert(0, tour);
    });

    // Immediately open the tour detail for convenience
    widget.onSelectTour(tour);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: const Color(0xFF246024),
      ),
      body: _tours.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No tours yet', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _createDemoTour(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF246024),
                    ),
                    child: const Text('Create Demo Tour'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _tours.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final t = _tours[i];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(
                    t.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${t.totalCheckpoints} checkpoint(s) • ${t.estimatedMinutes} min',
                  ),
                  onTap: () => widget.onSelectTour(t),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF246024),
        onPressed: () => _createDemoTour(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
