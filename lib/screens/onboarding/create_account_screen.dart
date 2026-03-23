import 'dart:convert';
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../services/api_service.dart';
import '../../utils/stub_services.dart';
import '../../widgets/common/onboarding_header.dart';

/// Create account screen - final onboarding step.
/// Original: create_account
class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  /// Convert onboarding schedule format to backend API format
  Map<String, dynamic> _convertScheduleForBackend(Map<String, dynamic> scheduleData) {
    final List<dynamic> dayIndices = scheduleData['days'] ?? [];
    final Map<String, dynamic> times = scheduleData['times'] ?? {};

    // Convert day indices to day strings
    const dayNames = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    final preferredDays = dayIndices
        .map((index) => dayNames[index as int])
        .toList();

    // Use the first day's time as the preferred time (simplified approach)
    String? preferredTime;
    if (dayIndices.isNotEmpty && times.isNotEmpty) {
      final firstDayIndex = dayIndices[0].toString();
      final timeData = times[firstDayIndex];
      if (timeData != null) {
        final hour = timeData['hour'] as int;
        final minute = timeData['minute'] as int;
        final isPm = timeData['isPm'] as bool;

        // Convert 12-hour format to 24-hour format
        int hour24;
        if (isPm && hour != 12) {
          hour24 = hour + 12;
        } else if (!isPm && hour == 12) {
          hour24 = 0;
        } else {
          hour24 = hour;
        }

        preferredTime = '${hour24.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
      }
    }

    return {
      'preferred_days': preferredDays,
      'preferred_time': preferredTime,
    };
  }

  /// Complete registration with the saved OAuth data and selected level.
  Future<void> _completeRegistration(BuildContext context) async {
    // Get saved OAuth data and level from onboarding
    final oauthData = await ApiService.getPendingOAuthData();
    final level = await ApiService.getOnboardingLevel();

    if (oauthData == null) {
      // No OAuth data - show error (shouldn't happen in normal flow)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
      return;
    }

    // Call register API
    final response = await ApiService.register(
      provider: oauthData['provider'],
      oauthId: oauthData['oauth_id'],
      idToken: oauthData['id_token'],
      name: oauthData['name'],
      email: oauthData['email'],
      level: level ?? 'intermediate', // Default to intermediate if not set
    );

    if (!context.mounted) return;

    if (response.success) {
      // Registration successful - now apply saved voice settings
      final savedVoice = await ApiService.getOnboardingVoice();
      if (savedVoice != null) {
        try {
          // JWT token is now available, so we can call the voice-settings API
          await ApiService.patch('/users/voice-settings', {
            'voice_preset': savedVoice,
          });
          // Clear the temporary voice data
          await ApiService.clearOnboardingVoice();
        } catch (e) {
          // If voice settings fail, don't block the user flow
          // They can change it later in Settings
          print('Failed to apply voice settings: $e');
        }
      }

      // Apply saved schedule settings
      final savedSchedule = await ApiService.getOnboardingSchedule();
      if (savedSchedule != null) {
        try {
          final scheduleData = jsonDecode(savedSchedule);
          final convertedSchedule = _convertScheduleForBackend(scheduleData);

          // Update user profile with schedule
          await ApiService.put('/users/profile', convertedSchedule);

          // Register schedule with notification scheduler
          try {
            await ApiService.post('/notifications/schedule/update', {});
            print('Notification schedule registered successfully');
          } catch (e) {
            print('Failed to register notification schedule: $e');
          }

          await ApiService.clearOnboardingSchedule();
          print('Schedule applied successfully');
        } catch (e) {
          print('Failed to apply schedule settings: $e');
        }
      }

      await StubServices.setLoggedIn(true);
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
      }
    } else if (response.statusCode == 409) {
      // User already exists - should not happen if login check was done
      // Try to login instead
      final loginResponse = await ApiService.login(
        provider: oauthData['provider'],
        oauthId: oauthData['oauth_id'],
        idToken: oauthData['id_token'],
      );
      if (loginResponse.success) {
        // Login successful - apply saved settings
        // Apply voice settings
        final savedVoice = await ApiService.getOnboardingVoice();
        if (savedVoice != null) {
          try {
            await ApiService.patch('/users/voice-settings', {
              'voice_preset': savedVoice,
            });
            await ApiService.clearOnboardingVoice();
          } catch (e) {
            print('Failed to apply voice settings: $e');
          }
        }

        // Apply schedule settings
        final savedSchedule = await ApiService.getOnboardingSchedule();
        if (savedSchedule != null) {
          try {
            final scheduleData = jsonDecode(savedSchedule);
            final convertedSchedule = _convertScheduleForBackend(scheduleData);

            await ApiService.put('/users/profile', convertedSchedule);

            // Register schedule with notification scheduler
            try {
              await ApiService.post('/notifications/schedule/update', {});
              print('Notification schedule registered successfully');
            } catch (e) {
              print('Failed to register notification schedule: $e');
            }

            await ApiService.clearOnboardingSchedule();
            print('Schedule applied successfully');
          } catch (e) {
            print('Failed to apply schedule settings: $e');
          }
        }

        await StubServices.setLoggedIn(true);
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResponse.message ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Other error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Registration failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress bar (Final step - 100% complete)
            const OnboardingHeader(
              currentStep: 8,
              totalSteps: 8,
              stepTitle: 'Create Account',
            ),

            // Center content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Large icon with glow
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow effect
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        // Main icon circle
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.graphic_eq,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      "You're all set!",
                      style: AppTextStyles.displayHero().copyWith(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Sign up to start your first call with your AI English tutor.',
                        style: AppTextStyles.bodyLarge(color: AppColors.slate600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Google button
                  Builder(
                    builder: (buttonContext) => _SignUpButton(
                      icon: _buildGoogleIcon(),
                      text: 'Continue with Google',
                      backgroundColor: Colors.white,
                      textColor: AppColors.textDark,
                      borderColor: AppColors.slate200,
                      onPressed: () async {
                        await _completeRegistration(buttonContext);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Kakao button
                  Builder(
                    builder: (buttonContext) => _SignUpButton(
                      icon: const Icon(
                        Icons.chat_bubble,
                        size: 24,
                        color: AppColors.kakaoText,
                      ),
                      text: 'Continue with Kakao',
                      backgroundColor: AppColors.kakaoBg,
                      textColor: AppColors.kakaoText,
                      onPressed: () async {
                        await _completeRegistration(buttonContext);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email sign up link
                  GestureDetector(
                    onTap: () async {
                      // Email sign up - not implemented yet
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email sign up coming soon'),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Sign up with Email',
                        style: AppTextStyles.bodyLarge(color: AppColors.primary)
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Terms text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.bodySmall(color: AppColors.slate500),
                        children: [
                          const TextSpan(
                              text: 'By continuing, you agree to our '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: AppTextStyles.bodySmall(
                              color: AppColors.slate500,
                            ).copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: AppTextStyles.bodySmall(
                              color: AppColors.slate500,
                            ).copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const _SignUpButton({
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : null,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [AppShadows.cardShadow],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                text,
                style: AppTextStyles.bodyLarge(color: textColor).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for Google 4-color G logo.
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;

    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;

    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(w * 0.94, h * 0.51);
    path.lineTo(w * 0.94, h * 0.43);
    path.lineTo(w * 0.5, h * 0.43);
    path.lineTo(w * 0.5, h * 0.57);
    path.lineTo(w * 0.79, h * 0.57);
    path.cubicTo(w * 0.75, h * 0.72, w * 0.64, h * 0.82, w * 0.5, h * 0.82);
    path.cubicTo(w * 0.32, h * 0.82, w * 0.18, h * 0.68, w * 0.18, h * 0.5);
    path.cubicTo(w * 0.18, h * 0.32, w * 0.32, h * 0.18, w * 0.5, h * 0.18);
    path.cubicTo(w * 0.61, h * 0.18, w * 0.71, h * 0.23, w * 0.78, h * 0.32);
    path.lineTo(w * 0.88, h * 0.22);
    path.cubicTo(w * 0.78, h * 0.09, w * 0.64, h * 0.0, w * 0.5, h * 0.0);
    path.cubicTo(w * 0.22, h * 0.0, w * 0.0, h * 0.22, w * 0.0, h * 0.5);
    path.cubicTo(w * 0.0, h * 0.78, w * 0.22, h * 1.0, w * 0.5, h * 1.0);
    path.cubicTo(w * 0.78, h * 1.0, w * 0.96, h * 0.78, w * 0.94, h * 0.51);
    path.close();

    canvas.drawPath(path, bluePaint);

    final greenPath = Path();
    greenPath.moveTo(w * 0.5, h * 0.82);
    greenPath.cubicTo(w * 0.32, h * 0.82, w * 0.18, h * 0.68, w * 0.18, h * 0.5);
    greenPath.lineTo(w * 0.0, h * 0.5);
    greenPath.cubicTo(w * 0.0, h * 0.78, w * 0.22, h * 1.0, w * 0.5, h * 1.0);
    greenPath.close();
    canvas.drawPath(greenPath, greenPaint);

    final yellowPath = Path();
    yellowPath.moveTo(w * 0.18, h * 0.5);
    yellowPath.cubicTo(w * 0.18, h * 0.32, w * 0.32, h * 0.18, w * 0.5, h * 0.18);
    yellowPath.lineTo(w * 0.5, h * 0.0);
    yellowPath.cubicTo(w * 0.22, h * 0.0, w * 0.0, h * 0.22, w * 0.0, h * 0.5);
    yellowPath.close();
    canvas.drawPath(yellowPath, yellowPaint);

    final redPath = Path();
    redPath.moveTo(w * 0.5, h * 0.18);
    redPath.cubicTo(w * 0.61, h * 0.18, w * 0.71, h * 0.23, w * 0.78, h * 0.32);
    redPath.lineTo(w * 0.88, h * 0.22);
    redPath.cubicTo(w * 0.78, h * 0.09, w * 0.64, h * 0.0, w * 0.5, h * 0.0);
    redPath.close();
    canvas.drawPath(redPath, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
