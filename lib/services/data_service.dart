// lib/services/data_service.dart

class DataService {
  static String currentUserName = "Guest";

  static final List<Map<String, dynamic>> tours = [
    {
      "id": "t1",
      "title": "Krugpark",
      "subtitle": "The Krugpark is a recreational forest...",
      "distance": "8 km away",
      "category": "Nature",
      "checkpoints": 16,
      "duration": "2h",
      "image": "assets/images/tour_krugpark.jpg",
    },
    {
      "id": "t2",
      "title": "Neustadt",
      "subtitle": "The city district Neustadt became part...",
      "distance": "12 km away",
      "category": "Urban",
      "checkpoints": 8,
      "duration": "1.5h",
      "image": "assets/images/tour_neustadt.jpg",
    },
    {
      "id": "t3",
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
}