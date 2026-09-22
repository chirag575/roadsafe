import 'package:flutter_test/flutter_test.dart';
import 'package:roadsafe_ai/services/yolo_service.dart';

void main() {
  test('uses the expected pothole and blind spot model assets', () {
    expect(
      YoloService.potholeModelAsset,
      'models/pothole_model.tflite',
    );
    expect(
      YoloService.blindSpotModelAsset,
      'models/blindspot_model.tflite',
    );
    expect(
      YoloService.defaultModelAsset,
      YoloService.potholeModelAsset,
    );
  });
}
