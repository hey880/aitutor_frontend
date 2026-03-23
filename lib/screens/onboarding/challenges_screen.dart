import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/onboarding_header.dart';
import '../../widgets/common/primary_button.dart';

/// Challenges selection screen.
/// Original: personal_information_7
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  // Default selection: Pronunciation (index 0)
  final Set<int> _selectedIndices = {0};

  final List<_Challenge> _challenges = [
    _Challenge(
      icon: Icons.record_voice_over,
      title: 'Pronunciation',
      description: 'Mastering accents and phonetic sounds',
    ),
    _Challenge(
      icon: Icons.hearing,
      title: 'Listening',
      description: 'Understanding native speakers at speed',
    ),
    _Challenge(
      icon: Icons.edit_note,
      title: 'Grammar',
      description: 'Rules, verb tenses, and sentence structure',
    ),
    _Challenge(
      icon: Icons.psychology,
      title: 'Speaking Confidence',
      description: 'Overcoming the fear of making mistakes',
    ),
    _Challenge(
      icon: Icons.menu_book,
      title: 'Vocabulary',
      description: 'Expressing yourself with the right words',
    ),
  ];

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _navigateToNext() {
    Navigator.pushNamed(context, '/onboarding/intro-card');
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
              currentStep: 3,
              totalSteps: 8,
              stepTitle: 'Challenges',
              showNextButton: _selectedIndices.isNotEmpty,
              onNext: _selectedIndices.isNotEmpty ? _navigateToNext : null,
            ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is your biggest challenge in learning English?',
                    style: AppTextStyles.displayHero().copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select all that apply to help us tailor your daily exercises.',
                    style: AppTextStyles.bodyMedium(color: AppColors.slate500),
                  ),
                ],
              ),
            ),

            // Challenges list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _challenges.length,
                itemBuilder: (context, index) {
                  final challenge = _challenges[index];
                  final isSelected = _selectedIndices.contains(index);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ChallengeTile(
                      challenge: challenge,
                      isSelected: isSelected,
                      onTap: () => _toggleSelection(index),
                    ),
                  );
                },
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
                text: 'Continue',
                leadingIcon: Icons.arrow_forward,
                onPressed: _selectedIndices.isNotEmpty ? _navigateToNext : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Challenge {
  final IconData icon;
  final String title;
  final String description;

  _Challenge({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _ChallengeTile extends StatelessWidget {
  final _Challenge challenge;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChallengeTile({
    required this.challenge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.slate200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.slate100,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                challenge.icon,
                size: 28,
                color: isSelected ? AppColors.primary : AppColors.slate600,
              ),
            ),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: AppTextStyles.titleMedium().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    challenge.description,
                    style: AppTextStyles.bodyMedium(color: AppColors.slate500),
                  ),
                ],
              ),
            ),

            // Check indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.slate200,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
