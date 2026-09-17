import 'dart:async';
import 'package:flutter/material.dart';
import 'models/board_coordinate.dart';
import 'models/puzzle_board.dart';
import 'services/ingestion/canvas_frame_grabber.dart';
import 'services/ingestion/vdo_ninja_service.dart';
import 'services/solver/board_solution_cache.dart';
import 'services/vision/vision_pipeline.dart';
import 'views/ar_solution_painter.dart';
import 'views/board_inspector_view.dart';
import 'views/video_player_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MeowdokuApp());
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

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final _vdoService = VdoNinjaService();
  late final VideoPlayerController _videoController;
  final _frameGrabber = CanvasFrameGrabber();
  final _solutionCache = BoardSolutionCache(capacity: 10);
  final _streamIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _obscurePassword = true;

  // Vision & Solver State
  VisionExtractionResult? _lastVisionResult;
  SolverResult? _lastSolverResult;
  PuzzleBoard? _currentBoard;
  List<BoardCoordinate> _solutionQueens = const [];
  List<BoardCoordinate> _fixedQueens = const [];
  Duration? _lastSolveDuration;
  bool _isProcessing = false;

  // Options & Toggles
  bool _autoSolveEnabled = false;
  double _autoSolveIntervalSec = 1.0;
  Timer? _autoSolveTimer;
  bool _ignoreExistingQueens = false;
  bool _showCalibration = true;
  SolutionBadgeStyle _badgeStyle = SolutionBadgeStyle.catFace;
  int? _manualGridN; // null = auto-detect

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController();
    _vdoService.initialize();
    _vdoService.addListener(_onVdoServiceChanged);
  }

  void _onVdoServiceChanged() {
    final stream = _vdoService.currentStream;
    if (stream != null) {
      _videoController.attachStream(stream);
    } else {
      _videoController.detachStream();
      _stopAutoSolve();
    }
    if (mounted) setState(() {});
  }

  void _handleConnect() {
    final streamId = _streamIdController.text.trim();
    final passwordText = _passwordController.text.trim();
    final password = passwordText.isNotEmpty ? passwordText : null;
    if (streamId.isNotEmpty) {
      _vdoService.viewStream(streamId, password: password);
    }
  }

  void _triggerSnapAndSolve() {
    final videoEl = _videoController.videoElement;
    if (videoEl == null || _isProcessing) return;

    final frame = _frameGrabber.captureFrame(videoEl);
    if (frame == null) return;

    _processFrame(frame);
  }

  void _processFrame(CapturedFrame frame) {
    _isProcessing = true;
    try {
      final imgFrame = frame.toImage();
      final visionResult = VisionPipeline.processImage(
        imgFrame,
        n: _manualGridN,
        ignoreExistingQueens: _ignoreExistingQueens,
      );

      final solverResult = _solutionCache.getOrSolve(
        visionResult.puzzleBoard,
        fixedQueens: visionResult.detectedFixedQueens,
      );

      setState(() {
        _lastVisionResult = visionResult;
        _currentBoard = visionResult.puzzleBoard;
        _fixedQueens = visionResult.detectedFixedQueens;
        _lastSolverResult = solverResult;
        _solutionQueens = solverResult.isSolved ? solverResult.queens : const [];
        _lastSolveDuration = solverResult.duration;
      });
    } catch (_) {
      // Ignore unparseable transient frames
    } finally {
      _isProcessing = false;
    }
  }

  void _toggleAutoSolve(bool enabled) {
    setState(() {
      _autoSolveEnabled = enabled;
      if (_autoSolveEnabled) {
        _startAutoSolve();
      } else {
        _stopAutoSolve();
      }
    });
  }

  void _startAutoSolve() {
    _autoSolveTimer?.cancel();
    _autoSolveTimer = Timer.periodic(
      Duration(milliseconds: (_autoSolveIntervalSec * 1000).round()),
      (_) {
        if (_videoController.hasStream && !_isProcessing) {
          _triggerSnapAndSolve();
        }
      },
    );
  }

  void _stopAutoSolve() {
    _autoSolveTimer?.cancel();
    _autoSolveTimer = null;
  }

  void _handleManualCellColorOverride(int row, int col, int newRegion) {
    if (_currentBoard == null) return;
    final n = _currentBoard!.n;
    final updatedMatrix = List<List<int>>.generate(
      n,
      (r) => List<int>.from(_currentBoard!.regions[r]),
    );
    updatedMatrix[row][col] = newRegion;

    final updatedBoard = PuzzleBoard(n, updatedMatrix);
    final solverResult = _solutionCache.getOrSolve(
      updatedBoard,
      fixedQueens: _fixedQueens,
    );

    setState(() {
      _currentBoard = updatedBoard;
      _lastSolverResult = solverResult;
      _solutionQueens = solverResult.isSolved ? solverResult.queens : const [];
      _lastSolveDuration = solverResult.duration;
    });
  }

  void _handleClearSolution() {
    setState(() {
      _lastVisionResult = null;
      _lastSolverResult = null;
      _currentBoard = null;
      _solutionQueens = const [];
      _fixedQueens = const [];
      _solutionCache.clear();
    });
  }

  @override
  void dispose() {
    _stopAutoSolve();
    _vdoService.removeListener(_onVdoServiceChanged);
    _vdoService.dispose();
    _videoController.dispose();
    _frameGrabber.dispose();
    _streamIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoEl = _videoController.videoElement;
    final videoW = videoEl?.videoWidth ?? 1206;
    final videoH = videoEl?.videoHeight ?? 2622;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🐱 Meowdoku Live Solver', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(width: 10),
            Chip(
              label: Text('Ready • AR & Auto-Solve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              backgroundColor: Color(0xFF1E293B),
              side: BorderSide(color: Color(0xFF38BDF8), width: 0.8),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Clear Solution & Cache',
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _handleClearSolution,
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Left: Main Live Video Viewport with AR Overlay
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF020617),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayerView(controller: _videoController),

                  // AR Overlay
                  CustomPaint(
                    painter: ArSolutionPainter(
                      boardRect: _lastVisionResult?.boardRect,
                      n: _currentBoard?.n ?? _lastVisionResult?.n ?? 0,
                      solutionQueens: _solutionQueens,
                      fixedQueens: _fixedQueens,
                      videoWidth: videoW,
                      videoHeight: videoH,
                      badgeStyle: _badgeStyle,
                      showCalibration: _showCalibration,
                    ),
                  ),

                  // Overlay status banner
                  if (_lastSolverResult != null)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _lastSolverResult!.isSolved
                              ? const Color(0xFF064E3B).withValues(alpha: 0.9)
                              : const Color(0xFF7F1D1D).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _lastSolverResult!.isSolved ? Colors.greenAccent : Colors.redAccent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _lastSolverResult!.isSolved ? Icons.check_circle : Icons.error_outline,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _lastSolverResult!.isSolved
                                  ? 'Solved ${_currentBoard?.n}x${_currentBoard?.n} in ${_lastSolveDuration?.inMicroseconds ?? 0}μs'
                                  : 'No valid solution found',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (!_videoController.hasStream)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.videocam_off, size: 64, color: Colors.white24),
                          const SizedBox(height: 16),
                          Text(
                            _vdoService.status == VdoStreamStatus.connecting
                                ? 'Connecting to VDO.Ninja stream...'
                                : 'Enter a VDO.Ninja Stream ID to start solving live',
                            style: const TextStyle(color: Colors.white54, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Right: Companion Inspector & Controls Sidebar
          Container(
            width: 360,
            color: const Color(0xFF0F172A),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Connection Section
                const Text(
                  'VDO.Ninja Feed',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _streamIdController,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Stream ID / Room',
                          filled: true,
                          isDense: true,
                          fillColor: const Color(0xFF1E293B),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _handleConnect(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _vdoService.status == VdoStreamStatus.viewing
                          ? _vdoService.disconnect
                          : _handleConnect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _vdoService.status == VdoStreamStatus.viewing
                            ? Colors.redAccent
                            : const Color(0xFF38BDF8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      child: Text(
                        _vdoService.status == VdoStreamStatus.viewing ? 'Stop' : 'Connect',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Password (optional)',
                    filled: true,
                    isDense: true,
                    fillColor: const Color(0xFF1E293B),
                    prefixIcon: const Icon(Icons.lock_outline, size: 16, color: Colors.white54),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        size: 16,
                        color: Colors.white54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      splashRadius: 16,
                      tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _handleConnect(),
                ),
                const SizedBox(height: 16),

                // 2. Action Controls
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _videoController.hasStream ? _triggerSnapAndSolve : null,
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

                // 3. Auto-Solve Scanner Toggle & Slider
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.autorenew, color: Color(0xFF38BDF8), size: 18),
                              SizedBox(width: 8),
                              Text('Auto-Solve Scanner', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Switch(
                            value: _autoSolveEnabled,
                            activeThumbColor: const Color(0xFF38BDF8),
                            onChanged: _videoController.hasStream ? _toggleAutoSolve : null,
                          ),
                        ],
                      ),
                      if (_autoSolveEnabled) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Interval:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                            Text(
                              '${_autoSolveIntervalSec.toStringAsFixed(1)}s',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                            ),
                          ],
                        ),
                        Slider(
                          value: _autoSolveIntervalSec,
                          min: 0.5,
                          max: 3.0,
                          divisions: 5,
                          activeColor: const Color(0xFF38BDF8),
                          onChanged: (val) {
                            setState(() {
                              _autoSolveIntervalSec = val;
                              _startAutoSolve();
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Digital Board Inspector
                BoardInspectorView(
                  board: _currentBoard,
                  cellGrid: _lastVisionResult?.cellGrid,
                  clusterColors: _lastVisionResult?.clusterColors,
                  solutionQueens: _solutionQueens,
                  fixedQueens: _fixedQueens,
                  onCellRegionChanged: _handleManualCellColorOverride,
                ),
                const SizedBox(height: 14),

                // 5. Config & Toggles
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Solver & Vision Options', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        title: const Text('Ignore Cats & Red X', style: TextStyle(fontSize: 12)),
                        subtitle: const Text('Solve entire board from scratch', style: TextStyle(fontSize: 10, color: Colors.white54)),
                        value: _ignoreExistingQueens,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) {
                          setState(() {
                            _ignoreExistingQueens = val ?? false;
                            if (_lastVisionResult != null) _triggerSnapAndSolve();
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Show Calibration Box', style: TextStyle(fontSize: 12)),
                        value: _showCalibration,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) => setState(() => _showCalibration = val ?? true),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Overlay Icon:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                          DropdownButton<SolutionBadgeStyle>(
                            value: _badgeStyle,
                            dropdownColor: const Color(0xFF1E293B),
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(value: SolutionBadgeStyle.catFace, child: Text('🐱 Cat')),
                              DropdownMenuItem(value: SolutionBadgeStyle.crown, child: Text('👑 Crown')),
                              DropdownMenuItem(value: SolutionBadgeStyle.paw, child: Text('🐾 Paw')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _badgeStyle = val);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 6. Cache Stats
                Container(
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
                          const Text('Cache Size', style: TextStyle(fontSize: 11, color: Colors.white54)),
                          const SizedBox(height: 2),
                          Text('${_solutionCache.size}/10', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Hits', style: TextStyle(fontSize: 11, color: Colors.white54)),
                          const SizedBox(height: 2),
                          Text('${_solutionCache.hits}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Misses', style: TextStyle(fontSize: 11, color: Colors.white54)),
                          const SizedBox(height: 2),
                          Text('${_solutionCache.misses}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
