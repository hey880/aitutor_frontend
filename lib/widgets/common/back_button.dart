import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Common back button widget with arrow_back_ios_new icon.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: 24,
        color: color ?? AppColors.textDark,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
