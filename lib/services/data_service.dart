// lib/services/data_service.dart
import '../models/checkpoint.dart';

class DataService {
  static String currentUserName = "Guest";

  static final List<Map<String, dynamic>> tours = [
    {
      "id": "0",
      "title": "Krugpark",
      "subtitle":
          "The Krugpark is a scenic park and nature reserve located in the Wilhelmsdorf district of Brandenburg an der Havel, Germany. It serves as both a recreational area and an environmental education center, combining nature conservation, wildlife care, and sustainable learning in one harmonious setting.",
      "distance": "8 km away",
      "category": "Nature",
      "checkpoints": 16,
      "duration": "2h",
      "image": "assets/images/tour_krugpark.jpg",
    },
    {
      "id": "1",
      "title": "Neustadt",
      "subtitle": "The city district Neustadt became part...",
      "distance": "12 km away",
      "category": "Urban",
      "checkpoints": 8,
      "duration": "1.5h",
      "image": "assets/images/tour_neustadt.jpg",
    },
    {
      "id": "2",
      "title": "Technische Hochschule BRB",
      "subtitle": "The technical University of Brandenburg...",
      "distance": "16 km away",
      "category": "History",
      "checkpoints": 5,
      "duration": "45m",
      "image": "assets/images/tour_thb.jpeg",
    },
  ];

  static Map<String, dynamic> userProfile = {
    "trailsCompleted": 14,
    "badges": 5,
    "totalSteps": 125000,
  };

  static final List<Checkpoint> checkpoints = [
    const Checkpoint(
      id: 0,
      name: 'Memorial Stone',
      description:
          'This stone commemorates ... and his contributions to animal welfare.',
      beaconUuid: 'fda50693-a4e2-4fb1-afcf-c6eb07647825',
      beaconMajor: 10011,
      beaconMinor: 19641,
    ),
  ];
}
