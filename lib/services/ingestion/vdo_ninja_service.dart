import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vdoninja_sdk/vdoninja_sdk.dart';
import 'package:web/web.dart' as web;

/// State representing the VDO.Ninja connection and video stream.
enum VdoStreamStatus {
  idle,
  initializing,
  connecting,
  connected,
  viewing,
  error,
}

/// Service managing the VDO.Ninja SDK lifecycle, room/stream subscriptions,
/// and video track extraction on Flutter Web.
class VdoNinjaService extends ChangeNotifier {
  VDONinjaSDK? _sdk;
  VdoStreamStatus _status = VdoStreamStatus.idle;
  String? _errorMessage;
  web.MediaStream? _currentStream;
  String? _activeStreamId;

  StreamSubscription<void>? _connectedSub;
  StreamSubscription<void>? _disconnectedSub;
  StreamSubscription<VDONinjaErrorEvent>? _errorSub;
  StreamSubscription<VDONinjaTrackEvent>? _trackSub;

  VdoStreamStatus get status => _status;
  String? get errorMessage => _errorMessage;
  web.MediaStream? get currentStream => _currentStream;
  String? get activeStreamId => _activeStreamId;
  bool get hasActiveStream => _currentStream != null;

  /// Initializes the VDO.Ninja JavaScript library.
  Future<void> initialize() async {
    if (_status != VdoStreamStatus.idle) return;
    _status = VdoStreamStatus.initializing;
    notifyListeners();

    try {
      if (kIsWeb) {
        await VDONinjaSDK.initialize();
      }
      _status = VdoStreamStatus.idle;
      notifyListeners();
    } catch (e) {
      _status = VdoStreamStatus.error;
      _errorMessage = 'Failed to initialize VDO.Ninja SDK: $e';
      notifyListeners();
    }
  }

  /// Connects to VDO.Ninja and subscribes to [streamId].
  Future<void> viewStream(String streamId, {String? room, String? password}) async {
    if (!kIsWeb) {
      _status = VdoStreamStatus.error;
      _errorMessage = 'VDO.Ninja streaming is only supported on Web.';
      notifyListeners();
      return;
    }

    await disconnect();

    _status = VdoStreamStatus.connecting;
    _activeStreamId = streamId;
    _errorMessage = null;
    notifyListeners();

    try {
      final sdk = VDONinjaSDK(
        debug: kDebugMode,
        password: password != null ? .string(password) : null,
      );
      _sdk = sdk;

      _connectedSub = sdk.onConnected.listen((_) {
        _status = VdoStreamStatus.connected;
        notifyListeners();
      });

      _disconnectedSub = sdk.onDisconnected.listen((_) {
        _status = VdoStreamStatus.idle;
        _currentStream = null;
        notifyListeners();
      });

      _errorSub = sdk.onError.listen((event) {
        _status = VdoStreamStatus.error;
        _errorMessage = event.message;
        notifyListeners();
      });

      _trackSub = sdk.onTrack.listen((event) {
        if (event.streams.isNotEmpty) {
          final stream = event.streams.first;
          if (stream.isA<web.MediaStream>()) {
            _currentStream = stream as web.MediaStream;
            _status = VdoStreamStatus.viewing;
            notifyListeners();
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
      _status = VdoStreamStatus.viewing;
      notifyListeners();
    } catch (e) {
      _status = VdoStreamStatus.error;
      _errorMessage = 'Failed to view stream: $e';
      notifyListeners();
    }
  }

  /// Disconnects from VDO.Ninja and cleans up stream subscriptions.
  Future<void> disconnect() async {
    await _connectedSub?.cancel();
    await _disconnectedSub?.cancel();
    await _errorSub?.cancel();
    await _trackSub?.cancel();

    _connectedSub = null;
    _disconnectedSub = null;
    _errorSub = null;
    _trackSub = null;

    if (_activeStreamId != null && _sdk != null) {
      try {
        _sdk!.stopViewing(_activeStreamId!);
        _sdk!.disconnect();
      } catch (_) {}
    }

    _sdk = null;
    _currentStream = null;
    _activeStreamId = null;
    _status = VdoStreamStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
