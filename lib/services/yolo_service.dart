import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/detection_result.dart';

class YoloService {
  static const String potholeModelAsset = 'models/pothole_model.tflite';
  static const String blindSpotModelAsset = 'models/blindspot_model.tflite';
  static const String defaultModelAsset = potholeModelAsset;
  static const double _confidenceThreshold = 0.25;

  Interpreter? _interpreter;
  String _activeModelAsset = defaultModelAsset;
  int _inputWidth = 640;
  int _inputHeight = 640;
  bool _loading = false;

  bool get isLoaded => _interpreter != null;

  Future<void> loadPotholeModel() => loadModel(modelAsset: potholeModelAsset);

  Future<void> loadBlindSpotModel() => loadModel(modelAsset: blindSpotModelAsset);

  Future<void> loadModel({String modelAsset = defaultModelAsset}) async {
    if (_loading) return;
    if (_interpreter != null && _activeModelAsset == modelAsset) return;

    _loading = true;
    try {
      if (_interpreter != null) {
        _interpreter!.close();
        _interpreter = null;
      }

      _interpreter = await Interpreter.fromAsset(modelAsset);
      _activeModelAsset = modelAsset;

      final shape = _interpreter!.getInputTensor(0).shape;
      if (shape.length == 4) {
        _inputHeight = shape[1];
        _inputWidth = shape[2];
      }
      debugPrint('YOLO model loaded from $modelAsset');
    } on Object catch (error) {
      debugPrint('YOLO model unavailable: $error');
      rethrow;
    } finally {
      _loading = false;
    }
  }

  Future<List<DetectionResult>> detect(CameraImage image) async {
    final interpreter = _interpreter;
    if (interpreter == null) return const [];

    final input = _createInput(image);
    final outputTensor = interpreter.getOutputTensor(0);
    final output = List.filled(
      outputTensor.shape.reduce((a, b) => a * b),
      0.0,
    ).reshape(outputTensor.shape);
    interpreter.run(input, output);
    return _parseOutput(output, outputTensor.shape);
  }

  List<List<List<List<double>>>> _createInput(CameraImage image) {
    final pixels = List.generate(
      1,
      (_) => List.generate(
        _inputHeight,
        (y) => List.generate(
          _inputWidth,
          (x) {
            final sourceX =
                min(image.width - 1, x * image.width ~/ _inputWidth);
            final sourceY =
                min(image.height - 1, y * image.height ~/ _inputHeight);
            final rgb = _yuvToRgb(image, sourceX, sourceY);
            return <double>[
              rgb[0] / 255.0,
              rgb[1] / 255.0,
              rgb[2] / 255.0,
            ];
          },
        ),
      ),
    );
    return pixels;
  }

  List<int> _yuvToRgb(CameraImage image, int x, int y) {
    final yPlane = image.planes[0];
    final uPlane = image.planes.length > 1 ? image.planes[1] : yPlane;
    final vPlane = image.planes.length > 2 ? image.planes[2] : yPlane;
    final yValue = yPlane.bytes[
      y * yPlane.bytesPerRow + x * (yPlane.bytesPerPixel ?? 1)];
    final uvX = x ~/ 2;
    final uvY = y ~/ 2;
    final u = uPlane.bytes[
      uvY * uPlane.bytesPerRow + uvX * (uPlane.bytesPerPixel ?? 1)];
    final v = vPlane.bytes[
      uvY * vPlane.bytesPerRow + uvX * (vPlane.bytesPerPixel ?? 1)];
    final red = (yValue + 1.402 * (v - 128)).round().clamp(0, 255);
    final green = (yValue - 0.344136 * (u - 128) - 0.714136 * (v - 128))
        .round()
        .clamp(0, 255);
    final blue = (yValue + 1.772 * (u - 128)).round().clamp(0, 255);
    return [red, green, blue];
  }

  List<DetectionResult> _parseOutput(Object output, List<int> shape) {
    final values = _flatten(output);
    if (values.isEmpty) return const [];
    final channelFirst = shape.length == 3 && shape[1] <= 10;
    final candidateCount = shape.length == 3
        ? (channelFirst ? shape[2] : shape[1])
        : values.length ~/ 6;
    final channelCount = shape.length == 3
        ? (channelFirst ? shape[1] : shape[2])
        : 6;
    final detections = <DetectionResult>[];

    for (var index = 0; index < candidateCount; index++) {
      double value(int channel) {
        if (channelFirst) return values[channel * candidateCount + index];
        return values[index * channelCount + channel];
      }

      if (channelCount < 5) continue;
      final confidence = value(4);
      if (confidence < _confidenceThreshold) continue;

      var x = value(0);
      var y = value(1);
      var width = value(2);
      var height = value(3);
      if (x > 1 || y > 1 || width > 1 || height > 1) {
        x /= _inputWidth;
        y /= _inputHeight;
        width /= _inputWidth;
        height /= _inputHeight;
      }
      detections.add(
        DetectionResult(
          id: 'pothole_${DateTime.now().microsecondsSinceEpoch}_$index',
          type: DetectionType.pothole,
          label: 'Pothole',
          confidence: confidence.clamp(0.0, 1.0),
          x: (x - width / 2).clamp(0.0, 1.0),
          y: (y - height / 2).clamp(0.0, 1.0),
          width: width.clamp(0.0, 1.0),
          height: height.clamp(0.0, 1.0),
          severity: confidence >= 0.8
              ? 'High'
              : confidence >= 0.5
                  ? 'Medium'
                  : 'Low',
          timestamp: DateTime.now(),
        ),
      );
    }
    return detections;
  }

  List<double> _flatten(Object value) {
    if (value is num) return [value.toDouble()];
    if (value is List) {
      return value.expand<double>((item) => _flatten(item)).toList();
    }
    if (value is Float32List) return value.toList();
    return const [];
  }

  Future<void> dispose() async {
    _interpreter?.close();
    _interpreter = null;
  }
}
