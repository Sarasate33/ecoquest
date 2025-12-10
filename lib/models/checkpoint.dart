// lib/models/checkpoint.dart

enum ExperienceType { information, quiz, game }

class Checkpoint {
  final String id;
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

  // Convenience: create from a JSON-like map
  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      beaconUuid: (json['beaconUuid'] as String).toLowerCase(),
      beaconMajor: json['beaconMajor'] as int,
      beaconMinor: json['beaconMinor'] as int,
      experienceType: _experienceFromString(json['experienceType'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'beaconUuid': beaconUuid,
    'beaconMajor': beaconMajor,
    'beaconMinor': beaconMinor,
    'experienceType': experienceType.name,
  };

  Checkpoint copyWith({
    String? id,
    String? name,
    String? description,
    String? beaconUuid,
    int? beaconMajor,
    int? beaconMinor,
    ExperienceType? experienceType,
  }) {
    return Checkpoint(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      beaconUuid: (beaconUuid ?? this.beaconUuid).toLowerCase(),
      beaconMajor: beaconMajor ?? this.beaconMajor,
      beaconMinor: beaconMinor ?? this.beaconMinor,
      experienceType: experienceType ?? this.experienceType,
    );
  }

  // Returns true when this checkpoint matches provided beacon identifiers.
  bool matchesBeacon(String uuid, int major, int minor) {
    return beaconUuid.toLowerCase() == uuid.toLowerCase() &&
        beaconMajor == major &&
        beaconMinor == minor;
  }

  static ExperienceType _experienceFromString(String? s) {
    switch (s) {
      case 'quiz':
        return ExperienceType.quiz;
      case 'game':
        return ExperienceType.game;
      case 'information':
      default:
        return ExperienceType.information;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Checkpoint && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
