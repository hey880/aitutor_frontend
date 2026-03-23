import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/onboarding_header.dart';
import '../../widgets/common/primary_button.dart';

/// Self introduction screen for users to describe themselves.
/// Original: self_introduction
class SelfIntroductionScreen extends StatefulWidget {
  const SelfIntroductionScreen({super.key});

  @override
  State<SelfIntroductionScreen> createState() => _SelfIntroductionScreenState();
}

class _SelfIntroductionScreenState extends State<SelfIntroductionScreen> {
  final _introController = TextEditingController();

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    Navigator.pushNamed(
      context,
      '/onboarding/create-account',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress bar
            OnboardingHeader(
              currentStep: 8,
              totalSteps: 8,
              stepTitle: 'Self Introduction',
              showNextButton: true,
              onNext: _navigateToNext,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Tell me about yourself so I can prepare our first conversation.',
                      style: AppTextStyles.displayHero().copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Mention your hobbies, job, or why you're learning English. This helps me tailor our lessons to your needs.",
                      style: AppTextStyles.bodyMedium(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 32),

                    // Large text field
                    Stack(
                      children: [
                        TextField(
                          controller: _introController,
                          maxLines: 8,
                          style: AppTextStyles.bodyLarge(),
                          decoration: InputDecoration(
                            hintText:
                                "I'm a marketing manager from Seoul, I want to practice business English and talk about travel...",
                            hintStyle:
                                AppTextStyles.bodyLarge(color: AppColors.slate400),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xxl),
                              borderSide:
                                  const BorderSide(color: AppColors.slate200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xxl),
                              borderSide:
                                  const BorderSide(color: AppColors.slate200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xxl),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 1),
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            constraints: const BoxConstraints(minHeight: 240),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Text(
                            'Optional',
                            style: AppTextStyles.bodySmall(
                              color: AppColors.slate300,
                            ).copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tip
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 18,
                          color: AppColors.primary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Example: "I love hiking and I\'m learning English for a trip to London."',
                            style: AppTextStyles.bodySmall(
                              color: AppColors.primary.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Finish',
                    onPressed: _navigateToNext,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _navigateToNext,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Skip for now',
                        style: AppTextStyles.bodyMedium(color: AppColors.slate400)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
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
