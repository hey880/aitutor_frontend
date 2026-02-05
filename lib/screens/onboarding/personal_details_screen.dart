import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../widgets/common/back_button.dart';
import '../../widgets/common/primary_button.dart';

/// Personal details screen for collecting user information.
/// Original: personal_information_9
class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _nicknameController = TextEditingController();
  DateTime _dateOfBirth = DateTime(1995, 1, 1);
  int _selectedGenderIndex = 0; // Default: He/Him

  final List<String> _genderOptions = ['He / Him', 'She / Her', 'Other / They'];

  bool get _isValid => _nameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
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
        _dateOfBirth = picked;
      });
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  AppBackButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Step 7 of 8',
                      style: AppTextStyles.bodyMedium(color: AppColors.slate500)
                          .copyWith(fontWeight: FontWeight.w500),
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
                        'Setup Progress',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.textDark,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '87.5%',
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.primary,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: LinearProgressIndicator(
                      value: 0.875,
                      backgroundColor: AppColors.slate100,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Details',
                    style: AppTextStyles.displayHero().copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us a bit about yourself to help your AI tutor customize your experience.',
                    style: AppTextStyles.bodyMedium(color: AppColors.slate500),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    _FormField(
                      label: 'Full Name',
                      child: _StyledTextField(
                        controller: _nameController,
                        hintText: 'Enter your name',
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nickname
                    _FormField(
                      label: 'How should I address you?',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StyledTextField(
                            controller: _nicknameController,
                            hintText: 'e.g. Alex (AI name preference)',
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              'This is the name your AI tutor will use during conversations.',
                              style:
                                  AppTextStyles.bodySmall(color: AppColors.slate400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date of Birth
                    _FormField(
                      label: 'Date of Birth',
                      child: GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            border: Border.all(color: AppColors.slate200),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_dateOfBirth.year}-${_dateOfBirth.month.toString().padLeft(2, '0')}-${_dateOfBirth.day.toString().padLeft(2, '0')}',
                                  style: AppTextStyles.bodyLarge(),
                                ),
                              ),
                              const Icon(
                                Icons.calendar_month,
                                color: AppColors.slate400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Gender
                    _FormField(
                      label: 'How do you identify?',
                      child: Row(
                        children: List.generate(_genderOptions.length, (index) {
                          final isSelected = _selectedGenderIndex == index;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < _genderOptions.length - 1 ? 12 : 0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedGenderIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withValues(alpha: 0.05)
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.xl),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.slate200,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _genderOptions[index],
                                      style: AppTextStyles.bodyMedium(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.slate600,
                                      ).copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.slate100.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(color: AppColors.slate100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your data helps us customize your learning path and adjust the difficulty based on age-appropriate topics.',
                              style:
                                  AppTextStyles.bodySmall(color: AppColors.slate500),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                text: 'Continue',
                leadingIcon: Icons.arrow_forward,
                onPressed: _isValid
                    ? () {
                        Navigator.pushNamed(
                          context,
                          '/onboarding/self-introduction',
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

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium().copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const _StyledTextField({
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.bodyLarge(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyLarge(color: AppColors.slate400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        constraints: const BoxConstraints(minHeight: 56),
      ),
    );
  }
}
