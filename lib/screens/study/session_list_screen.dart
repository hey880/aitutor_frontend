import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../utils/stub_services.dart';
import '../../widgets/common/back_button.dart';

/// Session list screen (Learning Archive).
/// Original: learning_archive_by_session
class SessionListScreen extends StatefulWidget {
  const SessionListScreen({super.key});

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = ['All Sessions', 'Favorites', 'Completed'];

  List<Map<String, dynamic>> get _filteredSessions {
    final sessions = StubServices.sessions;
    switch (_selectedTab) {
      case 1: // Favorites
        return sessions.where((s) => s['isFavorite'] == true).toList();
      case 2: // Completed
        return sessions.where((s) => s['isCompleted'] == true).toList();
      default: // All
        return sessions;
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
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Learning Archive',
                      style: AppTextStyles.titleMedium(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: AppColors.slate600,
                    onPressed: () {
                      // TODO: Open search
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.slate200),
                  ),
                ),
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final isSelected = _selectedTab == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = index),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _tabs[index],
                              style: AppTextStyles.bodySmall(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.slate500,
                              ).copyWith(
                                fontWeight:
                                    isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Session list
            Expanded(
              child: _filteredSessions.isEmpty
                  ? Center(
                      child: Text(
                        'No sessions found',
                        style: AppTextStyles.bodyMedium(color: AppColors.slate400),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // This Week section
                        Text(
                          'This Week',
                          style: AppTextStyles.labelSmall(color: AppColors.slate500)
                              .copyWith(letterSpacing: 1),
                        ),
                        const SizedBox(height: 12),
                        ..._filteredSessions.take(2).map((session) {
                          return _SessionCard(
                            session: session,
                            onPractice: () {
                              Navigator.pushNamed(context, AppRoutes.sessionDetail);
                            },
                          );
                        }),

                        const SizedBox(height: 24),

                        // Last Month section
                        Text(
                          'Last Month',
                          style: AppTextStyles.labelSmall(color: AppColors.slate500)
                              .copyWith(letterSpacing: 1),
                        ),
                        const SizedBox(height: 12),
                        ..._filteredSessions.skip(2).map((session) {
                          return _SessionCard(
                            session: session,
                            onPractice: () {
                              Navigator.pushNamed(context, AppRoutes.sessionDetail);
                            },
                          );
                        }),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Map<String, dynamic> session;
  final VoidCallback onPractice;

  const _SessionCard({
    required this.session,
    required this.onPractice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [AppShadows.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and topic
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(session['date']),
                      style: AppTextStyles.labelSmall(color: AppColors.slate400),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session['topic'] ?? '',
                      style: AppTextStyles.bodyMedium()
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              if (session['isFavorite'] == true)
                Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.amber,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              // Word count
              Row(
                children: [
                  Icon(
                    Icons.menu_book,
                    size: 16,
                    color: AppColors.slate400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${session['wordCount']} words',
                    style: AppTextStyles.bodySmall(color: AppColors.slate500),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Accuracy
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.callGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${session['accuracy']}% accuracy',
                    style: AppTextStyles.bodySmall(color: AppColors.slate500),
                  ),
                ],
              ),

              const Spacer(),

              // Practice button
              GestureDetector(
                onTap: onPractice,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'Practice',
                    style: AppTextStyles.labelLarge(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    // Simple format: "2024-01-15" -> "Jan 15, 2024"
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
