import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'back_button.dart';

/// Unified onboarding header with progress bar.
/// Matches the style from schedule_setup_screen.
class OnboardingHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String stepTitle;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final bool showNextButton;

  const OnboardingHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitle,
    this.onBack,
    this.onNext,
    this.showNextButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Column(
      children: [
        // Header row with back button, title, and optional next button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              AppBackButton(
                onPressed: onBack ?? () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'Onboarding',
                  style: AppTextStyles.titleMedium(),
                  textAlign: TextAlign.center,
                ),
              ),
              if (showNextButton && onNext != null)
                GestureDetector(
                  onTap: onNext,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),

        // Progress bar section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stepTitle,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.textDark,
                    ).copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Step $currentStep of $totalSteps',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.slate100,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
