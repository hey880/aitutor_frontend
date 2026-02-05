import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../utils/stub_services.dart';
import '../../widgets/common/bottom_nav_bar.dart';

/// Main settings screen.
/// Original: personal_information_3
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) async {
    await StubServices.setLoggedIn(false);
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
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
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Text(
                'Settings & Support',
                style: AppTextStyles.titleMedium(),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // User info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [AppShadows.cardShadow],
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          StubServices.displayName.substring(0, 1),
                          style: AppTextStyles.titleLarge(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StubServices.displayName,
                            style: AppTextStyles.titleMedium(),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pro Member • Learning English',
                            style: AppTextStyles.bodySmall(color: AppColors.slate500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Menu items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _SettingsItem(
                      icon: Icons.manage_accounts,
                      iconBgColor: AppColors.slate100,
                      iconColor: AppColors.slate600,
                      title: 'Account Settings',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.editProfile);
                      },
                    ),
                    const SizedBox(height: 12),
                    _SettingsItem(
                      icon: Icons.smart_toy,
                      iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                      iconColor: AppColors.primary,
                      title: 'Tutor Settings',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.tutorSettings);
                      },
                    ),
                    const SizedBox(height: 12),
                    _SettingsItem(
                      icon: Icons.insights,
                      iconBgColor: AppColors.callGreen.withValues(alpha: 0.1),
                      iconColor: AppColors.callGreen,
                      title: 'Learning Activity',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.learningActivity);
                      },
                    ),
                    const SizedBox(height: 12),
                    _SettingsItem(
                      icon: Icons.calendar_month,
                      iconBgColor: Colors.amber.withValues(alpha: 0.1),
                      iconColor: Colors.amber.shade700,
                      title: 'Edit Schedule',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.editSchedule);
                      },
                    ),
                    const SizedBox(height: 12),
                    _SettingsItem(
                      icon: Icons.help_center,
                      iconBgColor: AppColors.slate100,
                      iconColor: AppColors.slate600,
                      title: 'Q&A Support',
                      onTap: () {
                        // TODO: Navigate to Q&A
                      },
                    ),
                    const SizedBox(height: 12),
                    _SettingsItem(
                      icon: Icons.verified_user,
                      iconBgColor: AppColors.slate100,
                      iconColor: AppColors.slate600,
                      title: 'Privacy Policy',
                      onTap: () {
                        // TODO: Navigate to privacy policy
                      },
                    ),
                    const SizedBox(height: 24),

                    // Logout button
                    GestureDetector(
                      onTap: () => _logout(context),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          border: Border.all(color: AppColors.callRed.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              size: 20,
                              color: AppColors.callRed,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: AppTextStyles.bodyLarge(color: AppColors.callRed)
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Version
                    Text(
                      'Version 1.4.2 (2024)',
                      style: AppTextStyles.bodySmall(color: AppColors.slate400),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom nav with settings tab
            const BottomNavBar(currentIndex: 3, showSettings: true),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [AppShadows.cardShadow],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium().copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.slate400,
            ),
          ],
        ),
      ),
    );
  }
}
