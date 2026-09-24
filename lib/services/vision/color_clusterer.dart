import 'dart:math' as math;
import 'color_space.dart';
import 'vision_models.dart';

/// Clusters cells into N color regions using CIE-Lab distance.
class ColorClusterer {
  /// Clusters a flat list of [cells] into [k] distinct color regions.
  ///
  /// Returns an N x N matrix of region indices [0 .. k-1], and the representative
  /// average RGB colors for each cluster index.
  static ({List<List<int>> regions, List<RgbColor> clusterColors})
  clusterCells({
    required List<CellVisionResult> cells,
    required int n,
    int maxIterations = 30,
  }) {
    assert(cells.length == n * n, 'Cell count must be equal to n * n');

    // 1. Initial centroid selection via K-Means++ to maximize distance between seeds
    final centroids = <LabColor>[];
    final random = math.Random(42);

    // First centroid: random cell
    centroids.add(cells[random.nextInt(cells.length)].labColor);

    while (centroids.length < n) {
      final distances = <double>[];
      double sumDistSq = 0.0;

      for (final cell in cells) {
        double minDist = double.infinity;
        for (final c in centroids) {
          final d = cell.labColor.deltaE(c);
          if (d < minDist) minDist = d;
        }
        final dSq = minDist * minDist;
        distances.add(dSq);
        sumDistSq += dSq;
      }

      // Sample next centroid proportional to distance squared
      if (sumDistSq == 0) {
        centroids.add(cells[random.nextInt(cells.length)].labColor);
        continue;
      }

      double target = random.nextDouble() * sumDistSq;
      int selectedIdx = 0;
      for (int i = 0; i < distances.length; i++) {
        target -= distances[i];
        if (target <= 0) {
          selectedIdx = i;
          break;
        }
      }
      centroids.add(cells[selectedIdx].labColor);
    }

    // 2. Iterative K-Means clustering
    final assignments = List<int>.filled(cells.length, 0);

    for (int iter = 0; iter < maxIterations; iter++) {
      bool changed = false;

      // Assign each cell to nearest centroid
      for (int i = 0; i < cells.length; i++) {
        int bestCluster = 0;
        double minDistance = double.infinity;

        for (int k = 0; k < n; k++) {
          final dist = cells[i].labColor.deltaE(centroids[k]);
          if (dist < minDistance) {
            minDistance = dist;
            bestCluster = k;
          }
        }

        if (assignments[i] != bestCluster) {
          assignments[i] = bestCluster;
          changed = true;
        }
      }

      if (!changed) break;

      // Recompute centroids
      for (int k = 0; k < n; k++) {
        double sumL = 0.0, sumA = 0.0, sumB = 0.0;
        int count = 0;

        for (int i = 0; i < cells.length; i++) {
          if (assignments[i] == k) {
            sumL += cells[i].labColor.l;
            sumA += cells[i].labColor.a;
            sumB += cells[i].labColor.b;
            count++;
          }
        }

        if (count > 0) {
          centroids[k] = LabColor(sumL / count, sumA / count, sumB / count);
        }
      }
    }

    // 3. Compute representative RGB for each cluster
    final clusterColors = <RgbColor>[];
    for (int k = 0; k < n; k++) {
      int sumR = 0, sumG = 0, sumB = 0;
      int count = 0;
      for (int i = 0; i < cells.length; i++) {
        if (assignments[i] == k) {
          sumR += cells[i].dominantColor.r;
          sumG += cells[i].dominantColor.g;
          sumB += cells[i].dominantColor.b;
          count++;
        }
      }
      if (count > 0) {
        clusterColors.add(
          RgbColor(
            (sumR / count).round(),
            (sumG / count).round(),
            (sumB / count).round(),
          ),
        );
      } else {
        clusterColors.add(const RgbColor(128, 128, 128));
      }
    }

    // 4. Reshape assignments into n x n matrix
    final matrix = List.generate(n, (_) => List.filled(n, 0));
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        matrix[r][c] = assignments[r * n + c];
      }
    }

    return (regions: matrix, clusterColors: clusterColors);
  }
}
