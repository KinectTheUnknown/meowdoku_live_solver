// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_player_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VideoPlayerController)
final videoPlayerControllerProvider = VideoPlayerControllerProvider._();

final class VideoPlayerControllerProvider
    extends $NotifierProvider<VideoPlayerController, VideoPlayerState> {
  VideoPlayerControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoPlayerControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoPlayerControllerHash();

  @$internal
  @override
  VideoPlayerController create() => VideoPlayerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VideoPlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VideoPlayerState>(value),
    );
  }
}

String _$videoPlayerControllerHash() =>
    r'72401be94484ea59236afcf8af3421fcd46bfd1f';

abstract class _$VideoPlayerController extends $Notifier<VideoPlayerState> {
  VideoPlayerState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<VideoPlayerState, VideoPlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VideoPlayerState, VideoPlayerState>,
              VideoPlayerState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
