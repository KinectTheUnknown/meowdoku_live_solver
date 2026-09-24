import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'vision_models.dart';

/// Samples cells from an image with marker-rejection filtering.
class CellColorSampler {
  /// Samples a cell within [image] defined by [cellRect].
  ///
  /// Uses annular (donut) sampling around the perimeter of the cell
  /// combined with color histogram binning to extract the true background
  /// color while rejecting pre-placed Cats and 'X' crosshairs.
  static CellVisionResult sampleCell({
    required img.Image image,
    required BoardRect cellRect,
    required int row,
    required int col,
  }) {
    final centerX = cellRect.left + cellRect.width / 2.0;
    final centerY = cellRect.top + cellRect.height / 2.0;
    final minRadius = (cellRect.width / 2.0) * 0.25;
    final maxRadius = (cellRect.width / 2.0) * 0.70;

    // 16x16x16 binning for dominant mode extraction
    final histogram = <int, int>{};
    final binColors = <int, List<RgbColor>>{};

    final minX = math.max(0, cellRect.left);
    final maxX = math.min(image.width - 1, cellRect.right);
    final minY = math.max(0, cellRect.top);
    final maxY = math.min(image.height - 1, cellRect.bottom);

    int totalAnnularPixels = 0;

    for (int y = minY; y <= maxY; y += 2) {
      final dy = y - centerY;
      for (int x = minX; x <= maxX; x += 2) {
        final dx = x - centerX;
        final dist = math.sqrt(dx * dx + dy * dy);

        // Keep inside annular band
        if (dist >= minRadius && dist <= maxRadius) {
          final pixel = image.getPixel(x, y);
          final r = pixel.r.toInt();
          final g = pixel.g.toInt();
          final b = pixel.b.toInt();

          final binKey = ((r >> 4) << 8) | ((g >> 4) << 4) | (b >> 4);
          histogram[binKey] = (histogram[binKey] ?? 0) + 1;
          (binColors[binKey] ??= []).add(RgbColor(r, g, b));
          totalAnnularPixels++;
        }
      }
    }

    if (totalAnnularPixels == 0 || histogram.isEmpty) {
      // Fallback to center pixel if sampling was out of bounds
      final px = image.getPixel(
        centerX.toInt().clamp(0, image.width - 1),
        centerY.toInt().clamp(0, image.height - 1),
      );
      final rgb = RgbColor(px.r.toInt(), px.g.toInt(), px.b.toInt());
      return CellVisionResult(
        row: row,
        col: col,
        dominantColor: rgb,
        labColor: rgb.toLab(),
        markerType: CellMarkerType.none,
      );
    }

    // Find the mode bin (highest peak)
    int modeBin = histogram.keys.first;
    int maxCount = -1;
    for (final entry in histogram.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        modeBin = entry.key;
      }
    }

    // Average the colors in the mode bin and adjacent bins
    final candidateColors = binColors[modeBin]!;
    int sumR = 0, sumG = 0, sumB = 0;
    for (final c in candidateColors) {
      sumR += c.r;
      sumG += c.g;
      sumB += c.b;
    }

    final avgR = (sumR / candidateColors.length).round();
    final avgG = (sumG / candidateColors.length).round();
    final avgB = (sumB / candidateColors.length).round();

    final dominantRgb = RgbColor(avgR, avgG, avgB);
    final lab = dominantRgb.toLab();

    // Check center core to classify marker type:
    // - White X: White stroke (R>240, G>240, B>240)
    // - Red X: Reddish stroke (R>200, G<130, B<100)
    // - Cat: Dark fur (R<70, G<70, B<70)
    final coreRadius = (cellRect.width / 2.0) * 0.40;
    int whitePixels = 0;
    int redPixels = 0;
    int darkPixels = 0;
    int corePixels = 0;

    for (
      int y = (centerY - coreRadius).round();
      y <= (centerY + coreRadius).round();
      y += 2
    ) {
      if (y < 0 || y >= image.height) continue;
      final dy = y - centerY;
      for (
        int x = (centerX - coreRadius).round();
        x <= (centerX + coreRadius).round();
        x += 2
      ) {
        if (x < 0 || x >= image.width) continue;
        final dx = x - centerX;
        if (math.sqrt(dx * dx + dy * dy) <= coreRadius) {
          final px = image.getPixel(x, y);
          final r = px.r.toInt();
          final g = px.g.toInt();
          final b = px.b.toInt();
          corePixels++;

          if (r > 240 && g > 240 && b > 240) {
            whitePixels++;
          } else if (r > 200 && g < 130 && b < 100) {
            redPixels++;
          } else if (r < 75 && g < 75 && b < 75) {
            darkPixels++;
          }
        }
      }
    }

    CellMarkerType detectedMarker = CellMarkerType.none;
    if (corePixels > 0) {
      final whiteRatio = whitePixels / corePixels;
      final redRatio = redPixels / corePixels;
      final darkRatio = darkPixels / corePixels;

      if (darkRatio > 0.15) {
        detectedMarker = CellMarkerType.cat;
      } else if (redRatio > 0.15) {
        detectedMarker = CellMarkerType.redX;
      } else if (whiteRatio > 0.15) {
        detectedMarker = CellMarkerType.whiteX;
      }
    }

    return CellVisionResult(
      row: row,
      col: col,
      dominantColor: dominantRgb,
      labColor: lab,
      markerType: detectedMarker,
    );
  }
}
