import 'dart:math' as math;

import '../../models/board_coordinate.dart';
import '../../models/puzzle_board.dart';

/// High-performance Bitmask Constraint Satisfaction Problem (CSP) Solver for
/// Meowdoku and Queens logic puzzles.
class MeowdokuSolver(final PuzzleBoard board) {
  /// Solves the puzzle and returns the first valid queen placement.
  ///
  /// If [initialFixedQueens] is provided, those queen coordinates are locked in place
  /// and any candidate violating them is pruned immediately.
  SolverResult solve({List<BoardCoordinate>? initialFixedQueens}) {
    final stopwatch = Stopwatch()..start();
    final n = board.n;

    if (!board.isValid()) {
      throw InvalidBoardException('Cannot solve an invalid puzzle board.');
    }

    final solutionCols = List<int>.filled(n, -1);
    final fixedCols = List<int>.filled(n, -1);

    if (initialFixedQueens != null) {
      for (final q in initialFixedQueens) {
        if (q.row >= 0 && q.row < n && q.col >= 0 && q.col < n) {
          fixedCols[q.row] = q.col;
        }
      }
    }

    int statesCount = 0;

    bool search(int row, int colsUsed, int regionsUsed, int prevCol) {
      statesCount++;
      if (row == n) return true; // All rows satisfied

      // If this row has a pre-determined fixed Queen (Cat or Red X)
      final forcedCol = fixedCols[row];

      // Neighbor adjacency forbidden columns from the queen in row - 1
      int neighborMask = 0;
      if (prevCol != -1) {
        neighborMask |= (1 << prevCol);
        if (prevCol > 0) neighborMask |= (1 << (prevCol - 1));
        if (prevCol < n - 1) neighborMask |= (1 << (prevCol + 1));
      }

      final forbiddenCols = colsUsed | neighborMask;

      for (int c = 0; c < n; c++) {
        if (forcedCol != -1 && c != forcedCol) continue;

        // Column check & 8-neighbor adjacency check
        if ((forbiddenCols & (1 << c)) != 0) continue;

        // Region uniqueness check
        final region = board.regions[row][c];
        if ((regionsUsed & (1 << region)) != 0) continue;

        solutionCols[row] = c;

        if (search(
          row + 1,
          colsUsed | (1 << c),
          regionsUsed | (1 << region),
          c,
        )) {
          return true;
        }
      }

      return false;
    }

    final success = search(0, 0, 0, -1);
    stopwatch.stop();

    if (!success) {
      return .unsolvable(
        duration: stopwatch.elapsed,
        statesExplored: statesCount,
      );
    }

    final queens = List.generate(
      n,
      (r) => (row: r, col: solutionCols[r]),
      growable: false,
    );

    return .new(
      isSolved: true,
      queens: queens,
      duration: stopwatch.elapsed,
      statesExplored: statesCount,
    );
  }

  /// Finds up to [limit] solutions to verify puzzle uniqueness.
  List<List<BoardCoordinate>> findAllSolutions({int limit = 10}) {
    final n = board.n;
    if (!board.isValid()) {
      throw InvalidBoardException('Cannot solve an invalid puzzle board.');
    }

    final results = <List<BoardCoordinate>>[];
    final solutionCols = List<int>.filled(n, -1);

    void search(int row, int colsUsed, int regionsUsed, int prevCol) {
      if (results.length >= limit) return;
      if (row == n) {
        results.add(
          List.generate(
            n,
            (r) => (row: r, col: solutionCols[r]),
            growable: false,
          ),
        );
        return;
      }

      int neighborMask = 0;
      if (prevCol != -1) {
        neighborMask |= (1 << prevCol);
        if (prevCol > 0) neighborMask |= (1 << (prevCol - 1));
        if (prevCol < n - 1) neighborMask |= (1 << (prevCol + 1));
      }

      final forbiddenCols = colsUsed | neighborMask;

      for (int c = 0; c < n; c++) {
        if ((forbiddenCols & (1 << c)) != 0) continue;

        final region = board.regions[row][c];
        if ((regionsUsed & (1 << region)) != 0) continue;

        solutionCols[row] = c;
        search(row + 1, colsUsed | (1 << c), regionsUsed | (1 << region), c);
      }
    }

    search(0, 0, 0, -1);
    return results;
  }

  /// Independent validation of a solution against the 4 Queens rules:
  /// 1. Exactly 1 per row
  /// 2. Exactly 1 per column
  /// 3. Exactly 1 per region
  /// 4. No two queens touching (Chebyshev distance >= 2)
  static bool verifySolution(PuzzleBoard board, List<BoardCoordinate> queens) {
    final n = board.n;
    if (queens.length != n) return false;

    final rows = <int>{};
    final cols = <int>{};
    final regions = <int>{};

    for (int i = 0; i < queens.length; i++) {
      final q1 = queens[i];
      if (q1.row < 0 || q1.row >= n || q1.col < 0 || q1.col >= n) return false;

      // Row uniqueness
      if (!rows.add(q1.row)) return false;

      // Column uniqueness
      if (!cols.add(q1.col)) return false;

      // Region uniqueness
      final region = board.regions[q1.row][q1.col];
      if (!regions.add(region)) return false;

      // Adjacency check against all other queens
      for (int j = i + 1; j < queens.length; j++) {
        final q2 = queens[j];
        final rowDiff = (q1.row - q2.row).abs();
        final colDiff = (q1.col - q2.col).abs();
        final chebyshev = math.max(rowDiff, colDiff);

        if (chebyshev < 2) {
          // Queens touch (orthogonally or diagonally)
          return false;
        }
      }
    }

    return rows.length == n && cols.length == n && regions.length == n;
  }
}
