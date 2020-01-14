import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:widget_recorder/widget_recorder.dart';

const Size box_size = Size(180.0, 180.0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestRoute(),
    );
  }
}

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
      child: Icon(Icons.photo_size_select_actual)
    ),
  );
  WidgetRecorderSimpleController _simpleController = WidgetRecorderSimpleController();
  Uint8List _imageBytes;
  Iterable<bool> _selections = [true, false];
  int _currentSelection = 0;
  double _sliderValue = 1;
  bool _pauseRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget Recorder - Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox.expand(
          child: Column(
            children: <Widget>[
              Spacer(flex: 1),
              Flexible(
                flex: 8,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: WidgetRecorder(
                    child: _model,
                    controller: _currentSelection == 0
                      ? _simpleController
                      : WidgetRecorderPeriodicController(
                          startRecording: !_pauseRecording,
                          delay: Duration(seconds: _sliderValue.toInt()),
                          onSnapshotReady: (WidgetRecorderSnapshot snapshot) {
                            Uint8List bytes = snapshot.byteData.buffer.asUint8List();

                            setState(() {
                              _imageBytes = bytes;
                            });
                          }
                        ),
                  ),
                ),
              ),
              Spacer(flex: 1),
              Flexible(
                flex: 8,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: _imageBytes == null
                    ? _defaultImage
                    : Image.memory(_imageBytes, gaplessPlayback: true),
                ),
              ),
              Spacer(flex: 1),
              Flexible(
                flex: 1,
                child: _selections.elementAt(1)
                  ? Slider(
                      min: 1,
                      max: 10,
                      divisions: 9,
                      value: _sliderValue,
                      label: '${_sliderValue.toInt()}s',
                      onChanged: (double value) {
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                    )
                  : Container(),
              ),
              Flexible(
                flex: 1,
                child: _selections.elementAt(0)
                  ? RaisedButton(
                      onPressed: () async {
                        WidgetRecorderSnapshot snapshot = await _simpleController.takeSnapshot();

                        if (snapshot != null) {
                          setState(() {
                            _imageBytes = snapshot.byteData.buffer.asUint8List();
                          });
                        }
                      },
                      child: Icon(Icons.camera_enhance),
                    )
                  : RaisedButton(
                      child: Icon(_pauseRecording ? Icons.play_arrow : Icons.pause),
                      onPressed: () {
                        setState(() {
                          _pauseRecording = !_pauseRecording;
                        });
                      }
                    )
              ),
              Spacer(flex: 1),
              Flexible(
                flex: 1,
                child: ToggleButtons(
                  children: <Widget>[
                    Icon(Icons.camera_alt),
                    Icon(Icons.videocam)
                  ],
                  isSelected: _selections,
                  onPressed: (int idx) {
                    if (_currentSelection != idx) {
                      List<bool> newSelections = [];
                      
                      for (int i = 0; i < _selections.length; i++) {
                        newSelections.add(i == idx);
                      }

                      setState(() {
                        _currentSelection = idx;
                        _selections = newSelections;
                      });
                    }
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
