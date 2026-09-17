import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:web/web.dart' as web;

/// Container holding a captured video frame's raw pixel data and dimensions.
class CapturedFrame({
  required final Uint8List rgbaPixels,
  required final int width,
  required final int height,
  DateTime? timestamp,
}) {
  final DateTime timestamp = timestamp ?? .now();

  /// Total number of pixels in the frame.
  int get pixelCount => width * height;

  /// Converts this captured frame into an [img.Image] for the vision pipeline.
  img.Image toImage() {
    return img.Image.fromBytes(
      width: width,
      height: height,
      bytes: rgbaPixels.buffer,
      order: img.ChannelOrder.rgba,
    );
  }

  /// Retrieves the RGBA values at pixel ([x], [y]).
  ({int r, int g, int b, int a}) getPixel(int x, int y) {
    assert(x >= 0 && x < width && y >= 0 && y < height);
    final offset = (y * width + x) * 4;
    return (
      r: rgbaPixels[offset],
      g: rgbaPixels[offset + 1],
      b: rgbaPixels[offset + 2],
      a: rgbaPixels[offset + 3],
    );
  }
}

/// Zero-copy canvas-based frame extractor that pulls frames from an HTMLVideoElement.
class CanvasFrameGrabber {
  web.HTMLCanvasElement? _canvas;
  web.CanvasRenderingContext2D? _context;

  /// Captures the current frame displayed in [videoElement].
  ///
  /// Returns null if the video has no valid dimensions or is not ready.
  CapturedFrame? captureFrame(web.HTMLVideoElement videoElement) {
    if (!kIsWeb) return null;

    final width = videoElement.videoWidth;
    final height = videoElement.videoHeight;

    if (width <= 0 || height <= 0) return null;

    final canvas = _canvas ??= web.HTMLCanvasElement();
    if (canvas.width != width || canvas.height != height) {
      canvas.width = width;
      canvas.height = height;
      _context = canvas.getContext('2d') as web.CanvasRenderingContext2D?;
    }

    final ctx = _context;
    if (ctx == null) return null;

    // Draw the active video frame to canvas
    ctx.drawImage(videoElement, 0, 0);

    // Extract raw RGBA pixel buffer
    final imageData = ctx.getImageData(0, 0, width, height);
    final uint8Clamped = imageData.data.toDart;
    final rgbaBytes = Uint8List.fromList(uint8Clamped);

    return CapturedFrame(rgbaPixels: rgbaBytes, width: width, height: height);
  }

  /// Cleans up canvas resources.
  void dispose() {
    _canvas = null;
    _context = null;
  }
}
