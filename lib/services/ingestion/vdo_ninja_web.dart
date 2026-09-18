import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vdoninja_sdk/vdoninja_sdk.dart';
import 'package:web/web.dart' as web;
import 'vdo_ninja_service.dart';

abstract class VdoNinjaPlatformAdapter {
  Future<void> initialize();
  Future<void> viewStream(String streamId, {String? room, String? password});
  Future<void> disconnect();
  void dispose();
}

VdoNinjaPlatformAdapter createVdoNinjaAdapter({
  required void Function(VdoStreamStatus status) onStatusChanged,
  required void Function(String message) onError,
  required void Function(dynamic stream) onStreamAvailable,
}) {
  return VdoNinjaWebAdapter(
    onStatusChanged: onStatusChanged,
    onError: onError,
    onStreamAvailable: onStreamAvailable,
  );
}

class VdoNinjaWebAdapter implements VdoNinjaPlatformAdapter {
  final void Function(VdoStreamStatus status) onStatusChanged;
  final void Function(String message) onError;
  final void Function(dynamic stream) onStreamAvailable;

  VDONinjaSDK? _sdk;
  StreamSubscription<void>? _connectedSub;
  StreamSubscription<void>? _disconnectedSub;
  StreamSubscription<VDONinjaErrorEvent>? _errorSub;
  StreamSubscription<VDONinjaTrackEvent>? _trackSub;
  String? _activeStreamId;

  VdoNinjaWebAdapter({
    required this.onStatusChanged,
    required this.onError,
    required this.onStreamAvailable,
  });

  @override
  Future<void> initialize() async {
    await VDONinjaSDK.initialize();
  }

  @override
  Future<void> viewStream(String streamId, {String? room, String? password}) async {
    await disconnect();
    _activeStreamId = streamId;

    final sdk = VDONinjaSDK(
      debug: kDebugMode,
      password: password != null ? .string(password) : null,
    );
    _sdk = sdk;

    _connectedSub = sdk.onConnected.listen((_) {
      onStatusChanged(VdoStreamStatus.connected);
    });

    _disconnectedSub = sdk.onDisconnected.listen((_) {
      onStatusChanged(VdoStreamStatus.idle);
    });

    _errorSub = sdk.onError.listen((event) {
      onError(event.message);
    });

    _trackSub = sdk.onTrack.listen((event) {
      if (event.streams.isNotEmpty) {
        final stream = event.streams.first;
        if (stream.isA<web.MediaStream>()) {
          onStreamAvailable(stream);
        }
      }
    });

    await sdk.connect();

    if (room != null && room.isNotEmpty) {
      await sdk.joinRoom(
        room: room,
        password: password != null ? .string(password) : null,
      );
    }

    await sdk.view(streamId, audio: false, video: true);
    onStatusChanged(VdoStreamStatus.viewing);
  }

  @override
  Future<void> disconnect() async {
    _cancelSubscriptions();
    _cleanupSdk();
  }

  void _cancelSubscriptions() {
    _connectedSub?.cancel();
    _disconnectedSub?.cancel();
    _errorSub?.cancel();
    _trackSub?.cancel();

    _connectedSub = null;
    _disconnectedSub = null;
    _errorSub = null;
    _trackSub = null;
  }

  void _cleanupSdk() {
    final activeId = _activeStreamId;
    if (activeId != null && _sdk != null) {
      try {
        _sdk!.stopViewing(activeId);
        _sdk!.disconnect();
      } catch (_) {}
    }
    _activeStreamId = null;
    _sdk = null;
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    _cleanupSdk();
  }
}
