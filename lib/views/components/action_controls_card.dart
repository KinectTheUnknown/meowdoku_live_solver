import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/solver_state.dart';
import '../../providers/video_player_state.dart';
import '../../services/solver/auto_solve_service.dart';

/// Control buttons for snapping immediate frame solutions and toggling automatic periodic scanning.
class ActionControlsCard extends ConsumerWidget {
  const ActionControlsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoPlayerControllerProvider);
    final solverState = ref.watch(solverControllerProvider);
    final autoSolveService = ref.read(autoSolveServiceProvider.notifier);

    return Column(
      children: [
        // 1. Action Controls
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: videoState.hasStream
                    ? autoSolveService.triggerSnapAndSolve
                    : null,
                icon: const Icon(Icons.flash_on, size: 16),
                label: const Text('Snap & Solve'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA855F7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2. Auto-Solve Scanner Toggle & Slider
        Material(
          color: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.autorenew,
                      color: Color(0xFF38BDF8),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Auto-Solve Scanner',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Switch(
                      value: solverState.autoSolveEnabled,
                      activeThumbColor: const Color(0xFF38BDF8),
                      onChanged: videoState.hasStream
                          ? (enabled) => autoSolveService.toggleAutoSolve(enabled)
                          : null,
                    ),
                  ],
                ),
                if (solverState.autoSolveEnabled) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Interval:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '${solverState.autoSolveIntervalSec.toStringAsFixed(1)}s',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: solverState.autoSolveIntervalSec,
                    min: 0.5,
                    max: 3.0,
                    divisions: 5,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (val) {
                      ref
                          .read(solverControllerProvider.notifier)
                          .setAutoSolveIntervalSec(val);
                      autoSolveService.startAutoSolveTimer();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
