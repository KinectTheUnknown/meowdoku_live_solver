import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/board_coordinate.dart';
import '../services/vision/vision_models.dart';

/// Style of icons rendered on top of winning solution cells.
enum SolutionBadgeStyle {
  catFace,
  crown,
  paw,
}

/// Custom painter that renders interactive calibration bounding box and glowing AR solution badges.
class ArSolutionPainter extends CustomPainter {
  final BoardRect? boardRect;
  final int n;
  final List<BoardCoordinate> solutionQueens;
  final List<BoardCoordinate> fixedQueens;
  final int videoWidth;
  final int videoHeight;
  final SolutionBadgeStyle badgeStyle;
  final bool showCalibration;

  ArSolutionPainter({
    required this.boardRect,
    required this.n,
    required this.solutionQueens,
    required this.fixedQueens,
    required this.videoWidth,
    required this.videoHeight,
    this.badgeStyle = SolutionBadgeStyle.catFace,
    this.showCalibration = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (videoWidth <= 0 || videoHeight <= 0 || boardRect == null || n <= 0) return;

    // Calculate scale factor from natural video coordinates to screen size (BoxFit.contain)
    final scaleX = size.width / videoWidth;
    final scaleY = size.height / videoHeight;
    final scale = math.min(scaleX, scaleY);

    final offsetX = (size.width - (videoWidth * scale)) / 2.0;
    final offsetY = (size.height - (videoHeight * scale)) / 2.0;

    final rect = Rect.fromLTWH(
      offsetX + (boardRect!.left * scale),
      offsetY + (boardRect!.top * scale),
      boardRect!.width * scale,
      boardRect!.height * scale,
    );

    // 1. Draw Calibration Box if enabled
    if (showCalibration) {
      final borderPaint = Paint()
        ..color = const Color(0xFF38BDF8).withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), borderPaint);

      // Corner handles
      final cornerPaint = Paint()
        ..color = const Color(0xFF38BDF8)
        ..style = PaintingStyle.fill;
      const handleSize = 10.0;
      canvas.drawCircle(rect.topLeft, handleSize / 2, cornerPaint);
      canvas.drawCircle(rect.topRight, handleSize / 2, cornerPaint);
      canvas.drawCircle(rect.bottomLeft, handleSize / 2, cornerPaint);
      canvas.drawCircle(rect.bottomRight, handleSize / 2, cornerPaint);
    }

    final cellW = rect.width / n;
    final cellH = rect.height / n;

    // 2. Draw Queens / Cat solution icons
    final queenIcon = switch (badgeStyle) {
      SolutionBadgeStyle.catFace => '🐱',
      SolutionBadgeStyle.crown => '👑',
      SolutionBadgeStyle.paw => '🐾',
    };

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (final q in solutionQueens) {
      final cx = rect.left + (q.col + 0.5) * cellW;
      final cy = rect.top + (q.row + 0.5) * cellH;
      final radius = math.min(cellW, cellH) * 0.42;

      final isPrePlaced = fixedQueens.any((f) => f.row == q.row && f.col == q.col);

      // Glowing aura
      final auraColor = isPrePlaced ? const Color(0xFF10B981) : const Color(0xFFA855F7);

      final glowPaint = Paint()
        ..color = auraColor.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(Offset(cx, cy), radius * 1.1, glowPaint);

      // Disc background
      final discPaint = Paint()
        ..color = isPrePlaced
            ? const Color(0xFF064E3B).withValues(alpha: 0.85)
            : const Color(0xFF581C87).withValues(alpha: 0.85)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(cx, cy), radius, discPaint);

      // Disc border
      final ringPaint = Paint()
        ..color = isPrePlaced ? const Color(0xFF34D399) : const Color(0xFFE879F9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(Offset(cx, cy), radius, ringPaint);

      // Icon symbol
      textPainter.text = TextSpan(
        text: queenIcon,
        style: TextStyle(
          fontSize: radius * 1.1,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(cx - textPainter.width / 2, cy - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ArSolutionPainter oldDelegate) {
    return oldDelegate.solutionQueens != solutionQueens ||
        oldDelegate.boardRect != boardRect ||
        oldDelegate.n != n ||
        oldDelegate.badgeStyle != badgeStyle ||
        oldDelegate.showCalibration != showCalibration;
  }
}
