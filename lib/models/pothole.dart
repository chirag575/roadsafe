class Pothole {
  final String id;
  final String severity;
  final double confidence;
  final double latitude;
  final double longitude;
  final double gForce;
  final DateTime detectedAt;
  final String? imagePath;

  const Pothole({
    required this.id,
    required this.severity,
    required this.confidence,
    required this.latitude,
    required this.longitude,
    required this.gForce,
    required this.detectedAt,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'severity': severity,
      'confidence': confidence,
      'latitude': latitude,
      'longitude': longitude,
      'gForce': gForce,
      'detectedAt': detectedAt.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory Pothole.fromMap(Map<String, dynamic> map) {
    return Pothole(
      id: map['id'] ?? '',
      severity: map['severity'] ?? 'Unknown',
      confidence: (map['confidence'] ?? 0).toDouble(),
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      gForce: (map['gForce'] ?? 0).toDouble(),
      detectedAt: DateTime.tryParse(
            map['detectedAt'] ?? '',
          ) ??
          DateTime.now(),
      imagePath: map['imagePath'],
    );
  }

  Pothole copyWith({
    String? id,
    String? severity,
    double? confidence,
    double? latitude,
    double? longitude,
    double? gForce,
    DateTime? detectedAt,
    String? imagePath,
  }) {
    return Pothole(
      id: id ?? this.id,
      severity: severity ?? this.severity,
      confidence: confidence ?? this.confidence,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gForce: gForce ?? this.gForce,
      detectedAt: detectedAt ?? this.detectedAt,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
