enum DetectionType {
  pothole,
  vehicle,
  blindSpot,
  unknown,
}

class DetectionResult {
  final String id;
  final DetectionType type;
  final String label;
  final double confidence;

  // Bounding box values from YOLO
  final double x;
  final double y;
  final double width;
  final double height;
  final String? severity;

  final DateTime timestamp;

  const DetectionResult({
    required this.id,
    required this.type,
    required this.label,
    required this.confidence,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.severity,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'confidence': confidence,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'severity': severity,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DetectionResult.fromMap(
    Map<String, dynamic> map,
  ) {
    return DetectionResult(
      id: map['id'] ?? '',
      type: _parseType(map['type']),
      label: map['label'] ?? 'Unknown',
      confidence: (map['confidence'] ?? 0).toDouble(),
      x: (map['x'] ?? 0).toDouble(),
      y: (map['y'] ?? 0).toDouble(),
      width: (map['width'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
      severity: map['severity']?.toString(),
      timestamp: DateTime.tryParse(
            map['timestamp'] ?? '',
          ) ??
          DateTime.now(),
    );
  }

  static DetectionType _parseType(dynamic value) {
    switch (value?.toString()) {
      case 'pothole':
        return DetectionType.pothole;

      case 'vehicle':
        return DetectionType.vehicle;

      case 'blindSpot':
        return DetectionType.blindSpot;

      default:
        return DetectionType.unknown;
    }
  }

  DetectionResult copyWith({
    String? id,
    DetectionType? type,
    String? label,
    double? confidence,
    double? x,
    double? y,
    double? width,
    double? height,
    String? severity,
    DateTime? timestamp,
  }) {
    return DetectionResult(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      confidence: confidence ?? this.confidence,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
