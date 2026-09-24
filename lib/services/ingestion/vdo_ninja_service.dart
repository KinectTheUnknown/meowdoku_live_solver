import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'vdo_ninja_stub.dart' if (dart.library.js_interop) 'vdo_ninja_web.dart';

part 'vdo_ninja_service.freezed.dart';
part 'vdo_ninja_service.g.dart';

/// State representing the VDO.Ninja connection and video stream.
enum VdoStreamStatus {
  idle,
  initializing,
  connecting,
  connected,
  viewing,
  error,
}

/// Immutable state holding active stream details.
@freezed
abstract class VdoStreamState with _$VdoStreamState {
  const VdoStreamState._();

  const factory VdoStreamState({
    @Default(VdoStreamStatus.idle) VdoStreamStatus status,
    String? errorMessage,
    dynamic currentStream,
    String? activeStreamId,
  }) = _VdoStreamState;

  bool get hasActiveStream => currentStream != null;
}

/// Generated Riverpod notifier for VDO.Ninja streaming integration.
@Riverpod(keepAlive: true)
class VdoNinjaStream extends _$VdoNinjaStream {
  late final VdoNinjaPlatformAdapter _adapter;

  @override
  VdoStreamState build() {
    _adapter = createVdoNinjaAdapter(
      onStatusChanged: (status) =>
          update((old) => old.copyWith(status: status)),
      onError: (msg) => update(
        (old) => old.copyWith(status: VdoStreamStatus.error, errorMessage: msg),
      ),
      onStreamAvailable: (stream) => update(
        (old) => old.copyWith(
          status: VdoStreamStatus.viewing,
          currentStream: stream,
        ),
      ),
    );

    ref.onDispose(() {
      _adapter.dispose();
    });

    return const VdoStreamState();
  }

  /// Functional state update method taking current state and returning updated state:
  /// `T update(T Function(T oldState) updater)`
  VdoStreamState update(
    VdoStreamState Function(VdoStreamState oldState) updater,
  ) {
    return state = updater(state);
  }

  /// Initializes the VDO.Ninja JavaScript library.
  Future<void> initialize() async {
    if (state.status != VdoStreamStatus.idle) return;
    update(
      (oldState) => oldState.copyWith(
        status: VdoStreamStatus.initializing,
        errorMessage: null,
      ),
    );

    try {
      await _adapter.initialize();
      update((oldState) => oldState.copyWith(status: VdoStreamStatus.idle));
    } catch (e) {
      update(
        (oldState) => oldState.copyWith(
          status: VdoStreamStatus.error,
          errorMessage: 'Failed to initialize VDO.Ninja SDK: $e',
        ),
      );
    }
  }

  /// Connects to VDO.Ninja and subscribes to [streamId].
  Future<void> viewStream(
    String streamId, {
    String? room,
    String? password,
  }) async {
    if (!kIsWeb) {
      update(
        (oldState) => oldState.copyWith(
          status: VdoStreamStatus.error,
          errorMessage: 'VDO.Ninja streaming is only supported on Web.',
        ),
      );
      return;
    }

    await disconnect();

    update(
      (oldState) => oldState.copyWith(
        status: VdoStreamStatus.connecting,
        activeStreamId: streamId,
        errorMessage: null,
      ),
    );

    try {
      await _adapter.viewStream(streamId, room: room, password: password);
    } catch (e) {
      update(
        (oldState) => oldState.copyWith(
          status: VdoStreamStatus.error,
          errorMessage: 'Failed to view stream: $e',
        ),
      );
    }
  }

  /// Disconnects from VDO.Ninja and cleans up stream subscriptions.
  Future<void> disconnect() async {
    await _adapter.disconnect();

    update(
      (oldState) => oldState.copyWith(
        status: VdoStreamStatus.idle,
        currentStream: null,
        activeStreamId: null,
        errorMessage: null,
      ),
    );
  }
}
