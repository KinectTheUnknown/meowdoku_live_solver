import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_live_solver/models/board_coordinate.dart';
import 'package:meowdoku_live_solver/models/puzzle_board.dart';
import 'package:meowdoku_live_solver/providers/solver_state.dart';
import 'package:meowdoku_live_solver/providers/video_player_state.dart';
import 'package:meowdoku_live_solver/services/ingestion/vdo_ninja_service.dart';
import 'package:meowdoku_live_solver/services/solver/auto_solve_service.dart';
import 'package:meowdoku_live_solver/services/vision/vision_models.dart';
import 'package:meowdoku_live_solver/services/vision/vision_pipeline.dart';

void main() {
  group('Riverpod Providers Unit Tests', () {
    test('SolverController state mutations work correctly and return updated state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initial = container.read(solverControllerProvider);
      expect(initial.isProcessing, isFalse);
      expect(initial.autoSolveEnabled, isFalse);
      expect(initial.badgeStyle, equals(SolutionBadgeStyle.catFace));
      expect(initial.showCalibration, isTrue);

      final notifier = container.read(solverControllerProvider.notifier);

      final s1 = notifier.setProcessing(true);
      expect(s1.isProcessing, isTrue);
      expect(container.read(solverControllerProvider).isProcessing, isTrue);

      notifier.setAutoSolveEnabled(true);
      notifier.setAutoSolveIntervalSec(2.5);
      notifier.setBadgeStyle(SolutionBadgeStyle.crown);
      notifier.setShowCalibration(false);
      notifier.setManualGridN(10);
      notifier.setIgnoreExistingQueens(true);

      final updated = container.read(solverControllerProvider);
      expect(updated.autoSolveEnabled, isTrue);
      expect(updated.autoSolveIntervalSec, equals(2.5));
      expect(updated.badgeStyle, equals(SolutionBadgeStyle.crown));
      expect(updated.showCalibration, isFalse);
      expect(updated.manualGridN, equals(10));
      expect(updated.ignoreExistingQueens, isTrue);

      // Test functional update(oldState => newState)
      final afterFunctional = notifier.update((oldState) => oldState.copyWith(autoSolveIntervalSec: 3.0));
      expect(afterFunctional.autoSolveIntervalSec, equals(3.0));
      expect(container.read(solverControllerProvider).autoSolveIntervalSec, equals(3.0));

      // Test updateSolution
      final testBoard = PuzzleBoard(2, [
        [0, 1],
        [0, 1],
      ]);
      final visionResult = VisionExtractionResult(
        boardRect: BoardRect(0, 0, 100, 100),
        n: 2,
        puzzleBoard: testBoard,
        cellGrid: const [],
        clusterColors: const [],
        detectedFixedQueens: const <BoardCoordinate>[(row: 0, col: 0)],
      );
      final solverResult = SolverResult(
        isSolved: true,
        queens: const <BoardCoordinate>[(row: 0, col: 0), (row: 1, col: 1)],
        duration: const Duration(microseconds: 150),
        statesExplored: 2,
      );

      final solvedState = notifier.updateSolution(
        visionResult: visionResult,
        solverResult: solverResult,
        cacheHits: 1,
        cacheMisses: 2,
        cacheSize: 3,
      );

      expect(solvedState.isProcessing, isFalse);
      expect(solvedState.currentBoard, equals(testBoard));
      expect(solvedState.solutionQueens.length, equals(2));
      expect(solvedState.fixedQueens.length, equals(1));
      expect(solvedState.cacheHits, equals(1));
      expect(solvedState.cacheMisses, equals(2));
      expect(solvedState.cacheSize, equals(3));
      expect(container.read(solverControllerProvider), equals(solvedState));

      // Test clearSolution
      final cleared = notifier.clearSolution(cacheHits: 0, cacheMisses: 0, cacheSize: 0);
      expect(cleared.currentBoard, isNull);
      expect(cleared.solutionQueens, isEmpty);
      expect(cleared.solverResult, isNull);
      expect(container.read(solverControllerProvider), equals(cleared));
    });

    test('VideoPlayerController mutations update state and return updated state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initial = container.read(videoPlayerControllerProvider);
      expect(initial.isRegistered, isFalse);
      expect(initial.hasStream, isFalse);
      expect(initial.videoWidth, equals(0));

      final notifier = container.read(videoPlayerControllerProvider.notifier);
      final registeredState = notifier.markRegistered();
      expect(registeredState.isRegistered, isTrue);

      final streamState = notifier.setHasStream(true);
      expect(streamState.hasStream, isTrue);

      final dimState = notifier.updateDimensions(1920, 1080);
      expect(dimState.videoWidth, equals(1920));
      expect(dimState.videoHeight, equals(1080));

      final updated = container.read(videoPlayerControllerProvider);
      expect(updated.isRegistered, isTrue);
      expect(updated.hasStream, isTrue);
      expect(updated.videoWidth, equals(1920));
      expect(updated.videoHeight, equals(1080));

      // Test update(oldState => newState)
      final custom = notifier.update((oldState) => oldState.copyWith(videoWidth: 1280));
      expect(custom.videoWidth, equals(1280));
      expect(container.read(videoPlayerControllerProvider).videoWidth, equals(1280));
    });

    test('VdoNinjaStream initialized and functional update works', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initial = container.read(vdoNinjaStreamProvider);
      expect(initial.status, equals(VdoStreamStatus.idle));
      expect(initial.hasActiveStream, isFalse);

      final notifier = container.read(vdoNinjaStreamProvider.notifier);
      final updated = notifier.update((oldState) => oldState.copyWith(activeStreamId: 'stream-123'));
      expect(updated.activeStreamId, equals('stream-123'));
      expect(container.read(vdoNinjaStreamProvider).activeStreamId, equals('stream-123'));
    });

    test('AutoSolveService toggleAutoSolve updates state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final autoSolve = container.read(autoSolveServiceProvider.notifier);
      expect(container.read(autoSolveServiceProvider), isFalse);

      autoSolve.toggleAutoSolve(true);
      expect(container.read(autoSolveServiceProvider), isTrue);
      expect(container.read(solverControllerProvider).autoSolveEnabled, isTrue);

      autoSolve.toggleAutoSolve(false);
      expect(container.read(autoSolveServiceProvider), isFalse);
      expect(container.read(solverControllerProvider).autoSolveEnabled, isFalse);
    });
  });
}

