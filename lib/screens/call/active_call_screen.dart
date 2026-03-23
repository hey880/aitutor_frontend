import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../utils/stub_services.dart';
import '../../widgets/call/audio_visualizer.dart';
import 'end_call_modal.dart';

/// Active call screen with audio visualizer.
/// Original: active_ai_conversation_1
class ActiveCallScreen extends StatefulWidget {
  const ActiveCallScreen({super.key});

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  late int _seconds;
  Timer? _timer;
  int _languageToggle = 0; // 0 = English Only, 1 = KR Translation
  bool _isMuted = false;
  bool _isSpeakerOn = true;

  @override
  void initState() {
    super.initState();
    _seconds = StubServices.callDurationSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedMinutes => (_seconds ~/ 60).toString().padLeft(2, '0');
  String get _formattedSeconds => (_seconds % 60).toString().padLeft(2, '0');

  void _showEndCallModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EndCallModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header with timer
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  // Live Session indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'LIVE SESSION',
                        style: AppTextStyles.labelSmall(
                          color: AppColors.slate400,
                        ).copyWith(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TimerBox(value: _formattedMinutes, label: 'MIN'),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          ':',
                          style: AppTextStyles.titleLarge(color: AppColors.primary)
                              .copyWith(fontSize: 20),
                        ),
                      ),
                      _TimerBox(value: _formattedSeconds, label: 'SEC'),
                    ],
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'AI Language Coach',
                    style: AppTextStyles.titleLarge(color: Colors.white)
                        .copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Listening...',
                    style: AppTextStyles.bodyMedium(color: AppColors.primary)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 32),

                  // Audio visualizer
                  const AudioVisualizer(size: 192),
                ],
              ),
            ),

            // Footer controls
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Language toggle
                  Container(
                    width: 256,
                    height: 36,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _languageToggle = 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _languageToggle == 0
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full),
                              ),
                              child: Center(
                                child: Text(
                                  'English Only',
                                  style: AppTextStyles.labelLarge(
                                    color: _languageToggle == 0
                                        ? Colors.white
                                        : AppColors.slate400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _languageToggle = 1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _languageToggle == 1
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full),
                              ),
                              child: Center(
                                child: Text(
                                  'KR Translation',
                                  style: AppTextStyles.labelLarge(
                                    color: _languageToggle == 1
                                        ? Colors.white
                                        : AppColors.slate400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Control buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ControlButton(
                          icon: _isMuted ? Icons.mic_off : Icons.mic,
                          label: 'Mute',
                          isActive: _isMuted,
                          onTap: () => setState(() => _isMuted = !_isMuted),
                        ),
                        _ControlButton(
                          icon: Icons.volume_up,
                          label: 'Speaker',
                          isActive: _isSpeakerOn,
                          onTap: () =>
                              setState(() => _isSpeakerOn = !_isSpeakerOn),
                        ),
                        _ControlButton(
                          icon: Icons.replay,
                          label: 'Reset Turn',
                          secondaryIcon: Icons.pause,
                          onTap: () {
                            // TODO: Reset turn
                          },
                        ),
                        _EndCallButton(
                          onTap: _showEndCallModal,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerBox extends StatelessWidget {
  final String value;
  final String label;

  const _TimerBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Center(
              child: Text(
                value,
                style: AppTextStyles.titleLarge(color: Colors.white)
                    .copyWith(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall(color: AppColors.slate400)
                .copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final IconData? secondaryIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    this.secondaryIcon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Center(
              child: secondaryIcon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(secondaryIcon, size: 16, color: Colors.white),
                        Icon(icon, size: 16, color: Colors.white),
                      ],
                    )
                  : Icon(
                      icon,
                      size: 24,
                      color: Colors.white,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall(color: AppColors.slate400).copyWith(
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _EndCallButton extends StatelessWidget {
  final VoidCallback onTap;

  const _EndCallButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.callRed,
              boxShadow: [
                BoxShadow(
                  color: AppColors.callRed.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.call_end,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'END CALL',
            style: AppTextStyles.labelSmall(color: AppColors.callRed).copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
