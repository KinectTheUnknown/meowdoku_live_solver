import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'captured_frame.dart';

class CanvasFrameGrabberImpl {
  web.HTMLCanvasElement? _canvas;
  web.CanvasRenderingContext2D? _context;

  CapturedFrame? captureFrame(dynamic videoElement) {
    if (videoElement == null) return null;
    final video = videoElement as web.HTMLVideoElement;

    final width = video.videoWidth;
    final height = video.videoHeight;

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
    ctx.drawImage(video, 0, 0);

    // Extract raw RGBA pixel buffer with zero-copy view
    final imageData = ctx.getImageData(0, 0, width, height);
    final uint8Clamped = imageData.data.toDart;
    final rgbaBytes = uint8Clamped.buffer.asUint8List(
      uint8Clamped.offsetInBytes,
      uint8Clamped.lengthInBytes,
    );

    return CapturedFrame(rgbaPixels: rgbaBytes, width: width, height: height);
  }

  void dispose() {
    _canvas = null;
    _context = null;
  }
}
