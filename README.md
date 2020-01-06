# Widget Recorder for Flutter

[![pub package](https://img.shields.io/badge/pub-v0.0.1-orange.svg)](https://pub.dartlang.org/packages/widget_recorder)

A [Flutter](https://flutter.dev/) generates an image from a Widget following the provided schedule.

## Usage

* Import the package:
```dart
import 'package:widget_recorder/widget_recorder.dart';
```
* Use it:
```dart
WidgetRecorder(
    child: myWidget,
    onSnapshotReady: (WidgetRecorderSnapshot snapshot) {
        // ...
    }
);
```
