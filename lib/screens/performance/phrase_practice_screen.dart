import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../utils/stub_services.dart';

/// Phrase practice screen with mic button.
/// Original: call_performance_summary_1
class PhrasePracticeScreen extends StatefulWidget {
  const PhrasePracticeScreen({super.key});

  @override
  State<PhrasePracticeScreen> createState() => _PhrasePracticeScreenState();
}

class _PhrasePracticeScreenState extends State<PhrasePracticeScreen> {
  int _currentIndex = 0;
  bool _isHolding = false;

  List<Map<String, String>> get _phrases => StubServices.practicePhrases;
  int get _totalPhrases => _phrases.length;

  void _onClose() {
    Navigator.pop(context);
  }

  void _onMicPressed() {
    setState(() => _isHolding = true);
  }

  void _onMicReleased() {
    setState(() => _isHolding = false);
    // Move to next phrase after speaking
    if (_currentIndex < _totalPhrases - 1) {
      setState(() => _currentIndex++);
    } else {
      // Completed all phrases - navigate back
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phrase = _phrases[_currentIndex];
    final progress = (_currentIndex + 1) / _totalPhrases;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: AppColors.slate500,
                    onPressed: _onClose,
                  ),
                  Expanded(
                    child: Text(
                      'Practice Session',
                      style: AppTextStyles.titleMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    '${_currentIndex + 1} of $_totalPhrases phrases',
                    style: AppTextStyles.bodySmall(color: AppColors.primary)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.slate100,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // English sentence
                    Text(
                      phrase['english'] ?? '',
                      style: AppTextStyles.titleLarge().copyWith(
                        fontSize: 22,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Korean translation
                    Text(
                      phrase['korean'] ?? '',
                      style: AppTextStyles.bodyMedium(color: AppColors.slate500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Listen button
                    GestureDetector(
                      onTap: () {
                        // TODO: Play audio
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          border: Border.all(color: AppColors.slate200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.volume_up,
                              size: 20,
                              color: AppColors.slate600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Listen',
                              style: AppTextStyles.bodyMedium(
                                color: AppColors.slate600,
                              ).copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              child: Column(
                children: [
                  // Info text
                  Text(
                    'Press and hold to start speaking',
                    style: AppTextStyles.bodySmall(color: AppColors.slate400),
                  ),
                  const SizedBox(height: 20),

                  // Mic button
                  GestureDetector(
                    onTapDown: (_) => _onMicPressed(),
                    onTapUp: (_) => _onMicReleased(),
                    onTapCancel: () => _onMicReleased(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isHolding
                            ? AppColors.primary.withValues(alpha: 0.8)
                            : AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: _isHolding ? 24 : 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.mic,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Hold to Speak text
                  Text(
                    _isHolding ? 'Listening...' : 'Hold to Speak',
                    style: AppTextStyles.bodyMedium(
                      color: _isHolding ? AppColors.primary : AppColors.slate500,
                    ).copyWith(fontWeight: FontWeight.w500),
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
