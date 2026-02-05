import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';

/// Schedule setup screen for selecting practice days and times.
/// Original: schedule_ai_calls
class ScheduleSetupScreen extends StatefulWidget {
  const ScheduleSetupScreen({super.key});

  @override
  State<ScheduleSetupScreen> createState() => _ScheduleSetupScreenState();
}

class _ScheduleSetupScreenState extends State<ScheduleSetupScreen> {
  // Days: M, T, W, T, F, S, S (index 0-6)
  // Default: Monday, Wednesday, Friday selected
  final Set<int> _selectedDays = {0, 2, 4};

  // Schedule times for each day
  final Map<int, _ScheduleTime> _scheduleTimes = {
    0: _ScheduleTime(hour: 8, minute: 30, isPm: true), // Monday 08:30 PM
    2: _ScheduleTime(hour: 7, minute: 45, isPm: true), // Wednesday 07:45 PM
    4: _ScheduleTime(hour: 9, minute: 15, isPm: false), // Friday 09:15 AM
  };

  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> _dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  void _toggleDay(int index) {
    setState(() {
      if (_selectedDays.contains(index)) {
        _selectedDays.remove(index);
        _scheduleTimes.remove(index);
      } else {
        _selectedDays.add(index);
        // Default time for new day
        _scheduleTimes[index] = _ScheduleTime(hour: 9, minute: 0, isPm: true);
      }
    });
  }

  void _removeSchedule(int dayIndex) {
    setState(() {
      _selectedDays.remove(dayIndex);
      _scheduleTimes.remove(dayIndex);
    });
  }

  bool get _isValid => _selectedDays.isNotEmpty;

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
                      'Onboarding',
                      style: AppTextStyles.titleMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AI Tutor Schedule',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textDark,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Step 5 of 8',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: LinearProgressIndicator(
                      value: 0.625,
                      backgroundColor: AppColors.slate100,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                      child: Text(
                        'Set your availability',
                        style: AppTextStyles.displayHero().copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
                      child: Text(
                        'Select the days you want to practice. You can set a different time for each day.',
                        style: AppTextStyles.bodyMedium(color: AppColors.slate500),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Day selector
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REPEAT EVERY:',
                            style: AppTextStyles.labelSmall(
                              color: AppColors.slate600,
                            ).copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (index) {
                              final isSelected = _selectedDays.contains(index);
                              return _DayButton(
                                label: _dayLabels[index],
                                isSelected: isSelected,
                                onTap: () => _toggleDay(index),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Daily schedule cards
                    if (_selectedDays.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DAILY SCHEDULE:',
                              style: AppTextStyles.labelSmall(
                                color: AppColors.slate600,
                              ).copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...(_selectedDays.toList()..sort()).map((dayIndex) {
                              final time = _scheduleTimes[dayIndex]!;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _TimeCard(
                                  dayName: _dayNames[dayIndex],
                                  time: time,
                                  onEdit: () {
                                    // TODO: Show time picker
                                  },
                                  onRemove: () => _removeSchedule(dayIndex),
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                'Scheduled in Pacific Standard Time (GMT-8)',
                                style: AppTextStyles.bodySmall(
                                  color: AppColors.slate400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // DND info card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F7FF),
                          borderRadius: BorderRadius.circular(AppRadius.xxl),
                          border: Border.all(
                            color: const Color(0xFFDBEAFE),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBEAFE),
                                borderRadius: BorderRadius.circular(AppRadius.lg),
                              ),
                              child: const Icon(
                                Icons.notifications_paused,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '"Do Not Disturb" Notice',
                                    style: AppTextStyles.bodyMedium().copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Ensure 'Do Not Disturb' is off or add this app to your 'Allowed' list to receive calls during your sessions.",
                                    style: AppTextStyles.bodySmall(
                                      color: AppColors.slate500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Bottom button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.slate100),
                ),
              ),
              child: PrimaryButton(
                text: 'Set Schedule & Continue',
                leadingIcon: Icons.arrow_forward,
                onPressed: _isValid
                    ? () {
                        Navigator.pushNamed(
                          context,
                          '/onboarding/choose-voice',
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTime {
  final int hour;
  final int minute;
  final bool isPm;

  _ScheduleTime({
    required this.hour,
    required this.minute,
    required this.isPm,
  });

  String get formattedTime {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get period => isPm ? 'PM' : 'AM';
}

class _DayButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.slate100,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.bodyLarge(
              color: isSelected ? Colors.white : AppColors.slate500,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String dayName;
  final _ScheduleTime time;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _TimeCard({
    required this.dayName,
    required this.time,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slate100.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayName.toUpperCase(),
                  style: AppTextStyles.labelSmall(
                    color: AppColors.primary,
                  ).copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      time.formattedTime,
                      style: AppTextStyles.titleLarge().copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time.period,
                      style: AppTextStyles.titleMedium().copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.slate200),
              ),
              child: const Icon(
                Icons.edit_calendar,
                size: 20,
                color: AppColors.slate500,
              ),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.cancel,
              size: 28,
              color: AppColors.slate300,
            ),
          ),
        ],
      ),
    );
  }
}
