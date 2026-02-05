import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../utils/stub_services.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';

/// Edit schedule screen.
/// Original: personal_information_5 + _6
class EditScheduleScreen extends StatefulWidget {
  const EditScheduleScreen({super.key});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  late List<bool> _selectedDays;
  late List<String> _scheduleTimes;

  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> _dayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(StubServices.selectedDays);
    _scheduleTimes = List.from(StubServices.scheduleTimes);
    // Ensure we have 7 times
    while (_scheduleTimes.length < 7) {
      _scheduleTimes.add('09:30 AM');
    }
  }

  void _toggleDay(int index) {
    setState(() {
      _selectedDays[index] = !_selectedDays[index];
    });
  }

  Future<void> _editTime(int index) async {
    final currentTime = _scheduleTimes[index];
    final parts = currentTime.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1] == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final h = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
        final m = picked.minute.toString().padLeft(2, '0');
        final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        _scheduleTimes[index] = '$h:$m $period';
      });
    }
  }

  void _removeDay(int index) {
    setState(() {
      _selectedDays[index] = false;
    });
  }

  void _save() {
    // TODO: Save schedule
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
                    'Edit Call Schedule',
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
                    // Select Days section
                    Text(
                      'Select Days',
                      style: AppTextStyles.labelLarge(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 16),

                    // Day toggles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        final isSelected = _selectedDays[index];
                        return GestureDetector(
                          onTap: () => _toggleDay(index),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.slate200,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _dayLabels[index],
                                style: AppTextStyles.bodyMedium(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.slate500,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),

                    // Daily Schedule section
                    Text(
                      'Daily Schedule',
                      style: AppTextStyles.labelLarge(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 16),

                    // Schedule cards for selected days
                    ...List.generate(7, (index) {
                      if (!_selectedDays[index]) return const SizedBox.shrink();
                      return _ScheduleCard(
                        dayName: _dayNames[index],
                        time: _scheduleTimes[index],
                        onEdit: () => _editTime(index),
                        onRemove: () => _removeDay(index),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Notification info card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                              Icons.notifications_active,
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
                                  'Call Notifications',
                                  style: AppTextStyles.bodyMedium()
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "You'll receive a notification 5 minutes before each scheduled call.",
                                  style: AppTextStyles.bodySmall(color: AppColors.slate600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    PrimaryButton(
                      text: 'Save Schedule',
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

class _ScheduleCard extends StatelessWidget {
  final String dayName;
  final String time;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _ScheduleCard({
    required this.dayName,
    required this.time,
    required this.onEdit,
    required this.onRemove,
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
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 80,
            child: Text(
              dayName.toUpperCase(),
              style: AppTextStyles.labelLarge(color: AppColors.primary)
                  .copyWith(letterSpacing: 1),
            ),
          ),

          // Time
          Expanded(
            child: Text(
              time,
              style: AppTextStyles.titleMedium(),
            ),
          ),

          // Edit button
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            iconSize: 20,
            color: AppColors.slate400,
            onPressed: onEdit,
          ),

          // Remove button
          IconButton(
            icon: const Icon(Icons.close),
            iconSize: 20,
            color: AppColors.slate400,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
