import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';

/// Voice selection screen for choosing AI tutor voice.
/// Original: choose_ai_voice
class ChooseVoiceScreen extends StatefulWidget {
  const ChooseVoiceScreen({super.key});

  @override
  State<ChooseVoiceScreen> createState() => _ChooseVoiceScreenState();
}

class _ChooseVoiceScreenState extends State<ChooseVoiceScreen> {
  // Default selection: First voice (Female - Friendly)
  int? _selectedIndex = 0;

  final List<String> _voices = [
    'Female - Friendly & Energetic',
    'Male - Calm & Professional',
    'Female - Warm & Direct',
    'Male - Clear & Encouraging',
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
                      'Step 6 of 8',
                      style: AppTextStyles.titleMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Segment progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: List.generate(8, (index) {
                  final isActive = index < 6;
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin: EdgeInsets.only(right: index < 7 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.slate100,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Text(
                'Choose AI Voice',
                style: AppTextStyles.displayHero().copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Text(
                'Select the voice style that best fits your learning preference.',
                style: AppTextStyles.bodyMedium(color: AppColors.slate500),
                textAlign: TextAlign.center,
              ),
            ),

            // Voice list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _voices.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _VoiceCard(
                      title: _voices[index],
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      onPlaySample: () {
                        // TODO: Play voice sample
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                border: Border(
                  top: BorderSide(color: AppColors.slate100),
                ),
              ),
              child: PrimaryButton(
                text: 'Select & Continue',
                leadingIcon: Icons.arrow_forward,
                onPressed: _selectedIndex != null
                    ? () {
                        Navigator.pushNamed(
                          context,
                          '/onboarding/personal-details',
                        );
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

class _VoiceCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onPlaySample;

  const _VoiceCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.onPlaySample,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.slate200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [AppShadows.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMedium().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: AppColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onPlaySample,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.slate100.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.slate200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      size: 18,
                      color: AppColors.slate700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Play Sample',
                      style: AppTextStyles.bodyMedium(color: AppColors.slate700)
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
