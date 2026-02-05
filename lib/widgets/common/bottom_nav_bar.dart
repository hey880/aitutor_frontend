import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';

/// Bottom navigation bar widget with 3 or 4 tabs.
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final bool showSettings;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.showSettings = false,
  });

  void _defaultOnTap(BuildContext context, int index) {
    final routes = [
      AppRoutes.home,        // Schedule/Home (0)
      AppRoutes.incomingCall, // Call (1)
      AppRoutes.sessionList,  // Study (2)
      if (showSettings) AppRoutes.settings, // Settings (3)
    ];
    if (index < routes.length && index != currentIndex) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _NavItem(icon: Icons.calendar_month, label: 'Schedule'),
      _NavItem(icon: Icons.call, label: 'Call'),
      _NavItem(icon: Icons.menu_book, label: 'Study'),
      if (showSettings) _NavItem(icon: Icons.settings, label: 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        border: const Border(
          top: BorderSide(
            color: AppColors.slate200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (index) {
              final isActive = index == currentIndex;
              final tab = tabs[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap != null ? onTap!(index) : _defaultOnTap(context, index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Icon(
                          tab.icon,
                          size: 24,
                          color:
                              isActive ? AppColors.primary : AppColors.slate400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tab.label,
                        style: AppTextStyles.labelSmall(
                          color:
                              isActive ? AppColors.primary : AppColors.slate400,
                        ).copyWith(
                          letterSpacing: 0,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}
