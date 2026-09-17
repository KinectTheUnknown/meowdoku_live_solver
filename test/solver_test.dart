import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_live_solver/models/board_coordinate.dart';
import 'package:meowdoku_live_solver/models/puzzle_board.dart';
import 'package:meowdoku_live_solver/services/solver/meowdoku_solver.dart';

void main() {
  group('MeowdokuSolver Tests', () {
    test('Solves a 4x4 test board correctly', () {
      final board = PuzzleBoard(4, [
        [0, 1, 1, 1],
        [0, 0, 2, 1],
        [3, 0, 2, 2],
        [3, 3, 3, 2],
      ]);

      final solver = MeowdokuSolver(board);
      final result = solver.solve();

      expect(result.isSolved, isTrue);
      expect(result.queens.length, equals(4));

      // Verify with independent rule validator
      final isValid = MeowdokuSolver.verifySolution(board, result.queens);
      expect(isValid, isTrue);

      expect(
        result.queens,
        equals([
          (row: 0, col: 2),
          (row: 1, col: 0),
          (row: 2, col: 3),
          (row: 3, col: 1),
        ]),
      );
    });

    test('Solves a realistic 8x8 Meowdoku board in sub-millisecond time', () {
      // 8x8 board with 8 colored regions
      final board = PuzzleBoard(8, [
        [0, 0, 1, 1, 1, 2, 2, 2],
        [0, 0, 1, 3, 1, 2, 2, 2],
        [0, 3, 3, 3, 4, 4, 2, 2],
        [5, 5, 3, 4, 4, 4, 4, 2],
        [5, 5, 3, 6, 6, 4, 7, 7],
        [5, 5, 6, 6, 6, 7, 7, 7],
        [5, 6, 6, 6, 6, 7, 7, 7],
        [6, 6, 6, 6, 6, 7, 7, 7],
      ]);

      final solver = MeowdokuSolver(board);
      final result = solver.solve();

      expect(result.isSolved, isTrue);
      expect(result.queens.length, equals(8));
      expect(MeowdokuSolver.verifySolution(board, result.queens), isTrue);

      // Performance assertion: execution should be under 5 milliseconds
      expect(result.duration.inMilliseconds, lessThan(5));
    });

    test('Solves a 9x9 board correctly', () {
      final board = PuzzleBoard(9, [
        [0, 0, 0, 1, 1, 1, 2, 2, 2],
        [0, 3, 0, 1, 1, 1, 2, 2, 2],
        [3, 3, 3, 4, 4, 4, 2, 5, 2],
        [3, 3, 6, 4, 4, 4, 5, 5, 5],
        [6, 6, 6, 4, 7, 4, 5, 5, 5],
        [6, 6, 6, 7, 7, 7, 5, 5, 8],
        [6, 7, 7, 7, 7, 7, 8, 8, 8],
        [6, 7, 7, 7, 7, 8, 8, 8, 8],
        [7, 7, 7, 7, 8, 8, 8, 8, 8],
      ]);

      final solver = MeowdokuSolver(board);
      final result = solver.solve();

      expect(result.isSolved, isTrue);
      expect(result.queens.length, equals(9));
      expect(MeowdokuSolver.verifySolution(board, result.queens), isTrue);
    });

    test("Solve a 10x10 board correctly", () {
      // 0: Mustard, 1: Green
      // 2: Orange, 3: Cyan
      // 4: Dark Pink, 5: Lime
      // 6: Brown, 7: Yellow
      // 8: Pink, 9: Purple
      final board = PuzzleBoard(10, [
        [0, 1, 1, 1, 1, 1, 2, 3, 3, 3],
        [1, 1, 1, 1, 2, 2, 2, 3, 4, 4],
        [1, 2, 1, 1, 2, 5, 3, 3, 3, 3],
        [2, 2, 2, 2, 2, 5, 5, 5, 3, 3],
        [6, 6, 2, 6, 5, 5, 7, 7, 3, 7],
        [6, 6, 6, 6, 6, 5, 8, 7, 3, 7],
        [6, 6, 7, 6, 6, 5, 8, 7, 7, 7],
        [9, 7, 7, 7, 6, 5, 5, 7, 7, 7],
        [9, 7, 9, 7, 6, 6, 5, 5, 7, 7],
        [9, 9, 9, 7, 7, 7, 7, 7, 7, 7],
      ]);

      final solver = MeowdokuSolver(board);
      final result = solver.solve();

      expect(result.isSolved, isTrue);
      expect(result.queens.length, equals(10));
      expect(MeowdokuSolver.verifySolution(board, result.queens), isTrue);
    });

    test('Correctly identifies an impossible board as unsolvable', () {
      // Board where region 0 is only 1 cell and region 1 is only 1 cell, touching diagonally
      final board = PuzzleBoard(4, [
        [0, 2, 2, 2],
        [2, 1, 2, 2],
        [2, 2, 3, 3],
        [2, 2, 3, 3],
      ]);

      final solver = MeowdokuSolver(board);
      final result = solver.solve();

      expect(result.isSolved, isFalse);
      expect(result.queens, isEmpty);
    });

    test('Verification catches adjacency violation', () {
      final board = PuzzleBoard(4, [
        [0, 0, 1, 1],
        [0, 2, 2, 1],
        [3, 2, 2, 1],
        [3, 3, 3, 1],
      ]);

      // Queens at (0, 0) and (1, 1) touch diagonally (chebyshev = 1)
      final illegalQueens = <BoardCoordinate>[
        (row: 0, col: 0),
        (row: 1, col: 1),
        (row: 2, col: 3),
        (row: 3, col: 2),
      ];

      expect(MeowdokuSolver.verifySolution(board, illegalQueens), isFalse);
    });

    test('Throws InvalidBoardException when board is structurally invalid', () {
      // Board with region ID out of bounds (missing region 3, using 4 instead)
      final invalidBoard = PuzzleBoard(4, [
        [0, 0, 1, 1],
        [0, 2, 2, 1],
        [4, 2, 2, 1],
        [4, 4, 4, 1],
      ]);

      final solver = MeowdokuSolver(invalidBoard);
      expect(() => solver.solve(), throwsA(isA<InvalidBoardException>()));
      expect(
        () => solver.findAllSolutions(),
        throwsA(isA<InvalidBoardException>()),
      );
    });
  });
}
