import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/onboarding_header.dart';
import '../../widgets/common/primary_button.dart';

/// Learning goals selection screen.
/// Original: select_learning_goals
class LearningGoalsScreen extends StatefulWidget {
  const LearningGoalsScreen({super.key});

  @override
  State<LearningGoalsScreen> createState() => _LearningGoalsScreenState();
}

class _LearningGoalsScreenState extends State<LearningGoalsScreen> {
  // Default selection: Travel (index 1)
  final Set<int> _selectedIndices = {1};

  final List<_LearningGoal> _goals = [
    _LearningGoal(icon: Icons.work, title: 'Career'),
    _LearningGoal(icon: Icons.flight_takeoff, title: 'Travel'),
    _LearningGoal(icon: Icons.school, title: 'Exams'),
    _LearningGoal(icon: Icons.forum, title: 'Conversation'),
    _LearningGoal(icon: Icons.sports_esports, title: 'Hobbies'),
    _LearningGoal(icon: Icons.home_work, title: 'Relocation'),
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
    Navigator.pushNamed(context, '/onboarding/challenges');
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
              currentStep: 2,
              totalSteps: 8,
              stepTitle: 'Learning Goals',
              showNextButton: _selectedIndices.isNotEmpty,
              onNext: _selectedIndices.isNotEmpty ? _navigateToNext : null,
            ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Why are you learning English?',
                  style: AppTextStyles.displayHero().copyWith(fontSize: 28),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose all that apply to personalize your AI tutor experience.',
                  style: AppTextStyles.bodyMedium(color: AppColors.slate600),
                ),
              ),
            ),

            // Goals grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _goals.length,
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    final isSelected = _selectedIndices.contains(index);

                    return _LearningGoalCard(
                      goal: goal,
                      isSelected: isSelected,
                      onTap: () => _toggleSelection(index),
                    );
                  },
                ),
              ),
            ),

            // Bottom button (fixed)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
              ),
              child: PrimaryButton(
                text: 'Next',
                leadingIcon: Icons.arrow_forward,
                onPressed: _selectedIndices.isNotEmpty ? _navigateToNext : null,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _LearningGoal {
  final IconData icon;
  final String title;

  _LearningGoal({required this.icon, required this.title});
}

class _LearningGoalCard extends StatelessWidget {
  final _LearningGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _LearningGoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.slate200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon container
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Icon(
                      goal.icon,
                      size: 28,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    goal.title,
                    style: AppTextStyles.titleMedium().copyWith(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // Check indicator
            Positioned(
              top: 12,
              right: 12,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.slate300,
                    width: 1,
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
            ),
          ],
        ),
      ),
    );
  }
}
