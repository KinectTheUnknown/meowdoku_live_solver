import 'dart:ui_web' as ui_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Controller managing an HTMLVideoElement and its underlying MediaStream.
class VideoPlayerController extends ChangeNotifier {
  final String viewType;
  web.HTMLVideoElement? _videoElement;
  web.MediaStream? _stream;
  bool _isRegistered = false;

  VideoPlayerController({String? viewType})
      : viewType = viewType ?? 'vdo-ninja-player-${DateTime.now().microsecondsSinceEpoch}';

  web.HTMLVideoElement? get videoElement => _videoElement;
  bool get hasStream => _stream != null;
  int get videoWidth => _videoElement?.videoWidth ?? 0;
  int get videoHeight => _videoElement?.videoHeight ?? 0;

  /// Attaches a [web.MediaStream] to the underlying HTMLVideoElement and plays it.
  void attachStream(web.MediaStream stream) {
    if (!kIsWeb) return;

    _stream = stream;
    _ensureInitialized();

    final video = _videoElement;
    if (video != null) {
      video.srcObject = stream;
      video.play();
    }
    notifyListeners();
  }

  /// Detaches the current stream.
  void detachStream() {
    _stream = null;
    if (_videoElement != null) {
      _videoElement!.srcObject = null;
    }
    notifyListeners();
  }

  void _ensureInitialized() {
    if (_isRegistered) return;

    final video = web.HTMLVideoElement()
      ..autoplay = true
      ..playsInline = true
      ..muted = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..style.backgroundColor = '#0b0f19';

    _videoElement = video;

    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => video,
    );

    _isRegistered = true;
  }

  @override
  void dispose() {
    detachStream();
    super.dispose();
  }
}

/// A Flutter widget that renders an HTMLVideoElement on Flutter Web via HtmlElementView.
class VideoPlayerView extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Container(
        color: const Color(0xFF0B0F19),
        child: const Center(
          child: Text(
            'Video streaming is only supported on Web.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return HtmlElementView(
      viewType: controller.viewType,
    );
  }
}
