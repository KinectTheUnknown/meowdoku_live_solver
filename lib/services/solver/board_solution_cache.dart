import 'dart:collection';
import '../../models/board_coordinate.dart';
import '../../models/puzzle_board.dart';
import '../solver/meowdoku_solver.dart';

/// Fixed-capacity LRU Cache storing up to [capacity] (default: 10) Meowdoku / Queens solutions.
///
/// Prevents redundant solving computations when scanning continuous video frames
/// of the same board state or returning to recently seen board configurations.
class BoardSolutionCache({final int capacity = 10}) {
  final LinkedHashMap<String, SolverResult> _cache = LinkedHashMap<String, SolverResult>();

  int _hits = 0;
  int _misses = 0;

  int get hits => _hits;
  int get misses => _misses;
  int get size => _cache.length;

  /// Generates a canonical fingerprint string representing the board structure and fixed queens.
  static String computeFingerprint(
    PuzzleBoard board, [
    List<BoardCoordinate>? fixedQueens,
  ]) {
    final buffer = StringBuffer()..write('${board.n}:');

    // Matrix representation
    for (final row in board.regions) {
      for (final cell in row) {
        buffer.write(cell.toRadixString(16));
      }
      buffer.write(';');
    }

    // Fixed queens representation
    if (fixedQueens != null && fixedQueens.isNotEmpty) {
      final sorted = List<BoardCoordinate>.from(fixedQueens)
        ..sort((a, b) => a.row != b.row ? a.row.compareTo(b.row) : a.col.compareTo(b.col));
      buffer.write('|Q:');
      for (final q in sorted) {
        buffer.write('${q.row},${q.col};');
      }
    }

    return buffer.toString();
  }

  /// Solves or retrieves the cached solution for [board] with optional [fixedQueens].
  SolverResult getOrSolve(
    PuzzleBoard board, {
    List<BoardCoordinate>? fixedQueens,
  }) {
    final key = computeFingerprint(board, fixedQueens);

    if (_cache.containsKey(key)) {
      _hits++;
      // Move to back (most recently used)
      final cachedResult = _cache.remove(key)!;
      _cache[key] = cachedResult;
      return cachedResult;
    }

    _misses++;
    final result = MeowdokuSolver(board).solve(initialFixedQueens: fixedQueens);

    if (_cache.length >= capacity) {
      // Remove eldest (first inserted/least recently used)
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = result;

    return result;
  }

  /// Clears the cache and resets statistics.
  void clear() {
    _cache.clear();
    _hits = 0;
    _misses = 0;
  }
}
