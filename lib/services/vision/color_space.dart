import 'dart:math' as math;

/// Represents a color in CIE-L*a*b* color space for perceptual color difference calculations.
class LabColor(final double l, final double a, final double b) {
  /// Converts standard RGB values (0-255) to CIE-L*a*b* (assuming sRGB D65 illuminant).
  factory fromRgb(int r, int g, int b) {
    // 1. Convert sRGB to linear RGB
    double inR = r / 255.0;
    double inG = g / 255.0;
    double inB = b / 255.0;

    inR = (inR > 0.04045) ? math.pow((inR + 0.055) / 1.055, 2.4).toDouble() : (inR / 12.92);
    inG = (inG > 0.04045) ? math.pow((inG + 0.055) / 1.055, 2.4).toDouble() : (inG / 12.92);
    inB = (inB > 0.04045) ? math.pow((inB + 0.055) / 1.055, 2.4).toDouble() : (inB / 12.92);

    // 2. Convert Linear RGB to XYZ (D65 standard observer)
    final double x = (inR * 0.4124 + inG * 0.3576 + inB * 0.1805) / 0.95047;
    final double y = (inR * 0.2126 + inG * 0.7152 + inB * 0.0722) / 1.00000;
    final double z = (inR * 0.0193 + inG * 0.1192 + inB * 0.9505) / 1.08883;

    double f(double t) => (t > 0.008856) ? math.pow(t, 1.0 / 3.0).toDouble() : (7.787 * t + 16.0 / 116.0);

    final fx = f(x);
    final fy = f(y);
    final fz = f(z);

    final labL = (116.0 * fy) - 16.0;
    final labA = 500.0 * (fx - fy);
    final labB = 200.0 * (fy - fz);

    return LabColor(labL, labA, labB);
  }

  /// Calculates the CIE76 Euclidean color distance (delta E) between two colors.
  double deltaE(LabColor other) {
    final dL = l - other.l;
    final da = a - other.a;
    final db = b - other.b;
    return math.sqrt(dL * dL + da * da + db * db);
  }

  @override
  String toString() => 'LabColor(L: ${l.toStringAsFixed(1)}, a: ${a.toStringAsFixed(1)}, b: ${b.toStringAsFixed(1)})';
}
