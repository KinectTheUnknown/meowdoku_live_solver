import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/ingestion/vdo_ninja_service.dart';

/// Sidebar card managing VDO.Ninja stream credentials and connection lifecycle.
class StreamConnectionCard extends ConsumerStatefulWidget {
  const StreamConnectionCard({super.key});

  @override
  ConsumerState<StreamConnectionCard> createState() => _StreamConnectionCardState();
}

class _StreamConnectionCardState extends ConsumerState<StreamConnectionCard> {
  final _streamIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _streamIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleConnect() {
    final streamId = _streamIdController.text.trim();
    final passwordText = _passwordController.text.trim();
    final password = passwordText.isNotEmpty ? passwordText : null;
    if (streamId.isNotEmpty) {
      ref.read(vdoNinjaStreamProvider.notifier).viewStream(streamId, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vdoState = ref.watch(vdoNinjaStreamProvider);
    final isConnecting = vdoState.status == VdoStreamStatus.connecting ||
        vdoState.status == VdoStreamStatus.initializing;
    final isViewing = vdoState.status == VdoStreamStatus.viewing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VDO.Ninja Feed',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _streamIdController,
                enabled: !isConnecting,
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
              onPressed: isConnecting
                  ? null
                  : isViewing
                      ? ref.read(vdoNinjaStreamProvider.notifier).disconnect
                      : _handleConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: isViewing ? Colors.redAccent : const Color(0xFF38BDF8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
              child: isConnecting
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isViewing ? 'Stop' : 'Connect',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          enabled: !isConnecting,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Password (optional)',
            filled: true,
            isDense: true,
            fillColor: const Color(0xFF1E293B),
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 16,
              color: Colors.white54,
            ),
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

        // Error message banner
        if (vdoState.errorMessage != null && vdoState.errorMessage!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7F1D1D).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.8)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline, size: 14, color: Colors.redAccent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    vdoState.errorMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
