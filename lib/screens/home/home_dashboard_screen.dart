import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../widgets/common/bottom_nav_bar.dart';

/// Home dashboard screen - main app entry point.
/// Original: home_dashboard_1
class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentNavIndex = 1; // Call tab selected by default
  int _selectedTutoringType = 0; // 0 = English to Korean, 1 = Korean to English

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // Handle tab navigation
    switch (index) {
      case 0: // Schedule - stay on home
        break;
      case 1: // Call - navigate to incoming call
        Navigator.pushNamed(context, AppRoutes.incomingCall);
        break;
      case 2: // Study - navigate to session list
        Navigator.pushNamed(context, AppRoutes.sessionList);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Alex name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        'Alex',
                        style: AppTextStyles.titleLarge().copyWith(
                          fontSize: 28,
                        ),
                      ),
                    ),

                    // Tutoring Type section
                    _buildTutoringTypeSection(),

                    // Stats cards
                    _buildStatsSection(),

                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.translate,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'LingoDash',
            style: AppTextStyles.titleMedium().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const Spacer(),

          // Premium badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB), // amber-50
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: const Color(0xFFFEF3C7)), // amber-100
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  size: 14,
                  color: Color(0xFFD97706), // amber-600
                ),
                const SizedBox(width: 4),
                Text(
                  'PREMIUM',
                  style: AppTextStyles.labelSmall(
                    color: const Color(0xFFB45309), // amber-700
                  ).copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Calendar button
          _HeaderIconButton(
            icon: Icons.calendar_today,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.editSchedule);
            },
          ),
          const SizedBox(width: 8),

          // Person button (Settings)
          _HeaderIconButton(
            icon: Icons.person,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTutoringTypeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TUTORING TYPE',
            style: AppTextStyles.labelSmall(
              color: AppColors.slate500,
            ).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // English to Korean
          _TutoringTypeItem(
            icon: Icons.menu_book,
            iconBgColor: const Color(0xFFEEF2FF), // indigo-50
            iconColor: const Color(0xFF4F46E5), // indigo-600
            title: 'English to Korean',
            isSelected: _selectedTutoringType == 0,
            onTap: () {
              setState(() {
                _selectedTutoringType = 0;
              });
            },
          ),
          const SizedBox(height: 12),

          // Korean to English
          _TutoringTypeItem(
            icon: Icons.chat,
            iconBgColor: const Color(0xFFECFDF5), // emerald-50
            iconColor: const Color(0xFF059669), // emerald-600
            title: 'Korean to English',
            isSelected: _selectedTutoringType == 1,
            onTap: () {
              setState(() {
                _selectedTutoringType = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Streak card
          Expanded(
            child: _StatCard(
              label: 'STREAK',
              value: '5 Days',
              icon: Icons.local_fire_department,
              iconColor: Colors.orange,
            ),
          ),
          const SizedBox(width: 16),

          // Words Today card
          Expanded(
            child: _StatCard(
              label: 'WORDS TODAY',
              value: '450',
              icon: Icons.chat_bubble,
              iconColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.slate100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.slate600,
        ),
      ),
    );
  }
}

class _TutoringTypeItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TutoringTypeItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isSelected ? AppColors.primary : AppColors.slate300,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate100.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall(
              color: AppColors.slate400,
            ).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: AppTextStyles.titleMedium().copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
