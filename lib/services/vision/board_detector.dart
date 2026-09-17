import 'package:image/image.dart' as img;
import 'vision_models.dart';

/// Detects the Meowdoku / Queens puzzle board boundaries within an image frame.
class BoardDetector {
  /// Locates the square puzzle board bounding box within [image].
  ///
  /// The Meowdoku board is enclosed in a white card container (`#FFFFFF`) with rounded corners
  /// in the center third of the iPhone screen.
  /// If [userRoi] is provided, it is clamped to the image dimensions and returned directly.
  static BoardRect locateBoard(img.Image image, {BoardRect? userRoi}) {
    if (userRoi != null) {
      return BoardRect(
        userRoi.left.clamp(0, image.width - 1),
        userRoi.top.clamp(0, image.height - 1),
        userRoi.width.clamp(1, image.width - userRoi.left),
        userRoi.height.clamp(1, image.height - userRoi.top),
      );
    }

    // Default heuristic: In iPhone screenshots, the board card is horizontally centered,
    // occupying ~95% of the screen width, and starts around ~29% of the height.
    final margin = (image.width * 0.025).round();
    final boardWidth = image.width - (margin * 2);
    final boardHeight = boardWidth; // Boards are square
    final boardTop = (image.height * 0.285).round();

    return BoardRect(margin, boardTop, boardWidth, boardHeight);
  }

  /// Automatically detects the grid dimension [N] (e.g. 7, 8, 9, 10, 11, 12) by analyzing
  /// periodic white inter-cell grid borders across the board area.
  static int detectGridDimension(img.Image image, BoardRect boardRoi, {int minN = 6, int maxN = 14}) {
    final whiteCountByX = List<int>.filled(boardRoi.width, 0);
    final whiteCountByY = List<int>.filled(boardRoi.height, 0);
    final step = 8;

    for (int y = boardRoi.top + 20; y < boardRoi.bottom - 20; y += step) {
      if (y < 0 || y >= image.height) continue;
      for (int dx = 0; dx < boardRoi.width; dx++) {
        final x = boardRoi.left + dx;
        if (x < 0 || x >= image.width) continue;
        final p = image.getPixel(x, y);
        if (p.r > 245 && p.g > 245 && p.b > 245) {
          whiteCountByX[dx]++;
        }
      }
    }

    for (int x = boardRoi.left + 20; x < boardRoi.right - 20; x += step) {
      if (x < 0 || x >= image.width) continue;
      for (int dy = 0; dy < boardRoi.height; dy++) {
        final y = boardRoi.top + dy;
        if (y < 0 || y >= image.height) continue;
        final p = image.getPixel(x, y);
        if (p.r > 245 && p.g > 245 && p.b > 245) {
          whiteCountByY[dy]++;
        }
      }
    }

    int bestN = 9; // Fallback default
    int maxCandidate = -1;

    for (int candidateN = minN; candidateN <= maxN; candidateN++) {
      double minGapScore = double.infinity;

      for (int c = 1; c < candidateN; c++) {
        final expX = (c * boardRoi.width / candidateN).round();
        final expY = (c * boardRoi.height / candidateN).round();

        int maxX = 0;
        for (int w = -3; w <= 3; w++) {
          final idx = (expX + w).clamp(0, boardRoi.width - 1);
          if (whiteCountByX[idx] > maxX) maxX = whiteCountByX[idx];
        }

        int maxY = 0;
        for (int w = -3; w <= 3; w++) {
          final idx = (expY + w).clamp(0, boardRoi.height - 1);
          if (whiteCountByY[idx] > maxY) maxY = whiteCountByY[idx];
        }

        final combined = (maxX + maxY) / 2.0;
        if (combined < minGapScore) minGapScore = combined;
      }

      // If all expected grid gaps show strong inter-cell white lines
      if (minGapScore > 35.0) {
        if (candidateN > maxCandidate) {
          maxCandidate = candidateN;
          bestN = candidateN;
        }
      }
    }

    return bestN;
  }

  /// Partitions [boardRoi] into an [n] x [n] grid of cell bounding boxes.
  static List<List<BoardRect>> partitionCells(BoardRect boardRoi, int n) {
    final cellW = boardRoi.width / n;
    final cellH = boardRoi.height / n;

    final grid = <List<BoardRect>>[];
    for (int r = 0; r < n; r++) {
      final row = <BoardRect>[];
      for (int c = 0; c < n; c++) {
        final left = (boardRoi.left + c * cellW).round();
        final top = (boardRoi.top + r * cellH).round();
        final width = ((boardRoi.left + (c + 1) * cellW).round() - left);
        final height = ((boardRoi.top + (r + 1) * cellH).round() - top);
        row.add(BoardRect(left, top, width, height));
      }
      grid.add(row);
    }
    return grid;
  }
}
