import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/solver_state.dart';
import '../../providers/video_player_state.dart';
import '../../services/ingestion/vdo_ninja_service.dart';
import '../ar_solution_painter.dart';
import '../video_player_view.dart';

/// Live video stream viewport with interactive AR solution overlay and status badge.
class ArStreamViewport extends ConsumerWidget {
  const ArStreamViewport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solverState = ref.watch(solverControllerProvider);
    final videoState = ref.watch(videoPlayerControllerProvider);
    final vdoState = ref.watch(vdoNinjaStreamProvider);

    final videoW = videoState.videoWidth > 0 ? videoState.videoWidth : 1206;
    final videoH = videoState.videoHeight > 0 ? videoState.videoHeight : 2622;

    return Container(
      color: const Color(0xFF020617),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const VideoPlayerView(),

          // AR Overlay
          CustomPaint(
            painter: ArSolutionPainter(
              boardRect: solverState.visionResult?.boardRect,
              n: solverState.currentBoard?.n ?? solverState.visionResult?.n ?? 0,
              solutionQueens: solverState.solutionQueens,
              fixedQueens: solverState.fixedQueens,
              videoWidth: videoW,
              videoHeight: videoH,
              badgeStyle: solverState.badgeStyle,
              showCalibration: solverState.showCalibration,
            ),
          ),

          // Overlay status banner
          if (solverState.solverResult != null)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: solverState.solverResult!.isSolved
                      ? const Color(0xFF064E3B).withValues(alpha: 0.9)
                      : const Color(0xFF7F1D1D).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: solverState.solverResult!.isSolved
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      solverState.solverResult!.isSolved
                          ? Icons.check_circle
                          : Icons.error_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      solverState.solverResult!.isSolved
                          ? 'Solved ${solverState.currentBoard?.n}x${solverState.currentBoard?.n} in ${solverState.lastSolveDuration?.inMicroseconds ?? 0}μs'
                          : 'No valid solution found',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (!videoState.hasStream)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.videocam_off,
                    size: 64,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    vdoState.status == VdoStreamStatus.connecting
                        ? 'Connecting to VDO.Ninja stream...'
                        : 'Enter a VDO.Ninja Stream ID to start solving live',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
