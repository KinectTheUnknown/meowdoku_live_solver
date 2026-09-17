import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_live_solver/models/puzzle_board.dart';
import 'package:meowdoku_live_solver/services/solver/board_solution_cache.dart';

void main() {
  group('BoardSolutionCache Tests', () {
    final boardA = PuzzleBoard(4, [
      [0, 0, 1, 1],
      [0, 0, 1, 1],
      [2, 2, 3, 3],
      [2, 2, 3, 3],
    ]);

    test('Caches first solve and returns on second query', () {
      final cache = BoardSolutionCache(capacity: 10);

      expect(cache.size, equals(0));
      expect(cache.hits, equals(0));
      expect(cache.misses, equals(0));

      final result1 = cache.getOrSolve(boardA);
      expect(result1.isSolved, isTrue);
      expect(cache.size, equals(1));
      expect(cache.misses, equals(1));
      expect(cache.hits, equals(0));

      // Query same board -> cache hit
      final result2 = cache.getOrSolve(boardA);
      expect(result2.isSolved, isTrue);
      expect(cache.size, equals(1));
      expect(cache.misses, equals(1));
      expect(cache.hits, equals(1));
    });

    test('Evicts oldest entry when exceeding capacity of 10', () {
      final cache = BoardSolutionCache(capacity: 10);

      // Generate 12 distinct 4x4 boards
      for (int i = 0; i < 12; i++) {
        final b = PuzzleBoard(4, [
          [0, 0, 1, 1],
          [0, 0, 1, 1],
          [2, 2, 3, 3],
          [(i % 2), 2, 3, 3], // Distinct per iteration
        ]);
        // Also supply fixed queen to ensure unique fingerprints
        cache.getOrSolve(b, fixedQueens: [(row: 0, col: i)]);
      }

      expect(cache.size, equals(10));
    });

    test('Differentiates boards with different fixed queens', () {
      final cache = BoardSolutionCache(capacity: 10);

      final r1 = cache.getOrSolve(boardA);
      final r2 = cache.getOrSolve(boardA, fixedQueens: [(row: 0, col: 1)]);

      expect(r1.isSolved, isTrue);
      expect(r2.isSolved, isTrue);
      expect(cache.size, equals(2));
      expect(cache.misses, equals(2));
    });
  });
}
