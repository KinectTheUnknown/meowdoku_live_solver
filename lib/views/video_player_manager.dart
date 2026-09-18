import 'package:flutter/widgets.dart';
import 'video_player_stub.dart'
    if (dart.library.js_interop) 'video_player_web.dart';

/// Service/Manager that manages the underlying HTMLVideoElement on Web.
class WebVideoManager {
  final WebVideoManagerImpl _impl = WebVideoManagerImpl();

  dynamic get videoElement => _impl.videoElement;
  int get videoWidth => _impl.videoWidth;
  int get videoHeight => _impl.videoHeight;

  void initialize(String viewType, VoidCallback onLoadedMetadata) {
    _impl.initialize(viewType, onLoadedMetadata);
  }

  void attachStream(dynamic stream) {
    _impl.attachStream(stream);
  }

  void detachStream() {
    _impl.detachStream();
  }

  void dispose() {
    _impl.dispose();
  }
}
