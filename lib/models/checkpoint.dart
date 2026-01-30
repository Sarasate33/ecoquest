// lib/models/checkpoint.dart

class Checkpoint {
  final int id;
  final String name;
  final String description;
  final String beaconUuid;
  final int beaconMajor;
  final int beaconMinor;


  const Checkpoint({
    required this.id,
    required this.name,
    required this.description,
    required this.beaconUuid,
    required this.beaconMajor,
    required this.beaconMinor,
  });
}
