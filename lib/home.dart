import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:camera/camera.dart';

class Home extends StatefulWidget {
  final CameraDescription camera;

  const Home({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//  var tabs = [Home(), CameraScreen(camera:)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Hello! \nWelcome to",
              style: TextStyle(
                color: Color(0xff878787),
                fontSize: 25,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "ASL Interpreter.",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(0xffffffff),
                fontSize: 25,
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "This app allows you to\ntranslate ASL sign letters \nby using\nImage Detection.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color(0xff878787),
                fontSize: 25,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.add_a_photo,
                  color: Color(0xff3ACCE1),
                  size: 30,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Use our AI intergrated in the camera \nto detect the letters.",
                    style: TextStyle(
                        color: Color(0xff41A1FF),
                        fontSize: 15,
                        fontFamily: "Roboto"),
                  ),
                ),
              ]),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.volume_up,
                  color: Color(0xff3ACCE1),
                  size: 30,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Converts texts to speech\nwith a tap.",
                    style: TextStyle(
                        color: Color(0xff41A1FF),
                        fontSize: 15,
                        fontFamily: "Roboto"),
                  ),
                ),
              ]),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.lightbulb,
                  color: Color(0xff3ACCE1),
                  size: 30,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Make sure the hand is well lit\nfor the best results.",
                    style: TextStyle(
                        color: Color(0xff41A1FF),
                        fontSize: 15,
                        fontFamily: "Roboto"),
                  ),
                ),
              ]),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ElevatedButton(
          onPressed: () async {
            final cameras = await availableCameras();

            // Get a specific camera from the list of available cameras.
            final firstCamera = cameras.first;

            // ignore: use_build_context_synchronously
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CameraScreen(camera: firstCamera)));
          },
          child: const Text(
            "SlIDE TO START DETECTING",
            style: TextStyle(
                color: Color(0xff41A1FF),
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: "Roboto"),
          ),
        )
      ]),
    );
  }
}
