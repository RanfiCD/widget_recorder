import 'dart:ui';

import 'package:widget_recorder/src/widget_recorder_controller.dart';
import 'package:widget_recorder/src/widget_recorder_snapshot.dart';

class WidgetRecorderSimpleController extends WidgetRecorderController {
  WidgetRecorderSimpleController(
      {pixelRatio = 1.0, scaleFactor = 1.0, byteFormat = ImageByteFormat.png})
      : super(
            pixelRatio: pixelRatio,
            scaleFactor: scaleFactor,
            byteFormat: byteFormat);

  Future<WidgetRecorderSnapshot> takeSnapshot() {
    return this.getSnapshot != null ? this.getSnapshot() : null;
  }
}
