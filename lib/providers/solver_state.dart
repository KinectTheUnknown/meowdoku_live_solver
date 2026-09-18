import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/board_coordinate.dart';
import '../models/puzzle_board.dart';
import '../services/vision/vision_pipeline.dart';
import '../views/ar_solution_painter.dart';

export '../views/ar_solution_painter.dart' show SolutionBadgeStyle;

part 'solver_state.freezed.dart';
part 'solver_state.g.dart';

/// Immutable state containing vision extraction, board solver results, and UI options.
@freezed
abstract class SolverState with _$SolverState {
  const factory SolverState({
    VisionExtractionResult? visionResult,
    SolverResult? solverResult,
    PuzzleBoard? currentBoard,
    @Default([]) List<BoardCoordinate> solutionQueens,
    @Default([]) List<BoardCoordinate> fixedQueens,
    Duration? lastSolveDuration,
    @Default(false) bool isProcessing,
    @Default(false) bool autoSolveEnabled,
    @Default(1.0) double autoSolveIntervalSec,
    @Default(false) bool ignoreExistingQueens,
    @Default(true) bool showCalibration,
    @Default(SolutionBadgeStyle.catFace) SolutionBadgeStyle badgeStyle,
    int? manualGridN,
    @Default(0) int cacheHits,
    @Default(0) int cacheMisses,
    @Default(0) int cacheSize,
  }) = _SolverState;
}

@Riverpod(keepAlive: true)
class SolverController extends _$SolverController {
  @override
  SolverState build() {
    return const SolverState();
  }

  /// Functional state update method taking current state and returning updated state:
  /// `T update(T Function(T oldState) updater)`
  SolverState update(SolverState Function(SolverState oldState) updater) {
    return state = updater(state);
  }

  SolverState setProcessing(bool processing) {
    return update((oldState) => oldState.copyWith(isProcessing: processing));
  }

  SolverState updateSolution({
    required VisionExtractionResult visionResult,
    required SolverResult solverResult,
    required int cacheHits,
    required int cacheMisses,
    required int cacheSize,
  }) {
    return update(
      (oldState) => oldState.copyWith(
        visionResult: visionResult,
        currentBoard: visionResult.puzzleBoard,
        fixedQueens: visionResult.detectedFixedQueens,
        solverResult: solverResult,
        solutionQueens: solverResult.isSolved ? solverResult.queens : const [],
        lastSolveDuration: solverResult.duration,
        isProcessing: false,
        cacheHits: cacheHits,
        cacheMisses: cacheMisses,
        cacheSize: cacheSize,
      ),
    );
  }

  SolverState updateManualOverride({
    required PuzzleBoard updatedBoard,
    required SolverResult solverResult,
    required int cacheHits,
    required int cacheMisses,
    required int cacheSize,
  }) {
    return update(
      (oldState) => oldState.copyWith(
        currentBoard: updatedBoard,
        solverResult: solverResult,
        solutionQueens: solverResult.isSolved ? solverResult.queens : const [],
        lastSolveDuration: solverResult.duration,
        cacheHits: cacheHits,
        cacheMisses: cacheMisses,
        cacheSize: cacheSize,
      ),
    );
  }

  SolverState setAutoSolveEnabled(bool enabled) {
    return update((oldState) => oldState.copyWith(autoSolveEnabled: enabled));
  }

  SolverState setAutoSolveIntervalSec(double interval) {
    return update((oldState) => oldState.copyWith(autoSolveIntervalSec: interval));
  }

  SolverState setIgnoreExistingQueens(bool ignore) {
    return update((oldState) => oldState.copyWith(ignoreExistingQueens: ignore));
  }

  SolverState setShowCalibration(bool show) {
    return update((oldState) => oldState.copyWith(showCalibration: show));
  }

  SolverState setBadgeStyle(SolutionBadgeStyle style) {
    return update((oldState) => oldState.copyWith(badgeStyle: style));
  }

  SolverState setManualGridN(int? n) {
    return update((oldState) => oldState.copyWith(manualGridN: n));
  }

  SolverState clearSolution({
    required int cacheHits,
    required int cacheMisses,
    required int cacheSize,
  }) {
    return update(
      (oldState) => oldState.copyWith(
        visionResult: null,
        solverResult: null,
        currentBoard: null,
        solutionQueens: const [],
        fixedQueens: const [],
        lastSolveDuration: null,
        cacheHits: cacheHits,
        cacheMisses: cacheMisses,
        cacheSize: cacheSize,
      ),
    );
  }
}
