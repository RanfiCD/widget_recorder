import 'dart:async';
import 'dart:ui';

import 'package:widget_recorder/src/widget_recorder_controller.dart';
import 'package:widget_recorder/src/widget_recorder_snapshot.dart';

class WidgetRecorderPeriodicController extends WidgetRecorderController {
  final Duration delay;
  final Function(WidgetRecorderSnapshot) onSnapshotReady;

  Timer _timer;
  bool pause;

  WidgetRecorderPeriodicController(
      {double pixelRatio = 1.0,
      double scaleFactor = 1.0,
      ImageByteFormat byteFormat = ImageByteFormat.png,
      this.delay = const Duration(seconds: 1),
      this.pause = false,
      this.onSnapshotReady})
      : super(
            pixelRatio: pixelRatio,
            scaleFactor: scaleFactor,
            byteFormat: byteFormat);

  @override
  void setCallback(SnapshotCallback callback) {
    super.setCallback(callback);
    //
    start();
  }

  @override
  void dispose() {
    super.dispose();
    //
    stop();
  }

  void start() {
    if (_timer == null) {
      _timer = Timer.periodic(delay, _takeSnapshot);
    }
  }

  void stop() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void _takeSnapshot(Timer timer) async {
    if (!pause && this.getSnapshot != null) {
      WidgetRecorderSnapshot snapshot = await this.getSnapshot();

      if (snapshot != null && this.onSnapshotReady != null) {
        onSnapshotReady(snapshot);
      }
    }
  }
}
