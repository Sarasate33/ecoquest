// lib/models/tour.dart

import 'checkpoint.dart';

class Tour {
  final String id;
  final String title;
  final String description;
  final List<Checkpoint> checkpoints;
  final int estimatedMinutes;
  final String difficulty;
  final String? imageAsset;

  const Tour({
    required this.id,
    required this.title,
    required this.description,
    required this.checkpoints,
    this.estimatedMinutes = 0,
    this.difficulty = 'easy',
    this.imageAsset,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    final cps = (json['checkpoints'] as List<dynamic>? ?? [])
        .map((e) => Checkpoint.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return Tour(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      checkpoints: cps,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'easy',
      imageAsset: json['imageAsset'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'checkpoints': checkpoints.map((c) => c.toJson()).toList(),
    'estimatedMinutes': estimatedMinutes,
    'difficulty': difficulty,
    'imageAsset': imageAsset,
  };

  Tour copyWith({
    String? id,
    String? title,
    String? description,
    List<Checkpoint>? checkpoints,
    int? estimatedMinutes,
    String? difficulty,
    String? imageAsset,
  }) {
    return Tour(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      checkpoints: checkpoints ?? this.checkpoints,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      difficulty: difficulty ?? this.difficulty,
      imageAsset: imageAsset ?? this.imageAsset,
    );
  }

  int get totalCheckpoints => checkpoints.length;

  // Utility: find checkpoint by beacon minor (used by some beacon logic)
  Checkpoint? findByMinor(int minor) {
    for (final c in checkpoints) {
      if (c.beaconMinor == minor) return c;
    }
    return null;
  }
}
