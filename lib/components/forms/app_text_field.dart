import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Business-agnostic text input that follows the Gauge R&R design system.
///
/// Validation state is supplied by the caller through [errorText]; the widget
/// itself never performs business validation.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.autofillHints,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final String? helperText;

  /// When non-empty the field renders its error style.
  final String? errorText;

  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      autofillHints: autofillHints,
      maxLines: obscureText ? 1 : maxLines,
      style: AppTextStyles.body.copyWith(color: palette.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20),
        suffixIcon: suffix,
      ),
    );
  }
}
