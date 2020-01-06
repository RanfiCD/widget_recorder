import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:widget_recorder/widget_recorder.dart';

const Size box_size = Size(180.0, 180.0);

class TestRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestRouteState();
}

class _TestRouteState extends State<TestRoute> {
  Widget _model = ControlledAnimation(
    playback: Playback.MIRROR,
    duration: Duration(seconds: 3),
    tween: ColorTween(begin: Colors.blue, end: Colors.red),
    builder: (BuildContext context, dynamic value) {
      return Container(
          color: value,
          width: box_size.width,
          height: box_size.height
        );
    },
  );
  Widget _defaultImage = Container(
    color: Colors.grey,
    width: box_size.width,
    height: box_size.height,
    child: Center(
      child: Icon(Icons.camera_alt)
    ),
  );
  Uint8List _imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget Recorder - Example'),
      ),
      body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(height: 45.0),
                  WidgetRecorder(
                    child: _model,
                    pause: false,
                    delay: Duration(seconds: 1),
                    onSnapshotReady: (WidgetRecorderSnapshot snapshot) {
                      setState(() {
                        _imageBytes = snapshot.byteData.buffer.asUint8List();
                      });
                    },
                  ),
                  SizedBox(height: 45.0),
                  _imageBytes == null
                    ? _defaultImage
                    : Image.memory(_imageBytes)
                ],
              ),
            ),
          ),
        ),
    );
  }
}