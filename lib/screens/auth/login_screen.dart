import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../services/api_service.dart';
import '../../utils/stub_services.dart';

/// Login screen with Google and Kakao login options.
/// Original: home_dashboard_2
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  /// Handle OAuth login flow:
  /// 1. Get OAuth credentials (mock for now, real OAuth SDK later)
  /// 2. Try to login - if user exists, go to home
  /// 3. If user doesn't exist (404), save OAuth data and go to onboarding
  Future<void> _handleOAuthLogin(BuildContext context, String provider) async {
    // TODO: Replace with real OAuth SDK (google_sign_in, kakao_flutter_sdk)
    // For now, use mock OAuth credentials
    final mockOAuthData = _getMockOAuthData(provider);

    // Try to login first (check if user exists)
    final loginResponse = await ApiService.login(
      provider: provider,
      oauthId: mockOAuthData['oauth_id']!,
      idToken: mockOAuthData['id_token']!,
    );

    if (!context.mounted) return;

    if (loginResponse.success) {
      // User exists - go to home
      await StubServices.setLoggedIn(true);
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else if (loginResponse.statusCode == 404) {
      // User doesn't exist - save OAuth data and go to onboarding
      await ApiService.savePendingOAuthData(
        provider: provider,
        oauthId: mockOAuthData['oauth_id']!,
        idToken: mockOAuthData['id_token']!,
        name: mockOAuthData['name']!,
        email: mockOAuthData['email']!,
      );
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding/proficiency-level');
      }
    } else {
      // Network error or other error - show message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loginResponse.message ?? 'Login failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Mock OAuth data - replace with real OAuth SDK later
  Map<String, String> _getMockOAuthData(String provider) {
    return {
      'oauth_id': '${provider}_user_12345',
      'id_token': 'mock_id_token_${provider}_${DateTime.now().millisecondsSinceEpoch}',
      'name': 'Test User',
      'email': 'test@example.com',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              // Header with logo
              Padding(
                padding: const EdgeInsets.only(top: 64, bottom: 48),
                child: Column(
                  children: [
                    // Logo icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.translate,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'LingoDash',
                      style: AppTextStyles.titleLarge(),
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
                      // Hero text
                      Text(
                        'Master English with your AI Tutor',
                        style: AppTextStyles.displayHero(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Join thousands of learners and start speaking fluently today.',
                        style: AppTextStyles.bodyMedium(color: AppColors.slate500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Login buttons
                      _GoogleLoginButton(
                        onPressed: () => _handleOAuthLogin(context, 'google'),
                      ),
                      const SizedBox(height: 16),
                      _KakaoLoginButton(
                        onPressed: () => _handleOAuthLogin(context, 'kakao'),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 48, left: 32, right: 32),
                child: Column(
                  children: [
                    Text(
                      'By continuing, you agree to our terms and acknowledge you\'ve read our policies.',
                      style: AppTextStyles.labelSmall(color: AppColors.slate400)
                          .copyWith(letterSpacing: 0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // TODO: Open Terms of Service
                          },
                          child: Text(
                            'Terms of Service',
                            style: AppTextStyles.labelLarge(
                              color: AppColors.slate500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.slate200,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Open Privacy Policy
                          },
                          child: Text(
                            'Privacy Policy',
                            style: AppTextStyles.labelLarge(
                              color: AppColors.slate500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Google login button with 4-color G icon.
class _GoogleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoogleLoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.slate200),
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google 4-color G icon using CustomPaint
              SizedBox(
                width: 20,
                height: 20,
                child: CustomPaint(
                  painter: _GoogleLogoPainter(),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Continue with Google',
                style: AppTextStyles.bodyLarge(color: AppColors.slate700)
                    .copyWith(fontWeight: FontWeight.w600),
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

    // Blue (right arc)
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    // Green (bottom arc)
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;

    // Yellow (top-left arc)
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;

    // Red (top arc)
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;

    // Draw simplified G shape
    final path = Path();

    // Blue part - right side
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

    // Overlay colors for G sections
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

/// Kakao login button with chat bubble icon.
class _KakaoLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _KakaoLoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kakaoBg,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble,
                size: 20,
                color: AppColors.kakaoText,
              ),
              const SizedBox(width: 12),
              Text(
                'Continue with Kakao',
                style: AppTextStyles.bodyLarge(color: AppColors.kakaoText)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
