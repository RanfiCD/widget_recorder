import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:widget_recorder/src/widget_recorder_snapshot.dart';

typedef SnapshotCallback = Future<WidgetRecorderSnapshot> Function();

abstract class WidgetRecorderController {
  final double pixelRatio;
  final double scaleFactor;
  final ImageByteFormat byteFormat;

  @protected
  SnapshotCallback getSnapshot;

  WidgetRecorderController({
    this.pixelRatio = 1.0,
    this.scaleFactor = 1.0,
    this.byteFormat = ImageByteFormat.png
  });

  @mustCallSuper
  void setCallback(SnapshotCallback callback) => this.getSnapshot = callback;

  @mustCallSuper
  void dispose() => this.getSnapshot = null;
}
