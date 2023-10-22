import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class TensorFlowService {
  // singleton boilerplate
  static final TensorFlowService _tensorflowService =
      TensorFlowService._internal();

  factory TensorFlowService() {
    return _tensorflowService;
  }
  // singleton boilerplate
  TensorFlowService._internal();

  // ignore: close_sinks
  StreamController<List<dynamic>?> _recognitionController =
      StreamController<List<dynamic>>.broadcast();
  Stream get recognitionStream => _recognitionController.stream;

  bool _modelLoaded = false;

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/tenserflow/model_unquant.tflite",
        labels: "assets/labels.txt",
      );
      _modelLoaded = true;
    } catch (e) {
      print('error loading model');
      print(e);
    }
  }

  Future<void> runModel(CameraImage img) async {
    if (_modelLoaded) {
      List<dynamic>? recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(), // required
        imageHeight: img.height,
        imageWidth: img.width,
        numResults: 3,
      );
      print(recognitions);
      // shows recognitions on screen
        if (_recognitionController.isClosed) {
          // restart if was closed
          _recognitionController = StreamController();
        }
//        // notify to listeners
        _recognitionController.add(recognitions!);
      
    }
  }

  Future<void> stopRecognitions() async {
    if (!_recognitionController.isClosed) {
      _recognitionController.add(null);
      _recognitionController.close();
    }
  }

  void dispose() async {
    Tflite.close();
    _recognitionController.close();
  }
}
