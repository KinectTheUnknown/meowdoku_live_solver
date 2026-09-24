import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/video_player_state.dart';

/// A Flutter widget that renders an HTMLVideoElement on Flutter Web via HtmlElementView.
class VideoPlayerView extends ConsumerWidget {
  const VideoPlayerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final videoState = ref.watch(videoPlayerControllerProvider);

    if (!videoState.isRegistered) {
      return const SizedBox.shrink();
    }

    return HtmlElementView(viewType: videoState.viewType);
  }
}
