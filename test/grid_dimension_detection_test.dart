import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:meowdoku_live_solver/services/vision/vision_pipeline.dart';
import 'package:meowdoku_live_solver/services/solver/meowdoku_solver.dart';

void main() {
  group('Automatic Grid Dimension (N x N) Detection Tests', () {
    test('Automatically detects 9x9 board for IMG_4554 without specifying n', () {
      final image = img.decodeImage(File('test/fixtures/screenshots/IMG_4554.PNG').readAsBytesSync())!;
      final result = VisionPipeline.processImage(image); // n is omitted

      expect(result.n, equals(9));
      expect(result.puzzleBoard.isValid(), isTrue);

      final solverResult = MeowdokuSolver(result.puzzleBoard).solve();
      expect(solverResult.isSolved, isTrue);
      expect(solverResult.queens.length, equals(9));
    });

    test('Automatically detects 10x10 board for IMG_4552 without specifying n', () {
      final image = img.decodeImage(File('test/fixtures/screenshots/IMG_4552.PNG').readAsBytesSync())!;
      final result = VisionPipeline.processImage(image); // n is omitted

      expect(result.n, equals(10));
      expect(result.puzzleBoard.isValid(), isTrue);

      final solverResult = MeowdokuSolver(result.puzzleBoard).solve(initialFixedQueens: result.detectedFixedQueens);
      expect(solverResult.isSolved, isTrue);
      expect(solverResult.queens.length, equals(10));
    });

    test('Automatically detects 12x12 board for IMG_4557 without specifying n', () {
      final image = img.decodeImage(File('test/fixtures/screenshots/IMG_4557.PNG').readAsBytesSync())!;
      final result = VisionPipeline.processImage(image); // n is omitted

      expect(result.n, equals(12));
      expect(result.puzzleBoard.isValid(), isTrue);

      final solverResult = MeowdokuSolver(result.puzzleBoard).solve();
      expect(solverResult.isSolved, isTrue);
      expect(solverResult.queens.length, equals(12));
    });

    test('Automatically detects 10x10 board for IMG_4560 without specifying n', () {
      final image = img.decodeImage(File('test/fixtures/screenshots/IMG_4560.PNG').readAsBytesSync())!;
      final result = VisionPipeline.processImage(image); // n is omitted

      expect(result.n, equals(10));
      expect(result.puzzleBoard.isValid(), isTrue);

      final solverResult = MeowdokuSolver(result.puzzleBoard).solve();
      expect(solverResult.isSolved, isTrue);
      expect(solverResult.queens.length, equals(10));
    });
  });
}
