import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Common text field widget with label, hint, and focus styling.
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelLarge(color: AppColors.slate600),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: _isFocused ? AppColors.primary : AppColors.slate200,
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            style: AppTextStyles.bodyLarge(),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.bodyLarge(color: AppColors.slate400),
              suffixIcon: widget.suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              constraints: BoxConstraints(
                minHeight: widget.maxLines > 1 ? 100 : 56,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
