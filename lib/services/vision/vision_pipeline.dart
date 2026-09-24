import 'package:image/image.dart' as img;
import '../../models/board_coordinate.dart';
import '../../models/puzzle_board.dart';
import 'board_detector.dart';
import 'cell_color_sampler.dart';
import 'color_clusterer.dart';
import 'vision_models.dart';

/// Complete result of running the vision extraction pipeline on an image frame.
class VisionExtractionResult {
  final BoardRect boardRect;
  final int n;
  final PuzzleBoard puzzleBoard;
  final List<List<CellVisionResult>> cellGrid;
  final List<RgbColor> clusterColors;
  final List<BoardCoordinate> detectedFixedQueens;
  VisionExtractionResult({
    required this.boardRect,
    required this.n,
    required this.puzzleBoard,
    required this.cellGrid,
    required this.clusterColors,
    required this.detectedFixedQueens,
  });
  @override
  String toString() =>
      'VisionExtractionResult(n: $n, board: $boardRect, colors: ${clusterColors.length}, fixedQueens: ${detectedFixedQueens.length})';
}

/// Orchestrates the computer vision pipeline from a raw image or frame to a solved/solvable board.
class VisionPipeline {
  /// Processes [image] and extracts the puzzle board grid of size [n].
  ///
  /// If [n] is not provided, it is automatically detected via periodic inter-cell grid line analysis.
  /// - [ignoreExistingQueens]: If false (default), Cats and Red X's detected on the board
  ///   are considered part of the user's solution and are returned as `detectedFixedQueens`.
  ///   White X's are always ignored.
  ///   If true, Cats and Red X's are also ignored and treated as unassigned cells.
  /// - [userRoi] allows custom calibration from an interactive UI bounding box.
  static VisionExtractionResult processImage(
    img.Image image, {
    int? n,
    BoardRect? userRoi,
    bool ignoreExistingQueens = false,
  }) {
    // 1. Locate board
    final boardRect = BoardDetector.locateBoard(image, userRoi: userRoi);

    // 2. Auto-detect grid dimension N if not explicitly passed
    final resolvedN = n ?? BoardDetector.detectGridDimension(image, boardRect);

    // 3. Partition into cells
    final cellRectGrid = BoardDetector.partitionCells(boardRect, resolvedN);

    // 4. Sample each cell with marker rejection
    final cellVisionGrid = <List<CellVisionResult>>[];
    final flatCells = <CellVisionResult>[];
    final fixedQueens = <BoardCoordinate>[];

    for (int r = 0; r < resolvedN; r++) {
      final row = <CellVisionResult>[];
      for (int c = 0; c < resolvedN; c++) {
        final cellVision = CellColorSampler.sampleCell(
          image: image,
          cellRect: cellRectGrid[r][c],
          row: r,
          col: c,
        );
        row.add(cellVision);
        flatCells.add(cellVision);

        // Cats and Red X's are considered part of the solution unless ignored
        if (!ignoreExistingQueens && cellVision.isFixedQueen) {
          fixedQueens.add((row: r, col: c));
        }
      }
      cellVisionGrid.add(row);
    }

    // 5. Cluster into N color regions
    final clustering = ColorClusterer.clusterCells(
      cells: flatCells,
      n: resolvedN,
    );

    // 6. Construct PuzzleBoard
    final puzzleBoard = PuzzleBoard(resolvedN, clustering.regions);

    return VisionExtractionResult(
      boardRect: boardRect,
      n: resolvedN,
      puzzleBoard: puzzleBoard,
      cellGrid: cellVisionGrid,
      clusterColors: clustering.clusterColors,
      detectedFixedQueens: fixedQueens,
    );
  }
}
