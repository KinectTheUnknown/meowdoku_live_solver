import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/solver_state.dart';
import 'providers/video_player_state.dart';
import 'services/ingestion/vdo_ninja_service.dart';
import 'services/solver/auto_solve_service.dart';
import 'views/board_inspector_view.dart';
import 'views/components/action_controls_card.dart';
import 'views/components/ar_stream_viewport.dart';
import 'views/components/cache_stats_card.dart';
import 'views/components/solver_options_card.dart';
import 'views/components/stream_connection_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MeowdokuApp()));
}

class MeowdokuApp extends StatelessWidget {
  const MeowdokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meowdoku Live Solver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFFA855F7),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const LiveStreamScreen(),
    );
  }
}

class LiveStreamScreen extends ConsumerStatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  ConsumerState<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends ConsumerState<LiveStreamScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoPlayerControllerProvider.notifier).initializeElement();
      ref.read(vdoNinjaStreamProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final solverState = ref.watch(solverControllerProvider);
    final autoSolveService = ref.read(autoSolveServiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              '🐱 Meowdoku Live Solver',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(width: 10),
            Chip(
              label: Text(
                'Ready • AR & Auto-Solve',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Color(0xFF1E293B),
              side: BorderSide(color: Color(0xFF38BDF8), width: 0.8),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Clear Solution & Cache',
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: autoSolveService.handleClearSolution,
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Left: Main Live Video Viewport with AR Overlay
          const Expanded(
            flex: 3,
            child: ArStreamViewport(),
          ),

          // Right: Companion Inspector & Controls Sidebar
          Container(
            width: 360,
            color: const Color(0xFF0F172A),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Connection Section
                const StreamConnectionCard(),
                const SizedBox(height: 16),

                // 2. Action Controls & Auto-Solve Scanner
                const ActionControlsCard(),
                const SizedBox(height: 14),

                // 3. Digital Board Inspector
                BoardInspectorView(
                  board: solverState.currentBoard,
                  cellGrid: solverState.visionResult?.cellGrid,
                  clusterColors: solverState.visionResult?.clusterColors,
                  solutionQueens: solverState.solutionQueens,
                  fixedQueens: solverState.fixedQueens,
                  onCellRegionChanged: autoSolveService.handleManualCellColorOverride,
                ),
                const SizedBox(height: 14),

                // 4. Config & Toggles
                const SolverOptionsCard(),
                const SizedBox(height: 14),

                // 5. Cache Stats
                const CacheStatsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
