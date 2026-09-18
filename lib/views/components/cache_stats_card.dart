import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/solver_state.dart';

/// Performance metrics card showing solution cache size, hits, and misses.
class CacheStatsCard extends ConsumerWidget {
  const CacheStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solverState = ref.watch(solverControllerProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                'Cache Size',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${solverState.cacheSize}/10',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Hits',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${solverState.cacheHits}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Misses',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${solverState.cacheMisses}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
