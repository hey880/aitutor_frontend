import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';

/// End call modal with feedback options.
/// Original: active_ai_conversation_1 (modal)
class EndCallModal extends StatefulWidget {
  const EndCallModal({super.key});

  @override
  State<EndCallModal> createState() => _EndCallModalState();
}

class _EndCallModalState extends State<EndCallModal> {
  int _selectedReason = 0;

  final List<String> _reasons = [
    "I've finished my practice",
    "It's a bad time",
    "The AI didn't understand me",
    "Technical issues",
    "Other",
  ];

  void _submitAndClose() {
    // Close modal
    Navigator.pop(context);

    // Navigate to session detail (performance summary) and clear call stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.sessionDetail,
      (route) => route.settings.name == AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag indicator
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Why are you ending the call?',
                style: AppTextStyles.titleMedium(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Your feedback helps improve your coach.',
                style: AppTextStyles.bodyMedium(color: AppColors.slate400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Options
              ...List.generate(_reasons.length, (index) {
                final isSelected = _selectedReason == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedReason = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.xxl),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _reasons[index],
                              style: AppTextStyles.bodyMedium(color: Colors.white)
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white.withValues(alpha: 0.2),
                                width: 2,
                              ),
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Submit button
              GestureDetector(
                onTap: _submitAndClose,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Submit & Close',
                      style: AppTextStyles.bodyLarge(color: Colors.white)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
