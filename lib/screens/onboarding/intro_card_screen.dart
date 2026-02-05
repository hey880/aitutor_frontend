import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';

/// Intro card screen explaining the app concept.
/// Original: personal_information_8
class IntroCardScreen extends StatelessWidget {
  const IntroCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  AppBackButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Step 4 of 8',
                      style: AppTextStyles.bodyMedium(color: AppColors.slate500)
                          .copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Onboarding Progress',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textDark,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '50%',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primary,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: AppColors.slate100,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Large icon with badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Pulse effect background
                        Container(
                          width: 144,
                          height: 144,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.05),
                          ),
                        ),
                        // Main icon container
                        Container(
                          width: 128,
                          height: 128,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                          child: const Icon(
                            Icons.call,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                        // Green check badge
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.callGreen,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Title
                    Text(
                      'Real conversations,\nreal progress.',
                      style: AppTextStyles.displayHero().copyWith(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'Your AI tutor will call you at your scheduled time for a natural 10-minute chat.',
                      style: AppTextStyles.bodyLarge(color: AppColors.slate500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Feature cards
                    _FeatureCard(
                      icon: Icons.schedule,
                      title: 'Scheduled for you',
                      description: 'Fits perfectly into your daily routine',
                    ),
                    const SizedBox(height: 16),
                    _FeatureCard(
                      icon: Icons.forum,
                      title: 'Natural dialogue',
                      description: 'Practice speaking in a stress-free environment',
                    ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.slate100),
                ),
              ),
              child: PrimaryButton(
                text: 'Sounds Great',
                leadingIcon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/onboarding/schedule-setup',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate100.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [AppShadows.cardShadow],
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium().copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTextStyles.bodySmall(color: AppColors.slate500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
