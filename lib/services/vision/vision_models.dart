import 'color_space.dart';

/// Represents an RGB color with helper accessors.
class const RgbColor(final int r, final int g, final int b) {
  LabColor toLab() => LabColor.fromRgb(r, g, b);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RgbColor &&
          runtimeType == other.runtimeType &&
          r == other.r &&
          g == other.g &&
          b == other.b;

  @override
  int get hashCode => Object.hash(r, g, b);

  @override
  String toString() => 'RgbColor($r, $g, $b)';
}

/// Type of marker detected in a cell.
enum CellMarkerType {
  none,
  whiteX,
  redX,
  cat,
}

/// Represents the analyzed result of a single puzzle cell.
class CellVisionResult({
  required final int row,
  required final int col,
  required final RgbColor dominantColor,
  required final LabColor labColor,
  required final CellMarkerType markerType,
}) {
  bool get isFixedQueen => markerType == CellMarkerType.cat || markerType == CellMarkerType.redX;

  @override
  String toString() =>
      'CellVisionResult(r: $row, c: $col, rgb: $dominantColor, marker: $markerType)';
}

/// Bounding rectangle in pixel coordinates for the board ROI.
class BoardRect(
  final int left,
  final int top,
  final int width,
  final int height,
) {
  int get right => left + width;
  int get bottom => top + height;

  @override
  String toString() => 'BoardRect(L: $left, T: $top, W: $width, H: $height)';
}
