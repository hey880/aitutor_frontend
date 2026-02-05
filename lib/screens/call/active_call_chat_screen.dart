import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../utils/stub_services.dart';
import 'end_call_modal.dart';

/// Active call chat screen with message bubbles.
/// Original: active_ai_conversation_2, _3
class ActiveCallChatScreen extends StatefulWidget {
  const ActiveCallChatScreen({super.key});

  @override
  State<ActiveCallChatScreen> createState() => _ActiveCallChatScreenState();
}

class _ActiveCallChatScreenState extends State<ActiveCallChatScreen> {
  late int _seconds;
  Timer? _timer;
  bool _isDarkMode = false;
  bool _isMuted = false;

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      isUser: false,
      text: "Hello! I'm ready to help you practice. How was your day today?",
      translation: "안녕하세요! 연습을 도와드릴 준비가 됐어요. 오늘 하루 어떠셨나요?",
      time: "10:02 AM",
    ),
    _ChatMessage(
      isUser: true,
      text: "I had a very busy day. I went to the market and bought some fruits.",
      time: "10:03 AM",
    ),
    _ChatMessage(
      isUser: false,
      text: "That sounds productive! What kind of fruits did you buy at the market?",
      translation: "생산적인 하루였네요! 시장에서 어떤 종류의 과일을 사셨나요?",
      time: "10:03 AM",
    ),
    _ChatMessage(
      isUser: true,
      text: "I bought apples and bananas. They was very fresh.",
      time: "10:04 AM",
    ),
  ];

  final bool _isThinking = true;

  @override
  void initState() {
    super.initState();
    _seconds = StubServices.callDurationSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final min = (_seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (_seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

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
    final bgColor = _isDarkMode ? AppColors.darkBg : Colors.white;
    final textColor = _isDarkMode ? Colors.white : AppColors.textDark;
    final aiBubbleColor = _isDarkMode ? AppColors.aiBubbleDark : AppColors.aiBubbleLight;
    final borderColor = _isDarkMode ? AppColors.slate700 : AppColors.slate100;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.95),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
              ),
              child: Row(
                children: [
                  // AI Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: aiBubbleColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor),
                    ),
                    child: Icon(
                      Icons.smart_toy,
                      size: 20,
                      color: _isDarkMode ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coach Sarah',
                          style: AppTextStyles.bodyMedium(color: textColor)
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.callGreen,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ACTIVE SESSION',
                              style: AppTextStyles.labelSmall(
                                color: AppColors.slate400,
                              ).copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Timer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.slate100,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      _formattedTime,
                      style: AppTextStyles.labelLarge(
                        color: _isDarkMode ? Colors.white : AppColors.slate600,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),

                  // Dark mode toggle
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isDarkMode = !_isDarkMode),
                    child: Icon(
                      _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: _isDarkMode ? Colors.white : AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),

            // Chat list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isThinking ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isThinking) {
                    return _ThinkingIndicator(isDarkMode: _isDarkMode);
                  }
                  return _ChatBubble(
                    message: _messages[index],
                    isDarkMode: _isDarkMode,
                  );
                },
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.95),
                border: Border(
                  top: BorderSide(color: borderColor),
                ),
              ),
              child: Column(
                children: [
                  // Listening indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Vertical bars
                        ...List.generate(5, (i) {
                          final heights = [12.0, 20.0, 28.0, 16.0, 24.0];
                          return Container(
                            width: 2,
                            height: heights[i],
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          'LISTENING...',
                          style: AppTextStyles.labelSmall(color: AppColors.primary)
                              .copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ChatControlButton(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        label: 'Mute',
                        isDarkMode: _isDarkMode,
                        onTap: () => setState(() => _isMuted = !_isMuted),
                      ),
                      _ChatControlButton(
                        icon: Icons.volume_up,
                        label: 'Speaker',
                        isDarkMode: _isDarkMode,
                        onTap: () {},
                      ),
                      _ChatControlButton(
                        icon: Icons.replay,
                        secondaryIcon: Icons.pause,
                        label: 'Reset Turn',
                        isDarkMode: _isDarkMode,
                        onTap: () {},
                      ),
                      _ChatControlButton(
                        icon: Icons.call_end,
                        label: 'End Call',
                        isEndCall: true,
                        isDarkMode: _isDarkMode,
                        onTap: _showEndCallModal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;
  final String? translation;
  final String time;

  _ChatMessage({
    required this.isUser,
    required this.text,
    this.translation,
    required this.time,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  final bool isDarkMode;

  const _ChatBubble({
    required this.message,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final bubbleColor = isUser
        ? AppColors.userBubble
        : (isDarkMode ? AppColors.aiBubbleDark : AppColors.aiBubbleLight);
    final textColor = isUser
        ? Colors.white
        : (isDarkMode ? Colors.white : AppColors.textDark);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? AppRadius.xxl : 0),
                topRight: Radius.circular(isUser ? 0 : AppRadius.xxl),
                bottomLeft: const Radius.circular(AppRadius.xxl),
                bottomRight: const Radius.circular(AppRadius.xxl),
              ),
              boxShadow: isUser
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [AppShadows.cardShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: AppTextStyles.bodyMedium(color: textColor)
                      .copyWith(height: 1.5),
                ),
                if (!isUser && message.translation != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.1)
                              : AppColors.slate200.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    child: Text(
                      message.translation!,
                      style: AppTextStyles.bodySmall(
                        color: isDarkMode ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isUser) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDarkMode ? AppColors.slate700 : AppColors.slate100,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: isDarkMode ? AppColors.slate600 : AppColors.slate200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.analytics,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Feedback',
                        style: AppTextStyles.labelSmall(color: AppColors.primary)
                            .copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                message.time,
                style: AppTextStyles.labelSmall(color: AppColors.slate400)
                    .copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThinkingIndicator extends StatelessWidget {
  final bool isDarkMode;

  const _ThinkingIndicator({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.aiBubbleDark : AppColors.aiBubbleLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(AppRadius.xxl),
            bottomLeft: Radius.circular(AppRadius.xxl),
            bottomRight: Radius.circular(AppRadius.xxl),
          ),
          border: Border.all(
            color: isDarkMode ? AppColors.slate700 : AppColors.slate100,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouncing dots
            ...List.generate(3, (i) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 600 + (i * 200)),
                builder: (context, value, child) {
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(
                        alpha: 0.4 + (i * 0.2),
                      ),
                    ),
                  );
                },
              );
            }),
            const SizedBox(width: 8),
            Text(
              'SARAH IS THINKING',
              style: AppTextStyles.labelSmall(color: AppColors.primary).copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatControlButton extends StatelessWidget {
  final IconData icon;
  final IconData? secondaryIcon;
  final String label;
  final bool isEndCall;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _ChatControlButton({
    required this.icon,
    this.secondaryIcon,
    required this.label,
    this.isEndCall = false,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isEndCall
        ? AppColors.callRed
        : (isDarkMode ? Colors.white.withValues(alpha: 0.1) : AppColors.slate100);
    final iconColor = isEndCall
        ? Colors.white
        : (isDarkMode ? Colors.white : AppColors.slate600);
    final labelColor = isEndCall
        ? AppColors.callRed
        : (isDarkMode ? AppColors.slate400 : AppColors.slate500);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: isEndCall
                  ? null
                  : Border.all(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.slate200,
                    ),
              boxShadow: isEndCall
                  ? [
                      BoxShadow(
                        color: AppColors.callRed.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: secondaryIcon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(secondaryIcon, size: 18, color: iconColor),
                        Icon(icon, size: 18, color: iconColor),
                      ],
                    )
                  : Icon(icon, size: 24, color: iconColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall(color: labelColor).copyWith(
              fontSize: 10,
              fontWeight: isEndCall ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
