import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/onboarding_header.dart';
import '../../widgets/common/primary_button.dart';
import '../../services/audio_player_service.dart';
import '../../services/api_service.dart';

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
  bool _isPlayingSample = false;
  int? _playingIndex;

  final AudioPlayerService _audioPlayer = AudioPlayerService();

  final List<Map<String, String>> _voices = [
    {
      'id': 'female_friendly',
      'name': 'Female - Friendly & Energetic',
    },
    {
      'id': 'male_calm',
      'name': 'Male - Calm & Professional',
    },
    {
      'id': 'female_warm',
      'name': 'Female - Warm & Direct',
    },
    {
      'id': 'male_clear',
      'name': 'Male - Clear & Encouraging',
    },
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSample(int index) async {
    setState(() {
      _isPlayingSample = true;
      _playingIndex = index;
    });

    try {
      // Add timeout to prevent indefinite waiting
      final response = await ApiService.post('/tts/sample', {
        'voice_preset': _voices[index]['id'],
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.success && mounted) {
        final audioBase64 = response.data['audio_base64'] as String?;

        // Check for empty audio data (Azure Speech not configured)
        if (audioBase64 == null || audioBase64.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Voice preview is not available in demo mode'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          await _audioPlayer.playFromBase64(audioBase64);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load voice sample: ${response.message ?? "Unknown error"}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } on TimeoutException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request timed out. Please check your connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error playing sample: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPlayingSample = false;
          _playingIndex = null;
        });
      }
    }
  }

  Future<void> _saveAndContinue() async {
    if (_selectedIndex == null) return;

    // Save voice selection temporarily to SharedPreferences
    // It will be applied to the user account after registration
    await ApiService.saveOnboardingVoice(_voices[_selectedIndex!]['id']!);

    // Navigate to next screen immediately (no API call needed)
    if (!mounted) return;
    Navigator.pushNamed(context, '/onboarding/personal-details');
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
              currentStep: 6,
              totalSteps: 8,
              stepTitle: 'Choose AI Voice',
              showNextButton: _selectedIndex != null,
              onNext: _selectedIndex != null ? _saveAndContinue : null,
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
                      title: _voices[index]['name']!,
                      isSelected: isSelected,
                      isPlaying: _playingIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      onPlaySample: () => _playSample(index),
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
                onPressed: _selectedIndex != null ? _saveAndContinue : null,
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
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onPlaySample;

  const _VoiceCard({
    required this.title,
    required this.isSelected,
    this.isPlaying = false,
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
              onTap: isPlaying ? null : onPlaySample,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isPlaying
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.slate100.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isPlaying ? AppColors.primary : AppColors.slate200,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPlaying)
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      )
                    else
                      Icon(
                        Icons.play_circle_outline,
                        size: 18,
                        color: AppColors.slate700,
                      ),
                    const SizedBox(width: 8),
                    Text(
                      isPlaying ? 'Playing...' : 'Play Sample',
                      style: AppTextStyles.bodyMedium(
                        color: isPlaying ? AppColors.primary : AppColors.slate700,
                      ).copyWith(fontWeight: FontWeight.w500),
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
