// lib/models/checkpoint.dart

enum ExperienceType { information, quiz, game }

class Checkpoint {
  final int id;
  final String name;
  final String description;
  final String beaconUuid;
  final int beaconMajor;
  final int beaconMinor;
  final ExperienceType experienceType;

  const Checkpoint({
    required this.id,
    required this.name,
    required this.description,
    required this.beaconUuid,
    required this.beaconMajor,
    required this.beaconMinor,
    required this.experienceType,
  });
}
