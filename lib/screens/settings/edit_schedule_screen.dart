import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../utils/stub_services.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';
import '../../services/api_service.dart';

/// Edit schedule screen.
/// Original: personal_information_5 + _6
class EditScheduleScreen extends StatefulWidget {
  const EditScheduleScreen({super.key});

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  List<bool> _selectedDays = List.filled(7, false);
  List<String> _scheduleTimes = List.filled(7, '09:30 AM');
  bool _isLoading = true;

  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> _dayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    try {
      final response = await ApiService.get('/users/profile');

      if (response.success && response.data != null) {
        final profile = response.data as Map<String, dynamic>;

        // Parse preferred_days: ["mon", "wed", "fri"]
        final preferredDays = profile['preferred_days'] as List<dynamic>?;
        if (preferredDays != null) {
          final dayMap = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
          for (int i = 0; i < dayMap.length; i++) {
            if (preferredDays.contains(dayMap[i])) {
              _selectedDays[i] = true;
            }
          }
        }

        // Parse preferred_time: "20:30:00"
        final preferredTime = profile['preferred_time'] as String?;
        if (preferredTime != null) {
          final formattedTime = _convert24HourTo12Hour(preferredTime);
          // Set all selected days to use the same time
          for (int i = 0; i < 7; i++) {
            _scheduleTimes[i] = formattedTime;
          }
        }
      }
    } catch (e) {
      print('Error loading schedule: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _convert24HourTo12Hour(String time24) {
    // Input format: "20:30:00" or "20:30"
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    String period = 'AM';
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    }
    if (hour == 0) {
      hour = 12;
    }

    return '$hour:$minute $period';
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

  Future<void> _save() async {
    // Map day indices to backend format
    final dayMap = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    final selectedDayStrings = <String>[];

    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) {
        selectedDayStrings.add(dayMap[i]);
      }
    }

    if (selectedDayStrings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Use the first selected day's time as preferred_time
    // (Backend expects a single preferred_time)
    final firstSelectedDayIndex = _selectedDays.indexWhere((day) => day);
    final timeString = _scheduleTimes[firstSelectedDayIndex];

    // Convert "9:30 AM" to "09:30" (24-hour format)
    final parts = timeString.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = timeParts[1];
    final isPM = parts[1] == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    final time24 = '${hour.toString().padLeft(2, '0')}:$minute';

    // Show loading
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await ApiService.put('/users/profile', {
        'preferred_days': selectedDayStrings,
        'preferred_time': time24,
      });

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (response.success) {
        // Register schedule with notification scheduler
        try {
          await ApiService.post('/notifications/schedule/update', {});
          print('Notification schedule registered successfully');
        } catch (e) {
          print('Failed to register notification schedule: $e');
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Schedule updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Close edit screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update schedule: ${response.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
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

            // Loading indicator
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
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
