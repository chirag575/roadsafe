class Vehicle {
  final String id;
  final String type;
  final String side;
  final double distance;
  final double speed;
  final double ttc;
  final double confidence;
  final DateTime detectedAt;

  const Vehicle({
    required this.id,
    required this.type,
    required this.side,
    required this.distance,
    required this.speed,
    required this.ttc,
    required this.confidence,
    required this.detectedAt,
  });

  bool get isInBlindSpot {
    return side.toLowerCase() == 'left' ||
        side.toLowerCase() == 'right';
  }

  bool get isCritical {
    return ttc > 0 && ttc <= 3.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'side': side,
      'distance': distance,
      'speed': speed,
      'ttc': ttc,
      'confidence': confidence,
      'detectedAt': detectedAt.toIso8601String(),
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] ?? '',
      type: map['type'] ?? 'Unknown',
      side: map['side'] ?? 'Unknown',
      distance: (map['distance'] ?? 0).toDouble(),
      speed: (map['speed'] ?? 0).toDouble(),
      ttc: (map['ttc'] ?? 0).toDouble(),
      confidence: (map['confidence'] ?? 0).toDouble(),
      detectedAt: DateTime.tryParse(
            map['detectedAt'] ?? '',
          ) ??
          DateTime.now(),
    );
  }

  Vehicle copyWith({
    String? id,
    String? type,
    String? side,
    double? distance,
    double? speed,
    double? ttc,
    double? confidence,
    DateTime? detectedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      type: type ?? this.type,
      side: side ?? this.side,
      distance: distance ?? this.distance,
      speed: speed ?? this.speed,
      ttc: ttc ?? this.ttc,
      confidence: confidence ?? this.confidence,
      detectedAt: detectedAt ?? this.detectedAt,
    );
  }
}
