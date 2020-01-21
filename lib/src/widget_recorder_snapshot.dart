import 'dart:typed_data';
import 'dart:ui';

class WidgetRecorderSnapshot {
  final Size widgetSize;
  final double pixelRatio;
  final double scaleFactor;
  final ImageByteFormat byteFormat;
  final ByteData byteData;

  WidgetRecorderSnapshot(
      {this.widgetSize,
      this.pixelRatio,
      this.scaleFactor,
      this.byteFormat,
      this.byteData});
}
