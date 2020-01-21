# Widget Recorder for Flutter

[![pub package](https://img.shields.io/badge/pub-v0.2.0-orange.svg)](https://pub.dartlang.org/packages/widget_recorder)

A [Flutter](https://flutter.dev/) package to create images from a Widget.

## Usage

* **Import the package**:
```dart
import 'package:widget_recorder/widget_recorder.dart';
```
* **Use it**:
```dart
...
WidgetRecorder(
    child: myWidget,
    controller: WidgetRecorderPeriodicController(),
    onSnapshotTaken: (WidgetRecorderSnapshot snapshot) {
        Uint8List bytes = snapshot.byteData.buffer.asUint8List();
        Image image = Image.memory(bytes);

        setState((){
            _myImage = image;
        });
    }
),
...
```
* **Examples**:
  
Individual screenshots:
  
![screenshots_example](https://user-images.githubusercontent.com/14138939/72353114-c5aac280-36e3-11ea-947d-fea89fd044e9.gif)

Recording:

![recording_example](https://user-images.githubusercontent.com/14138939/72353128-c9d6e000-36e3-11ea-9734-8368f7d00f6f.gif)
