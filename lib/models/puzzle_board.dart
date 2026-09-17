import 'board_coordinate.dart';

/// Represents a Meowdoku / Queens puzzle board definition.
class PuzzleBoard(final int n, final List<List<int>> regions) {
  this {
    assert(n > 0, 'Grid dimension n must be positive');
    assert(regions.length == n, 'Region matrix rows must equal $n');
    for (final row in regions) {
      assert(
        row.length == n,
        'Region row length (${row.length}) must equal $n',
      );
    }
  }

  /// Verifies that the board has exactly [n] distinct regions and each cell has a valid region ID.
  bool isValid() {
    if (regions.length != n) return false;
    final foundRegions = <int>{};
    for (final row in regions) {
      if (row.length != n) return false;
      for (final reg in row) {
        if (reg < 0 || reg >= n) return false;
        foundRegions.add(reg);
      }
    }
    return foundRegions.length == n;
  }
}

/// Thrown when a [PuzzleBoard] violates the game structure constraints.
class InvalidBoardException(final String message) implements Exception {
  @override
  String toString() => 'InvalidBoardException: $message';
}

/// The result returned by the MeowdokuSolver.
class const SolverResult({
  required final bool isSolved,
  required final List<BoardCoordinate> queens,
  required final Duration duration,
  required final int statesExplored,
}) {
  /// Factory for an unsolvable board result.
  factory unsolvable({
    required Duration duration,
    required int statesExplored,
  }) {
    return SolverResult(
      isSolved: false,
      queens: const [],
      duration: duration,
      statesExplored: statesExplored,
    );
  }
}
