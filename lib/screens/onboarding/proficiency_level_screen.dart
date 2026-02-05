import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../services/api_service.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/onboarding_progress_bar.dart';
import '../../widgets/common/primary_button.dart';

/// Proficiency level selection screen.
/// Original: select_proficiency_level
class ProficiencyLevelScreen extends StatefulWidget {
  const ProficiencyLevelScreen({super.key});

  @override
  State<ProficiencyLevelScreen> createState() => _ProficiencyLevelScreenState();
}

class _ProficiencyLevelScreenState extends State<ProficiencyLevelScreen> {
  // Default selection: Intermediate (index 1)
  int? _selectedIndex = 1;

  final List<_ProficiencyOption> _options = [
    _ProficiencyOption(
      icon: Icons.child_care,
      title: 'Beginner',
      description: "I'm just starting to learn",
    ),
    _ProficiencyOption(
      icon: Icons.forum,
      title: 'Intermediate',
      description: 'I can have everyday conversations',
    ),
    _ProficiencyOption(
      icon: Icons.school,
      title: 'Advanced',
      description: 'I can speak fluently on complex topics',
    ),
    _ProficiencyOption(
      icon: Icons.psychology,
      title: 'Fluent',
      description: 'I use English like a native speaker',
    ),
  ];

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
                      'Onboarding',
                      style: AppTextStyles.titleMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for back button
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step 1: Proficiency',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textDark,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '1 of 8',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const OnboardingProgressBar(currentStep: 1, totalSteps: 8),
                ],
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  Text(
                    'What is your English level?',
                    style: AppTextStyles.displayHero().copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This helps us personalize your AI learning path.',
                    style: AppTextStyles.bodyMedium(color: AppColors.slate600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Options list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final option = _options[index];
                  final isSelected = _selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ProficiencyOptionTile(
                      option: option,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                text: 'Next',
                leadingIcon: Icons.arrow_forward,
                onPressed: _selectedIndex != null
                    ? () async {
                        // Map UI index to API level (backend: beginner, intermediate, advanced)
                        final levelMap = ['beginner', 'intermediate', 'advanced', 'advanced'];
                        final level = levelMap[_selectedIndex!];
                        await ApiService.saveOnboardingLevel(level);
                        if (context.mounted) {
                          Navigator.pushNamed(
                            context,
                            '/onboarding/learning-goals',
                          );
                        }
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ProficiencyOption {
  final IconData icon;
  final String title;
  final String description;

  _ProficiencyOption({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _ProficiencyOptionTile extends StatelessWidget {
  final _ProficiencyOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProficiencyOptionTile({
    required this.option,
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.slate100,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.slate100),
              ),
              child: Icon(
                option.icon,
                size: 24,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: AppTextStyles.bodyLarge().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.description,
                    style: AppTextStyles.bodyMedium(color: AppColors.slate500),
                  ),
                ],
              ),
            ),

            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.slate300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
