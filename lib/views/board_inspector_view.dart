import 'package:flutter/material.dart';
import '../../models/board_coordinate.dart';
import '../../models/puzzle_board.dart';
import '../services/vision/vision_models.dart';

/// Digital Companion Inspector displaying the parsed board matrix, cell colors,
/// placed/solved cats, and allowing interactive manual color region overrides.
class BoardInspectorView extends StatelessWidget {
  final PuzzleBoard? board;
  final List<List<CellVisionResult>>? cellGrid;
  final List<RgbColor>? clusterColors;
  final List<BoardCoordinate> solutionQueens;
  final List<BoardCoordinate> fixedQueens;
  final void Function(int row, int col, int newRegion)? onCellRegionChanged;

  const BoardInspectorView({
    super.key,
    required this.board,
    required this.cellGrid,
    required this.clusterColors,
    required this.solutionQueens,
    required this.fixedQueens,
    this.onCellRegionChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (board == null) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.grid_off_outlined, size: 40, color: Colors.white24),
            SizedBox(height: 8),
            Text(
              'No board detected yet',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final n = board!.n;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Digital Matrix (${n}x$n)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              Text(
                'Tap cell to cycle region',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.0,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: n,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: n * n,
              itemBuilder: (context, index) {
                final r = index ~/ n;
                final c = index % n;
                final region = board!.regions[r][c];

                Color cellColor = Colors.grey;
                if (clusterColors != null && region < clusterColors!.length) {
                  final rgb = clusterColors![region];
                  cellColor = Color.fromARGB(255, rgb.r, rgb.g, rgb.b);
                }

                final isQueen = solutionQueens.any(
                  (q) => q.row == r && q.col == c,
                );
                final isFixed = fixedQueens.any(
                  (q) => q.row == r && q.col == c,
                );

                return InkWell(
                  onTap: () {
                    if (onCellRegionChanged != null) {
                      final nextRegion = (region + 1) % n;
                      onCellRegionChanged!(r, c, nextRegion);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(4),
                      border: isQueen
                          ? Border.all(
                              color: isFixed
                                  ? Colors.greenAccent
                                  : Colors.purpleAccent,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: isQueen
                          ? Text(
                              isFixed ? '🐾' : '🐱',
                              style: const TextStyle(fontSize: 14),
                            )
                          : Text(
                              '$region',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: cellColor.computeLuminance() > 0.5
                                    ? Colors.black87
                                    : Colors.white,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
