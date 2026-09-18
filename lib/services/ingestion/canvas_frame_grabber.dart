import 'canvas_frame_grabber_stub.dart'
    if (dart.library.js_interop) 'canvas_frame_grabber_web.dart';
import 'captured_frame.dart';

export 'captured_frame.dart';

/// Zero-copy canvas-based frame extractor that pulls frames from an HTMLVideoElement.
class CanvasFrameGrabber {
  final CanvasFrameGrabberImpl _impl = CanvasFrameGrabberImpl();

  /// Captures the current frame displayed in [videoElement].
  CapturedFrame? captureFrame(dynamic videoElement) {
    return _impl.captureFrame(videoElement);
  }

  /// Cleans up canvas resources.
  void dispose() {
    _impl.dispose();
  }
}
