import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Swipeable expression card for PageView.
/// Displays expression, translation, and example.
class ExpressionCard extends StatelessWidget {
  final String expression;
  final String translation;
  final String example;

  const ExpressionCard({
    super.key,
    required this.expression,
    required this.translation,
    required this.example,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [AppShadows.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Expression (primary color, bold)
          Text(
            expression,
            style: AppTextStyles.titleMedium(color: AppColors.primary).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Korean translation
          Text(
            translation,
            style: AppTextStyles.bodyMedium(color: AppColors.slate500).copyWith(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),

          // Example label
          Text(
            'EXAMPLE:',
            style: AppTextStyles.labelSmall(color: AppColors.slate400).copyWith(
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),

          // Example sentence
          Text(
            example,
            style: AppTextStyles.bodyMedium().copyWith(
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
