import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../utils/stub_services.dart';

/// Edit profile screen.
/// Original: personal_information_2
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _introController;
  DateTime _selectedDate = DateTime(1995, 1, 1);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: StubServices.displayName);
    _introController = TextEditingController(text: StubServices.selfIntroduction);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _introController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
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
      setState(() => _selectedDate = picked);
    }
  }

  void _save() {
    // TODO: Save profile data
    Navigator.pop(context);
  }

  String get _formattedDate {
    return '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
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
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios, size: 18, color: AppColors.slate600),
                        Text(
                          'Settings',
                          style: AppTextStyles.bodyMedium(color: AppColors.slate600),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Edit Profile',
                      style: AppTextStyles.titleMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: _save,
                    child: Text(
                      'Save',
                      style: AppTextStyles.bodyMedium(color: AppColors.primary)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
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
                    // Display Name
                    Text(
                      'Display Name',
                      style: AppTextStyles.labelLarge(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(color: AppColors.slate200),
                      ),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          hintStyle: AppTextStyles.bodyMedium(color: AppColors.slate400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: AppTextStyles.bodyMedium(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Self-Introduction
                    Text(
                      'Self-Introduction',
                      style: AppTextStyles.labelLarge(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(minHeight: 140),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(color: AppColors.slate200),
                      ),
                      child: TextField(
                        controller: _introController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Tell us about yourself...',
                          hintStyle: AppTextStyles.bodyMedium(color: AppColors.slate400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: AppTextStyles.bodyMedium(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Date of Birth
                    Text(
                      'Date of Birth',
                      style: AppTextStyles.labelLarge(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          border: Border.all(color: AppColors.slate200),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _formattedDate,
                                style: AppTextStyles.bodyMedium(),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: AppColors.slate400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info card
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
                          Icon(
                            Icons.privacy_tip,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your personal information is securely stored and will never be shared with third parties.',
                              style: AppTextStyles.bodySmall(color: AppColors.slate600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Unique Identifier
                    Text(
                      'Unique Identifier',
                      style: AppTextStyles.labelLarge(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SN-9823-4410-XF',
                            style: AppTextStyles.bodyMedium(color: AppColors.slate600)
                                .copyWith(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              // TODO: Copy to clipboard
                            },
                            child: Icon(
                              Icons.copy,
                              size: 18,
                              color: AppColors.slate400,
                            ),
                          ),
                        ],
                      ),
                    ),
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
