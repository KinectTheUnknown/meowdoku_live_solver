import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/solver_state.dart';
import '../../services/solver/auto_solve_service.dart';

/// Configuration card for vision pipeline toggles, calibration box, and AR badge icons.
class SolverOptionsCard extends ConsumerWidget {
  const SolverOptionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solverState = ref.watch(solverControllerProvider);
    final solverNotifier = ref.read(solverControllerProvider.notifier);

    return Material(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Solver & Vision Options',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text(
                'Ignore Cats & Red X',
                style: TextStyle(fontSize: 12),
              ),
              subtitle: const Text(
                'Solve entire board from scratch',
                style: TextStyle(fontSize: 10, color: Colors.white54),
              ),
              value: solverState.ignoreExistingQueens,
              dense: true,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) {
                solverNotifier.setIgnoreExistingQueens(val ?? false);
                if (solverState.visionResult != null) {
                  ref.read(autoSolveServiceProvider.notifier).triggerSnapAndSolve(forceReprocess: true);
                }
              },
            ),
            CheckboxListTile(
              title: const Text(
                'Show Calibration Box',
                style: TextStyle(fontSize: 12),
              ),
              value: solverState.showCalibration,
              dense: true,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) => solverNotifier.setShowCalibration(val ?? true),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Overlay Icon:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                DropdownButton<SolutionBadgeStyle>(
                  value: solverState.badgeStyle,
                  dropdownColor: const Color(0xFF1E293B),
                  underline: const SizedBox(),
                  items: SolutionBadgeStyle.values
                      .map(
                        (style) => DropdownMenuItem(
                          value: style,
                          child: Text(style.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      solverNotifier.setBadgeStyle(val);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
