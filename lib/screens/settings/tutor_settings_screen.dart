import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../utils/stub_services.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';

/// Tutor settings screen.
/// Original: personal_information_1
class TutorSettingsScreen extends StatefulWidget {
  const TutorSettingsScreen({super.key});

  @override
  State<TutorSettingsScreen> createState() => _TutorSettingsScreenState();
}

class _TutorSettingsScreenState extends State<TutorSettingsScreen> {
  late TextEditingController _tutorNameController;
  int _selectedVoice = 0;
  double _speakingSpeed = 50;

  final List<Map<String, String>> _voices = [
    {'name': 'Bella', 'style': 'Warm & Friendly'},
    {'name': 'Marcus', 'style': 'Calm & Professional'},
    {'name': 'Olivia', 'style': 'Energetic & Clear'},
    {'name': 'James', 'style': 'Deep & Reassuring'},
  ];

  @override
  void initState() {
    super.initState();
    _tutorNameController = TextEditingController(text: StubServices.tutorName);
  }

  @override
  void dispose() {
    _tutorNameController.dispose();
    super.dispose();
  }

  String get _speedLabel {
    if (_speakingSpeed < 33) return 'Slow';
    if (_speakingSpeed > 66) return 'Fast';
    return 'Normal';
  }

  void _save() {
    // TODO: Save tutor settings
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
              child: Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 8),
                  Text(
                    'Tutor Settings',
                    style: AppTextStyles.titleMedium(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Tutor Avatar with edit badge
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.smart_toy,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Tutor Name
                    Text(
                      'Tutor Name',
                      style: AppTextStyles.labelLarge(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(color: AppColors.slate200),
                      ),
                      child: TextField(
                        controller: _tutorNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter tutor name',
                          hintStyle: AppTextStyles.bodyMedium(color: AppColors.slate400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: AppTextStyles.bodyMedium(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Voice Personality section
                    Row(
                      children: [
                        Text(
                          'Voice Personality',
                          style: AppTextStyles.labelLarge(color: AppColors.slate600),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.callGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            'HD Natural',
                            style: AppTextStyles.labelSmall(color: AppColors.callGreen)
                                .copyWith(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 2x2 Voice cards grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: _voices.length,
                      itemBuilder: (context, index) {
                        final voice = _voices[index];
                        final isSelected = _selectedVoice == index;
                        return _VoiceCard(
                          name: voice['name']!,
                          style: voice['style']!,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedVoice = index),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Speech Settings
                    Text(
                      'Speech Settings',
                      style: AppTextStyles.labelLarge(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 16),

                    // Speaking Speed slider
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        boxShadow: [AppShadows.cardShadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Speaking Speed',
                                style: AppTextStyles.bodyMedium()
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                ),
                                child: Text(
                                  _speedLabel,
                                  style: AppTextStyles.labelLarge(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.slate200,
                              thumbColor: AppColors.primary,
                              overlayColor: AppColors.primary.withValues(alpha: 0.1),
                              trackHeight: 6,
                            ),
                            child: Slider(
                              value: _speakingSpeed,
                              min: 0,
                              max: 100,
                              onChanged: (value) {
                                setState(() => _speakingSpeed = value);
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Slow',
                                style: AppTextStyles.labelSmall(color: AppColors.slate400),
                              ),
                              Text(
                                'Fast',
                                style: AppTextStyles.labelSmall(color: AppColors.slate400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    PrimaryButton(
                      text: 'Save Changes',
                      onPressed: _save,
                    ),
                    const SizedBox(height: 24),
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

class _VoiceCard extends StatelessWidget {
  final String name;
  final String style;
  final bool isSelected;
  final VoidCallback onTap;

  const _VoiceCard({
    required this.name,
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.slate200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Play button
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.slate100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.slate500,
                  ),
                ),
                const Spacer(),
                // Radio indicator
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.slate300,
                      width: 2,
                    ),
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
              ],
            ),
            const Spacer(),
            Text(
              name,
              style: AppTextStyles.bodyMedium().copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              style,
              style: AppTextStyles.labelSmall(color: AppColors.slate400)
                  .copyWith(letterSpacing: 0),
            ),
          ],
        ),
      ),
    );
  }
}
