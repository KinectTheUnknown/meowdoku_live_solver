// Real web implementation
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

class WebVideoManagerImpl {
  web.HTMLVideoElement? _videoElement;

  web.HTMLVideoElement? get videoElement => _videoElement;
  int get videoWidth => _videoElement?.videoWidth ?? 0;
  int get videoHeight => _videoElement?.videoHeight ?? 0;

  void initialize(String viewType, VoidCallback onLoadedMetadata) {
    if (_videoElement != null) return;

    final video = web.HTMLVideoElement()
      ..autoplay = true
      ..playsInline = true
      ..muted = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..style.backgroundColor = '#0b0f19';

    video.onloadedmetadata = (web.Event _) {
      onLoadedMetadata();
    }.toJS;

    _videoElement = video;

    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => video,
    );
  }

  void attachStream(web.MediaStream stream) {
    final video = _videoElement;
    if (video != null) {
      video.srcObject = stream;
      video.play();
    }
  }

  void detachStream() {
    if (_videoElement != null) {
      _videoElement!.srcObject = null;
    }
  }

  void dispose() {
    detachStream();
    _videoElement = null;
  }
}
