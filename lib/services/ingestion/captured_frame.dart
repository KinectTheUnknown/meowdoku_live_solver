import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Container holding a captured video frame's raw pixel data and dimensions.
class CapturedFrame {
  final Uint8List rgbaPixels;
  final int width;
  final int height;
  late final DateTime timestamp;

  CapturedFrame({
    required this.rgbaPixels,
    required this.width,
    required this.height,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Total number of pixels in the frame.
  int get pixelCount => width * height;

  /// Converts this captured frame into an [img.Image] for the vision pipeline.
  img.Image toImage() {
    return img.Image.fromBytes(
      width: width,
      height: height,
      bytes: rgbaPixels.buffer,
      order: img.ChannelOrder.rgba,
    );
  }

  /// Retrieves the RGBA values at pixel ([x], [y]).
  ({int r, int g, int b, int a}) getPixel(int x, int y) {
    assert(x >= 0 && x < width && y >= 0 && y < height);
    final offset = (y * width + x) * 4;
    return (
      r: rgbaPixels[offset],
      g: rgbaPixels[offset + 1],
      b: rgbaPixels[offset + 2],
      a: rgbaPixels[offset + 3],
    );
  }
}
