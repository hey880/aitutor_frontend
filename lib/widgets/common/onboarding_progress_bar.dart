import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Onboarding progress bar widget showing step count and progress.
class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: AppTextStyles.labelLarge(color: AppColors.slate600),
            ),
            Text(
              '$percentage%',
              style: AppTextStyles.labelLarge(color: AppColors.slate600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.slate100,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
