class DatasetInfo {
  final String name;
  final String type;
  final int totalImages;
  final int trainCount;
  final int validCount;
  final int testCount;
  final String? description;
  final String? datasetUrl;
  final String? localPath;
  final String? modelPath;

  const DatasetInfo({
    required this.name,
    required this.type,
    required this.totalImages,
    required this.trainCount,
    required this.validCount,
    required this.testCount,
    this.description,
    this.datasetUrl,
    this.localPath,
    this.modelPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'totalImages': totalImages,
      'trainCount': trainCount,
      'validCount': validCount,
      'testCount': testCount,
      'description': description,
      'datasetUrl': datasetUrl,
      'localPath': localPath,
      'modelPath': modelPath,
    };
  }

  factory DatasetInfo.fromMap(Map<String, dynamic> map) {
    return DatasetInfo(
      name: map['name'] ?? 'Unknown',
      type: map['type'] ?? 'Unknown',
      totalImages: map['totalImages'] ?? 0,
      trainCount: map['trainCount'] ?? 0,
      validCount: map['validCount'] ?? 0,
      testCount: map['testCount'] ?? 0,
      description: map['description'],
      datasetUrl: map['datasetUrl'],
      localPath: map['localPath'],
      modelPath: map['modelPath'],
    );
  }

  DatasetInfo copyWith({
    String? name,
    String? type,
    int? totalImages,
    int? trainCount,
    int? validCount,
    int? testCount,
    String? description,
    String? datasetUrl,
    String? localPath,
    String? modelPath,
  }) {
    return DatasetInfo(
      name: name ?? this.name,
      type: type ?? this.type,
      totalImages: totalImages ?? this.totalImages,
      trainCount: trainCount ?? this.trainCount,
      validCount: validCount ?? this.validCount,
      testCount: testCount ?? this.testCount,
      description: description ?? this.description,
      datasetUrl: datasetUrl ?? this.datasetUrl,
      localPath: localPath ?? this.localPath,
      modelPath: modelPath ?? this.modelPath,
    );
  }
}

class RoadSafeDatasets {
  static const pothole = DatasetInfo(
    name: 'Pothole Detection Dataset',
    type: 'YOLOv8 Object Detection',
    totalImages: 9034,
    trainCount: 6335,
    validCount: 1808,
    testCount: 891,
    description: 'Dataset used for training pothole detection model',
    datasetUrl: 'C:/Users/chira/Downloads/Potholes Detection.yolov8.zip',
    localPath: 'pothole/',
    modelPath: 'models/pothole_model.tflite',
  );

  static const blindSpot = DatasetInfo(
    name: 'Indian Traffic Objects Dataset',
    type: 'YOLOv8 Object Detection',
    totalImages: 2766,
    trainCount: 1936,
    validCount: 553,
    testCount: 277,
    description: 'Dataset used for blindspot and vehicle detection',
    datasetUrl: 'C:/Users/chira/Downloads/Indian traffic objects.yolov8.zip',
    localPath: 'blindspot/',
    modelPath: 'models/blindspot_model.tflite',
  );
}