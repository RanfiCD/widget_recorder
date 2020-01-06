import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widget_recorder/src/widget_recorder_snapshot.dart';

export 'package:widget_recorder/src/widget_recorder_snapshot.dart';

/// A [Widget] that generates an image from a Widget following the provided schedule.
class WidgetRecorder extends StatefulWidget {
  /// The [Widget] from where to get image. 
  final Widget child;

  /// If this is true, the recording will stop.
  final bool pause;

  /// Increase or decrease this value to modify
  /// the generated image quality.
  final double pixelRatio;

  /// Increase or decrease this value to modify
  /// the scale of the generated image. 
  final double scaleFactor;

  /// Choose the [ImageByteFormat] of the generated image.
  final ui.ImageByteFormat byteFormat;

  /// How much time will pass between snapshots.
  final Duration delay;

  /// Callback from where to get the generated image.
  final Function(WidgetRecorderSnapshot) onSnapshotReady;

  WidgetRecorder({
    @required this.child,
    this.pause = false,
    this.pixelRatio = 1.0,
    this.scaleFactor = 1.0,
    this.byteFormat = ui.ImageByteFormat.png,
    this.delay = const Duration(),
    @required this.onSnapshotReady
  }): assert(child != null), assert(onSnapshotReady != null);

  @override
  State<StatefulWidget> createState() => _WidgetRecorderState();
}

class _WidgetRecorderState extends State<WidgetRecorder> {
  _WidgetRecorderState();

  final GlobalKey _globalKey = GlobalKey();
  
  Duration _lastDelay;
  StreamSubscription<WidgetRecorderSnapshot> _snapshotSub;
  RenderObject _renderObject;

  @override
  void initState() {
    super.initState();

    _lastDelay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(afterBuild);

    return RepaintBoundary(
      key: _globalKey,
      child: widget.child,
    );
  }

  void afterBuild(_) {
    // If it's pause or the delay time changes, cancel the previous snapshot.
    if (_snapshotSub != null && (_lastDelay != widget.delay || widget.pause)) {
      _snapshotSub.cancel();
      _snapshotSub = null;
    }
    // If it's not pause and there is no pending snapshot, request a new one.
    if (!widget.pause && _snapshotSub == null) {
      _snapshotSub = _getSnapshot().asStream().listen((WidgetRecorderSnapshot snapshot) {
        if (snapshot != null) {
          widget.onSnapshotReady(snapshot);
        }
        
        _snapshotSub = null;
        if (this.mounted) {
          setState(() {
            //
          });
        }
      });
    }
  }

  Future<WidgetRecorderSnapshot> _getSnapshot() async {
    await Future.delayed(widget.delay);

    RenderRepaintBoundary repaintBoundary = _getRepaintBoundary();
    WidgetRecorderSnapshot snapshot;

    if (!repaintBoundary.debugNeedsPaint) {
      Size widgetSize = repaintBoundary.size;
      ui.Image image = await repaintBoundary.toImage(pixelRatio: widget.pixelRatio);
      ByteData byteData = await image.toByteData(format: widget.byteFormat);

      if (widget.scaleFactor != 1.0) {
        final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
          byteData.buffer.asUint8List(),
          targetWidth: (widgetSize.width * widget.scaleFactor).toInt(),
          targetHeight: (widgetSize.height * widget.scaleFactor).toInt()
        );
        final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
        byteData = await frameInfo.image.toByteData(format: widget.byteFormat);
      }
      
      snapshot = WidgetRecorderSnapshot(
        widgetSize: widgetSize,
        pixelRatio: widget.pixelRatio,
        scaleFactor: widget.scaleFactor,
        byteFormat: widget.byteFormat,
        byteData: byteData
      );
    }
    
    return snapshot;
  }

  RenderRepaintBoundary _getRepaintBoundary() {
    if (_renderObject == null) {
      _renderObject = _globalKey.currentContext.findRenderObject();
    }

    return _renderObject;
  }
}

