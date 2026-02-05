import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../utils/stub_services.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';

/// Learning activity screen with calendar heatmap.
/// Original: personal_information_4
class LearningActivityScreen extends StatefulWidget {
  const LearningActivityScreen({super.key});

  @override
  State<LearningActivityScreen> createState() => _LearningActivityScreenState();
}

class _LearningActivityScreenState extends State<LearningActivityScreen> {
  int _currentMonth = 10; // October
  int _currentYear = 2023;
  final int _currentDay = 6;

  final List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  void _previousMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
    });
  }

  Color _getHeatmapColor(int wordCount) {
    if (wordCount == 0) return AppColors.levelColors[0];
    if (wordCount < 200) return AppColors.levelColors[1];
    if (wordCount < 400) return AppColors.levelColors[2];
    if (wordCount < 600) return AppColors.levelColors[3];
    return AppColors.levelColors[4];
  }

  @override
  Widget build(BuildContext context) {
    final dailyWords = StubServices.dailyWordCount;

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
                  Text(
                    'Learning Activity',
                    style: AppTextStyles.titleMedium(),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    color: AppColors.slate600,
                    onPressed: () {
                      // TODO: Share
                    },
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
                    // Stat cards row
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            value: '12,482',
                            label: 'Total Words',
                            icon: Icons.abc,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            value: '416',
                            label: 'Avg Per Day',
                            icon: Icons.trending_up,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            value: '42h 15m',
                            label: 'Total Time',
                            icon: Icons.schedule,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Month selector
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        boxShadow: [AppShadows.cardShadow],
                      ),
                      child: Column(
                        children: [
                          // Month navigation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                color: AppColors.slate600,
                                onPressed: _previousMonth,
                              ),
                              Text(
                                '${_monthNames[_currentMonth - 1]} $_currentYear',
                                style: AppTextStyles.titleMedium(),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                color: AppColors.slate600,
                                onPressed: _nextMonth,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Day headers
                          Row(
                            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                .map((day) => Expanded(
                                      child: Center(
                                        child: Text(
                                          day,
                                          style: AppTextStyles.labelSmall(
                                            color: AppColors.slate400,
                                          ).copyWith(fontSize: 10),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 8),

                          // Calendar grid
                          _buildCalendarGrid(dailyWords),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Activity Level legend
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        boxShadow: [AppShadows.cardShadow],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Less',
                            style: AppTextStyles.labelSmall(color: AppColors.slate400),
                          ),
                          const SizedBox(width: 8),
                          ...AppColors.levelColors.map((color) => Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              )),
                          const SizedBox(width: 8),
                          Text(
                            'More',
                            style: AppTextStyles.labelSmall(color: AppColors.slate400),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Insights card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: const Icon(
                              Icons.insights,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weekly Insights',
                                  style: AppTextStyles.bodyMedium()
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "You've spoken 15% more words this week compared to last week. Keep up the great work!",
                                  style: AppTextStyles.bodySmall(color: AppColors.slate600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Detailed Report button
                    PrimaryButton(
                      text: 'Detailed Report',
                      onPressed: () {
                        // TODO: Navigate to detailed report
                      },
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

  Widget _buildCalendarGrid(Map<int, int> dailyWords) {
    // Calculate first day of month (0 = Monday for our grid)
    final firstDayOfMonth = DateTime(_currentYear, _currentMonth, 1);
    final daysInMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    int startWeekday = firstDayOfMonth.weekday - 1; // 0-indexed Monday

    final cells = <Widget>[];

    // Empty cells for days before the 1st
    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox());
    }

    // Day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final wordCount = dailyWords[day] ?? 0;
      final isCurrentDay = day == _currentDay;

      cells.add(_CalendarCell(
        day: day,
        wordCount: wordCount,
        color: _getHeatmapColor(wordCount),
        isCurrentDay: isCurrentDay,
      ));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: cells,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [AppShadows.cardShadow],
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleMedium().copyWith(fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall(color: AppColors.slate400)
                .copyWith(fontSize: 9, letterSpacing: 0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  final int day;
  final int wordCount;
  final Color color;
  final bool isCurrentDay;

  const _CalendarCell({
    required this.day,
    required this.wordCount,
    required this.color,
    required this.isCurrentDay,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: isCurrentDay
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: AppTextStyles.labelSmall(
                color: wordCount > 400 ? Colors.white : AppColors.slate600,
              ).copyWith(fontSize: 10, letterSpacing: 0),
            ),
            if (wordCount > 0)
              Text(
                '$wordCount',
                style: AppTextStyles.labelSmall(
                  color: wordCount > 400
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppColors.slate400,
                ).copyWith(fontSize: 7, letterSpacing: 0),
              ),
          ],
        ),
      ),
    );
  }
}
