import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Primary button widget with customizable text, icon, and width.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isFullWidth = true,
    this.leadingIcon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      height: 56,
      decoration: BoxDecoration(
        color: onPressed != null ? AppColors.primary : AppColors.slate400,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: onPressed != null ? [AppShadows.primaryShadow] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (leadingIcon != null) ...[
                        Icon(
                          leadingIcon,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: AppTextStyles.bodyLarge(color: Colors.white)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
