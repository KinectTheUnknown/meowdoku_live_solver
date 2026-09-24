import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:meowdoku_live_solver/services/vision/vision_pipeline.dart';
import 'package:meowdoku_live_solver/services/solver/meowdoku_solver.dart';

void main() {
  group('Computer Vision Pipeline Tests with Real Screenshots', () {
    test('IMG_4554.PNG (Empty 9x9 board) extracts and solves cleanly', () {
      final file = File('test/fixtures/screenshots/IMG_4554.PNG');
      expect(file.existsSync(), isTrue);

      final bytes = file.readAsBytesSync();
      final image = img.decodeImage(bytes);
      expect(image, isNotNull);

      // IMG_4554 is a 9x9 board (Level 754, 0/9)
      final visionResult = VisionPipeline.processImage(image!, n: 9);

      expect(visionResult.n, equals(9));
      expect(visionResult.clusterColors.length, equals(9));
      expect(visionResult.puzzleBoard.isValid(), isTrue);

      // Solve the extracted board
      final solverResult = MeowdokuSolver(visionResult.puzzleBoard).solve();
      expect(solverResult.isSolved, isTrue);
      expect(solverResult.queens.length, equals(9));
      expect(
        MeowdokuSolver.verifySolution(
          visionResult.puzzleBoard,
          solverResult.queens,
        ),
        isTrue,
      );
    });

    test(
      'IMG_4552.PNG (10x10 mid-game with pre-placed Cats & Xs) extracts colors without marker corruption',
      () {
        final file = File('test/fixtures/screenshots/IMG_4552.PNG');
        expect(file.existsSync(), isTrue);

        final bytes = file.readAsBytesSync();
        final image = img.decodeImage(bytes);
        expect(image, isNotNull);

        // IMG_4552 is a 10x10 board (Level 750, 3/10) with Cats & Red X
        final visionResult = VisionPipeline.processImage(image!, n: 10);

        expect(visionResult.n, equals(10));
        expect(visionResult.clusterColors.length, equals(10));
        expect(visionResult.puzzleBoard.isValid(), isTrue);

        // Verify Cats and Red X were detected as fixed queens
        expect(visionResult.detectedFixedQueens.isNotEmpty, isTrue);

        // Verify solver can solve this board locking the detected fixed queens in place
        final solverResult = MeowdokuSolver(
          visionResult.puzzleBoard,
        ).solve(initialFixedQueens: visionResult.detectedFixedQueens);
        expect(solverResult.isSolved, isTrue);
        expect(solverResult.queens.length, equals(10));
        expect(
          MeowdokuSolver.verifySolution(
            visionResult.puzzleBoard,
            solverResult.queens,
          ),
          isTrue,
        );

        // Also verify solver can solve with ignoreExistingQueens: true
        final visionIgnored = VisionPipeline.processImage(
          image,
          n: 10,
          ignoreExistingQueens: true,
        );
        expect(visionIgnored.detectedFixedQueens.isEmpty, isTrue);
        final solverIgnoredResult = MeowdokuSolver(
          visionIgnored.puzzleBoard,
        ).solve();
        expect(solverIgnoredResult.isSolved, isTrue);
      },
    );

    test('IMG_4557.PNG extracts and solves', () {
      final file = File('test/fixtures/screenshots/IMG_4557.PNG');
      if (!file.existsSync()) return;

      final image = img.decodeImage(file.readAsBytesSync());
      expect(image, isNotNull);

      // IMG_4557 is a 12x12 board (0/12 cats)
      final visionResult = VisionPipeline.processImage(image!, n: 12);
      expect(visionResult.n, equals(12));
      expect(visionResult.puzzleBoard.isValid(), isTrue);

      final solverResult = MeowdokuSolver(visionResult.puzzleBoard).solve();
      expect(solverResult.isSolved, isTrue);
      expect(solverResult.queens.length, equals(12));
      expect(
        MeowdokuSolver.verifySolution(
          visionResult.puzzleBoard,
          solverResult.queens,
        ),
        isTrue,
      );
    });

    test('IMG_4558.PNG extracts and solves', () {
      final file = File('test/fixtures/screenshots/IMG_4558.PNG');
      if (!file.existsSync()) return;

      final image = img.decodeImage(file.readAsBytesSync());
      expect(image, isNotNull);

      final visionResult = VisionPipeline.processImage(image!, n: 10);
      expect(visionResult.n, equals(10));
      expect(visionResult.puzzleBoard.isValid(), isTrue);

      final solverResult = MeowdokuSolver(visionResult.puzzleBoard).solve();
      expect(solverResult.isSolved, isTrue);
      expect(solverResult.queens.length, equals(10));
      expect(
        MeowdokuSolver.verifySolution(
          visionResult.puzzleBoard,
          solverResult.queens,
        ),
        isTrue,
      );
    });

    test('IMG_4559.PNG extracts and solves', () {
      final file = File('test/fixtures/screenshots/IMG_4559.PNG');
      if (!file.existsSync()) return;

      final image = img.decodeImage(file.readAsBytesSync());
      expect(image, isNotNull);

      final visionResult = VisionPipeline.processImage(image!, n: 10);
      expect(visionResult.n, equals(10));
      expect(visionResult.puzzleBoard.isValid(), isTrue);

      final solverResult = MeowdokuSolver(visionResult.puzzleBoard).solve();
      expect(solverResult.isSolved, isTrue);
      expect(solverResult.queens.length, equals(10));
      expect(
        MeowdokuSolver.verifySolution(
          visionResult.puzzleBoard,
          solverResult.queens,
        ),
        isTrue,
      );
    });

    test(
      'IMG_4560.PNG (10x10 mid-game board) extracts and solves correctly',
      () {
        final file = File('test/fixtures/screenshots/IMG_4560.PNG');
        expect(file.existsSync(), isTrue);

        final bytes = file.readAsBytesSync();
        final image = img.decodeImage(bytes);
        expect(image, isNotNull);

        final visionResult = VisionPipeline.processImage(image!, n: 10);

        expect(visionResult.n, equals(10));
        expect(visionResult.clusterColors.length, equals(10));
        expect(visionResult.puzzleBoard.isValid(), isTrue);

        final solverResult = MeowdokuSolver(visionResult.puzzleBoard).solve();
        expect(solverResult.isSolved, isTrue);
        expect(solverResult.queens.length, equals(10));
        expect(
          MeowdokuSolver.verifySolution(
            visionResult.puzzleBoard,
            solverResult.queens,
          ),
          isTrue,
        );
      },
    );
  });
}
