import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/ingestion/vdo_ninja_service.dart';
import '../views/video_player_manager.dart';

export '../views/video_player_manager.dart' show WebVideoManager;

part 'video_player_state.freezed.dart';
part 'video_player_state.g.dart';

/// Immutable state for the video player DOM element.
@freezed
abstract class VideoPlayerState with _$VideoPlayerState {
  const factory VideoPlayerState({
    @Default('') String viewType,
    @Default(false) bool isRegistered,
    @Default(false) bool hasStream,
    @Default(0) int videoWidth,
    @Default(0) int videoHeight,
  }) = _VideoPlayerState;
}

@Riverpod(keepAlive: true)
class VideoPlayerController extends _$VideoPlayerController {
  late final WebVideoManager _videoManager;

  WebVideoManager get videoManager => _videoManager;

  @override
  VideoPlayerState build() {
    _videoManager = WebVideoManager();
    ref.onDispose(() {
      _videoManager.dispose();
    });

    // Directly observe VDO stream arrival / departure reactively
    ref.listen(vdoNinjaStreamProvider, (previous, next) {
      final stream = next.currentStream;
      if (stream != null) {
        attachStream(stream);
      } else {
        detachStream();
      }
    });

    final generatedViewType = 'vdo-ninja-player-${DateTime.now().microsecondsSinceEpoch}';
    return VideoPlayerState(viewType: generatedViewType);
  }

  /// Functional state update method taking current state and returning updated state:
  /// `T update(T Function(T oldState) updater)`
  VideoPlayerState update(VideoPlayerState Function(VideoPlayerState oldState) updater) {
    return state = updater(state);
  }

  /// Initializes the video manager element and registers view factory
  VideoPlayerState initializeElement({VoidCallback? onLoadedMetadata}) {
    _videoManager.initialize(state.viewType, () {
      updateDimensions(_videoManager.videoWidth, _videoManager.videoHeight);
      onLoadedMetadata?.call();
    });
    return markRegistered();
  }

  /// Attaches media stream to the video DOM element and updates stream state
  VideoPlayerState attachStream(dynamic stream) {
    _videoManager.attachStream(stream);
    return update((oldState) => oldState.copyWith(hasStream: true));
  }

  /// Detaches media stream from the video DOM element
  VideoPlayerState detachStream() {
    _videoManager.detachStream();
    return update((oldState) => oldState.copyWith(hasStream: false));
  }

  VideoPlayerState markRegistered() {
    return update((oldState) => oldState.copyWith(isRegistered: true));
  }

  VideoPlayerState setHasStream(bool hasStream) {
    return update((oldState) => oldState.copyWith(hasStream: hasStream));
  }

  VideoPlayerState updateDimensions(int width, int height) {
    return update(
      (oldState) => oldState.copyWith(
        videoWidth: width,
        videoHeight: height,
      ),
    );
  }
}
