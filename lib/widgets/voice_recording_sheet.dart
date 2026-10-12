import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/voice_note_model.dart';
import '../theme/app_theme.dart';

class VoiceRecordingSheet extends StatefulWidget {
  final ValueChanged<VoiceNoteModel>? onSaved;

  const VoiceRecordingSheet({super.key, this.onSaved});

  static Future<VoiceNoteModel?> show(BuildContext context) {
    return showModalBottomSheet<VoiceNoteModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const VoiceRecordingSheet(),
    );
  }

  @override
  State<VoiceRecordingSheet> createState() => _VoiceRecordingSheetState();
}

enum _RecordState { recording, paused, stopped }

class _VoiceRecordingSheetState extends State<VoiceRecordingSheet>
    with SingleTickerProviderStateMixin {
  _RecordState _recordState = _RecordState.recording;
  int _seconds = 0;
  Timer? _timer;
  late AnimationController _animController;

  final List<double> _baseHeights = [
    8, 14, 22, 34, 46, 30, 18, 42, 52, 36, 24, 48,
    50, 26, 18, 38, 44, 28, 16, 32, 22, 14, 20, 10
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_recordState == _RecordState.recording) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      if (_recordState == _RecordState.recording) {
        _recordState = _RecordState.paused;
        _animController.stop();
      } else if (_recordState == _RecordState.paused) {
        _recordState = _RecordState.recording;
        _animController.repeat(reverse: true);
      }
    });
  }

  void _stop() {
    setState(() {
      _recordState = _RecordState.stopped;
      _animController.stop();
      _timer?.cancel();
    });
  }

  void _send() {
    _timer?.cancel();
    final note = VoiceNoteModel(
      id: 'vn_${DateTime.now().millisecondsSinceEpoch}',
      durationSeconds: max(1, _seconds),
      recordedAt: DateTime.now(),
    );
    widget.onSaved?.call(note);
    Navigator.of(context).pop(note);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final mins = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Row: Status and Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _recordState == _RecordState.recording
                            ? const Color(0xFFE11D48)
                            : (_recordState == _RecordState.paused
                                ? AppColors.warning
                                : AppColors.textSecondary),
                        shape: BoxShape.circle,
                        boxShadow: _recordState == _RecordState.recording
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFE11D48).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _recordState == _RecordState.recording
                          ? 'Recording...'
                          : (_recordState == _RecordState.paused
                              ? 'Paused'
                              : 'Stopped'),
                      style: TextStyle(
                        color: _recordState == _RecordState.recording
                            ? const Color(0xFFE11D48)
                            : (_recordState == _RecordState.paused
                                ? AppColors.warning
                                : AppColors.textSecondary),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Animated Audio Waveform
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(_baseHeights.length, (index) {
                      final base = _baseHeights[index];
                      final factor = _recordState == _RecordState.recording
                          ? (0.5 + 0.5 * sin((index + _animController.value * 6)))
                          : (_recordState == _RecordState.paused ? 0.4 : 0.2);
                      final h = (base * factor).clamp(6.0, 52.0);

                      return Container(
                        width: 3.5,
                        height: h,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Timer display
            Text(
              _formattedTime,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B4B),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 28),

            // 3 Action Buttons Row: Pause, Stop, Send
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Pause / Resume
                _buildActionButton(
                  onTap: _recordState != _RecordState.stopped ? _togglePause : null,
                  button: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDE9FE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _recordState == _RecordState.paused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      color: const Color(0xFF6D28D9),
                      size: 26,
                    ),
                  ),
                  label: _recordState == _RecordState.paused ? 'Resume' : 'Pause',
                ),

                // Stop Button
                _buildActionButton(
                  onTap: _recordState != _RecordState.stopped ? _stop : null,
                  button: Container(
                    width: 68,
                    height: 68,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFE4E6),
                      border: Border.all(
                        color: const Color(0xFFFECDD3),
                        width: 1.5,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE11D48),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.stop_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  label: 'Stop',
                ),

                // Send Button
                _buildActionButton(
                  onTap: _seconds > 0 ? _send : null,
                  button: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7C3AED),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  label: 'Send',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onTap,
    required Widget button,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
