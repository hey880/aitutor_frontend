import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Message bubble for conversation display.
/// Supports AI and User messages with audio/practice buttons.
class MessageBubble extends StatelessWidget {
  final bool isUser;
  final String text;
  final String? translatedText;
  final String timestamp;
  final int? pronunciationScore;
  final VoidCallback? onPlayAudio;
  final VoidCallback? onPractice;
  final VoidCallback? onFeedback;
  final bool showTimestamp;

  const MessageBubble({
    super.key,
    required this.isUser,
    required this.text,
    this.translatedText,
    required this.timestamp,
    this.pronunciationScore,
    this.onPlayAudio,
    this.onPractice,
    this.onFeedback,
    this.showTimestamp = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action buttons for AI messages (left side)
          if (!isUser) ...[
            _buildActionButtons(),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.aiBubbleLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? AppRadius.xxl : 0),
                  topRight: Radius.circular(isUser ? 0 : AppRadius.xxl),
                  bottomLeft: const Radius.circular(AppRadius.xxl),
                  bottomRight: const Radius.circular(AppRadius.xxl),
                ),
                boxShadow: [AppShadows.cardShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main text
                  Text(
                    text,
                    style: AppTextStyles.bodyMedium(
                      color: isUser ? Colors.white : AppColors.textDark,
                    ).copyWith(
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  // Korean translation (AI messages only, show only if not empty)
                  if (!isUser && translatedText != null && translatedText!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppColors.slate200.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      child: Text(
                        translatedText!,
                        style: AppTextStyles.bodySmall(color: AppColors.slate500).copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],

                  // Feedback button and score (for user messages)
                  if (isUser) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onFeedback != null)
                          GestureDetector(
                            onTap: onFeedback,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(AppRadius.full),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.analytics,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Feedback',
                                    style: AppTextStyles.labelSmall(color: Colors.white)
                                        .copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (onFeedback != null && pronunciationScore != null)
                          const SizedBox(width: 8),
                        if (pronunciationScore != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              '$pronunciationScore%',
                              style: AppTextStyles.labelSmall(
                                color: Colors.white,
                              ).copyWith(fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                  ] else if (showTimestamp) ...[
                    // Timestamp for AI messages (only if showTimestamp is true)
                    const SizedBox(height: 8),
                    Text(
                      timestamp,
                      style: AppTextStyles.labelSmall(
                        color: AppColors.slate400,
                      ).copyWith(fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Action buttons for User messages (right side)
          if (isUser) ...[
            const SizedBox(width: 8),
            _buildActionButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play audio button
        _ActionIconButton(
          icon: Icons.volume_up,
          onTap: onPlayAudio,
        ),
        const SizedBox(height: 4),
        // Practice button
        _ActionIconButton(
          icon: Icons.mic,
          onTap: onPractice,
        ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionIconButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.slate100,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.slate200),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppColors.slate500,
        ),
      ),
    );
  }
}
