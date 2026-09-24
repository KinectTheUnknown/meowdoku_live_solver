import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/puzzle_board.dart';
import '../../providers/solver_state.dart';
import '../../providers/video_player_state.dart';
import '../ingestion/canvas_frame_grabber.dart';
import '../ingestion/vdo_ninja_service.dart';
import 'board_solution_cache.dart';
import '../vision/vision_pipeline.dart';

part 'auto_solve_service.g.dart';

@Riverpod(keepAlive: true)
class AutoSolveService extends _$AutoSolveService {
  final CanvasFrameGrabber _frameGrabber = CanvasFrameGrabber();
  final BoardSolutionCache _solutionCache = BoardSolutionCache();
  Timer? _autoSolveTimer;
  int? _lastFrameSampleHash;

  BoardSolutionCache get solutionCache => _solutionCache;

  @override
  bool build() {
    ref.onDispose(() {
      _stopTimer();
      _frameGrabber.dispose();
    });

    // Reactively stop auto-solve when the stream disconnects or has an error
    ref.listen(vdoNinjaStreamProvider, (previous, next) {
      if (!next.hasActiveStream && state) {
        toggleAutoSolve(false);
      }
    });

    return false;
  }

  void _stopTimer() {
    _autoSolveTimer?.cancel();
    _autoSolveTimer = null;
    _lastFrameSampleHash = null;
  }

  /// Toggles automatic solving scanner on or off
  void toggleAutoSolve(bool enabled) {
    ref.read(solverControllerProvider.notifier).setAutoSolveEnabled(enabled);
    state = enabled;
    if (enabled) {
      startAutoSolveTimer();
    } else {
      _stopTimer();
    }
  }

  /// Starts or restarts the periodic timer based on solver interval configuration
  void startAutoSolveTimer() {
    _stopTimer();
    final solverState = ref.read(solverControllerProvider);
    _autoSolveTimer = Timer.periodic(
      Duration(milliseconds: (solverState.autoSolveIntervalSec * 1000).round()),
      (_) {
        final videoState = ref.read(videoPlayerControllerProvider);
        final currentSolver = ref.read(solverControllerProvider);
        if (videoState.hasStream && !currentSolver.isProcessing) {
          triggerSnapAndSolve();
        }
      },
    );
  }

  /// Captures single frame from the video element and processes puzzle vision + solver
  void triggerSnapAndSolve({bool forceReprocess = false}) {
    final videoManager = ref
        .read(videoPlayerControllerProvider.notifier)
        .videoManager;
    final videoEl = videoManager.videoElement;
    final solverState = ref.read(solverControllerProvider);
    if (videoEl == null || solverState.isProcessing) return;

    final frame = _frameGrabber.captureFrame(videoEl);
    if (frame == null) return;

    // Fast frame diffing: compute a 25-point grid sample hash to skip identical frames
    final currentHash = _computeSampleHash(frame);
    if (!forceReprocess &&
        _lastFrameSampleHash != null &&
        _lastFrameSampleHash == currentHash) {
      // Frame has not changed visually, skip heavy computer vision processing
      return;
    }
    _lastFrameSampleHash = currentHash;

    _processFrame(frame);
  }

  /// Computes a lightweight 25-point sample hash across the frame buffer for quick diffing
  int _computeSampleHash(CapturedFrame frame) {
    final w = frame.width;
    final h = frame.height;
    final pixels = frame.rgbaPixels;
    if (w <= 0 || h <= 0 || pixels.isEmpty) return 0;

    int hash = 17;
    for (int gy = 1; gy <= 5; gy++) {
      final y = (h * gy) ~/ 6;
      final rowOffset = y * w * 4;
      for (int gx = 1; gx <= 5; gx++) {
        final x = (w * gx) ~/ 6;
        final offset = rowOffset + (x * 4);
        if (offset + 2 < pixels.length) {
          final r = pixels[offset];
          final g = pixels[offset + 1];
          final b = pixels[offset + 2];
          hash = 37 * hash + (r ^ (g << 8) ^ (b << 16));
        }
      }
    }
    return hash;
  }

  void _processFrame(CapturedFrame frame) {
    final solverNotifier = ref.read(solverControllerProvider.notifier);
    final solverState = ref.read(solverControllerProvider);
    solverNotifier.setProcessing(true);

    try {
      final imgFrame = frame.toImage();
      final visionResult = VisionPipeline.processImage(
        imgFrame,
        n: solverState.manualGridN,
        ignoreExistingQueens: solverState.ignoreExistingQueens,
      );

      final solverResult = _solutionCache.getOrSolve(
        visionResult.puzzleBoard,
        fixedQueens: visionResult.detectedFixedQueens,
      );

      solverNotifier.updateSolution(
        visionResult: visionResult,
        solverResult: solverResult,
        cacheHits: _solutionCache.hits,
        cacheMisses: _solutionCache.misses,
        cacheSize: _solutionCache.size,
      );
    } catch (_) {
      // Ignore unparseable transient frames
      solverNotifier.setProcessing(false);
    }
  }

  /// Manually overrides a single cell color/region in the digital board inspector
  void handleManualCellColorOverride(int row, int col, int newRegion) {
    final solverState = ref.read(solverControllerProvider);
    final currentBoard = solverState.currentBoard;
    if (currentBoard == null) return;

    final n = currentBoard.n;
    final updatedMatrix = List<List<int>>.generate(
      n,
      (r) => List<int>.from(currentBoard.regions[r]),
    );
    updatedMatrix[row][col] = newRegion;

    final updatedBoard = PuzzleBoard(n, updatedMatrix);
    final solverResult = _solutionCache.getOrSolve(
      updatedBoard,
      fixedQueens: solverState.fixedQueens,
    );

    ref
        .read(solverControllerProvider.notifier)
        .updateManualOverride(
          updatedBoard: updatedBoard,
          solverResult: solverResult,
          cacheHits: _solutionCache.hits,
          cacheMisses: _solutionCache.misses,
          cacheSize: _solutionCache.size,
        );
  }

  /// Clears current board solution and cache
  void handleClearSolution() {
    _solutionCache.clear();
    _lastFrameSampleHash = null;
    ref
        .read(solverControllerProvider.notifier)
        .clearSolution(
          cacheHits: _solutionCache.hits,
          cacheMisses: _solutionCache.misses,
          cacheSize: _solutionCache.size,
        );
  }
}
