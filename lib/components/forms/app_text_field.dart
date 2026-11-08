import 'package:flutter/cupertino.dart';

import '../../constants/app_theme.dart';

/// Business-agnostic text input that follows the Gauge R&R design system.
///
/// Validation state is supplied by the caller through [errorText]; the widget
/// itself never performs business validation.
class AppTextField extends StatefulWidget {
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
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_isFocused == _focusNode.hasFocus) {
      return;
    }
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final accent = CupertinoTheme.of(context).primaryColor;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    final borderColor = !widget.enabled
        ? palette.border.withValues(alpha: 0.6)
        : hasError
        ? palette.danger
        : _isFocused
        ? accent
        : palette.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.label.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        CupertinoTextField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          autofillHints: widget.autofillHints,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          cursorColor: accent,
          style: AppTextStyles.body.copyWith(color: palette.textPrimary),
          placeholder: widget.placeholder,
          placeholderStyle: AppTextStyles.body.copyWith(
            color: palette.textSecondary.withValues(alpha: 0.8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          prefix: widget.prefixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md),
                  child: Icon(
                    widget.prefixIcon,
                    size: 18,
                    color: palette.textSecondary,
                  ),
                ),
          suffix: widget.suffix,
          decoration: BoxDecoration(
            color: widget.enabled ? palette.surfaceRaised : palette.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: borderColor, width: _isFocused ? 1.6 : 1),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText!,
            style: AppTextStyles.caption.copyWith(color: palette.danger),
          ),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.helperText!,
            style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
          ),
        ],
      ],
    );
  }
}
