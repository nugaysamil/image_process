import 'package:camera/camera.dart';
import 'package:deneme_tflite/services/camera_service.dart';
import 'package:deneme_tflite/services/tflite_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
//  final CameraDescription camera = get_camera();
  Future<void>? _initializeControllerFuture;
  final TensorFlowService _tensorFlowService = TensorFlowService();
  final CameraService _cameraService = CameraService();
//  Prediction _prediction = Prediction();

  // current list of recognition
  List<dynamic> _currentRecognition = [];

  // listens the changes in tensorflow recognitions
   StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // starts camera and then loads the tensorflow model
    startUp();
  }

  startRecognitions() async {
    try {
      // starts the camera stream on every frame and then uses it to recognize the result every 1 second
      _cameraService.startStreaming();
    } catch (e) {
      print('error streaming camera image');
      print(e);
    }
  }

  stopRecognitions() async {
    // closes the streams
    await _cameraService.stopImageStream();
    await _tensorFlowService.stopRecognitions();
  }

  Future startUp() async {
    if (!mounted) {
      return;
    }
    if (_initializeControllerFuture == null) {
      _initializeControllerFuture =
          _cameraService.startService(widget.camera).then((value) async {
        await _tensorFlowService.loadModel();
        startRecognitions();
      });
    } else {
      await _tensorFlowService.loadModel();
      startRecognitions();
    }
  }

  _startRecognitionStreaming() {
    // ignore: unnecessary_null_comparison
    if (_streamSubscription == null) {
      print("AAA");
      _streamSubscription =
          _tensorFlowService.recognitionStream.listen((recognition) {
        if (recognition != null) {
          // rebuilds the screen with the new recognitions
          setState(() {
            _currentRecognition = recognition;
          });
        } else {
          _currentRecognition = [];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Start Detecting Hand Sign"),
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back, color: Colors.black),
//            onPressed: () {
////              stopRecognitions();
////              _streamSubscription.cancel();
//              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
//            }
//        ),
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
//          startUp();
//          return Stack(
//              children:<Widget> [
//                CameraPreview(_cameraService.cameraController),
//                Prediction(),
//              ]
//          );
            if (snapshot.connectionState == ConnectionState.done) {
//            startUp();
//            startRecognitions();
              _startRecognitionStreaming();
              return Stack(children: <Widget>[
                CameraPreview(_cameraService.cameraController),
//                  _prediction,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF120320),
                            ),
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Column(children: <Widget>[
                              // shows recognition title
                              _titleWidget(),

                              // shows recognitions list
                              _contentWidget(),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget _titleWidget() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Recognitions",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 35, 0),
        ),
      ],
    );
  }

  Widget _contentWidget() {
    var width = MediaQuery.of(context).size.width;
    var padding = 20.0;
    var labelWitdth = 150.0;
    var labelConfidence = 30.0;
    var barWitdth = width - labelWitdth - labelConfidence - padding * 2.0;

    if (_currentRecognition.length > 0) {
      return Container(
        height: 150,
        child: ListView.builder(
          itemCount: _currentRecognition.length,
          itemBuilder: (context, index) {
            if (_currentRecognition.length > index) {
              print(_currentRecognition[index]['label']);
              return SizedBox(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: padding, right: padding),
                      width: labelWitdth,
                      child: Text(
                        _currentRecognition[index]['label'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: barWitdth,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        value: _currentRecognition[index]['confidence'],
                      ),
                    ),
                    SizedBox(
                      width: labelConfidence,
                      child: Text(
                        (_currentRecognition[index]['confidence'] * 100)
                                .toStringAsFixed(0) +
                            '%',
                        maxLines: 1,
//                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      );
    } else {
      return const Text('');
    }
  }

  @override
  void dispose() {
    _streamSubscription!.cancel();
    _cameraService.dispose();
    _tensorFlowService.dispose();
    _initializeControllerFuture = null;
//    _streamSubscription?.cancel();
    super.dispose();
  }
}
