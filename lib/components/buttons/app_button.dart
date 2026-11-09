import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Visual emphasis of an [AppButton].
enum AppButtonVariant {
  /// Primary action with a solid accent background.
  filled,

  /// Secondary action with a tinted accent background.
  tonal,

  /// Secondary action with a neutral border.
  outline,

  /// Low-emphasis action without a background.
  text,
}

/// Business-agnostic button that follows the Gauge R&R design system.
///
/// While [isLoading] is `true` the button is not tappable, which prevents
/// accidental duplicate submissions.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.isLoading = false,
    this.expand = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool expand;
  final IconData? icon;

  bool get _isEnabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contentColor = _isEnabled
        ? switch (variant) {
            AppButtonVariant.filled => colorScheme.onPrimary,
            _ => colorScheme.primary,
          }
        : colorScheme.onSurface.withValues(alpha: 0.38);

    final content = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(contentColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: contentColor),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: contentColor,
                  ),
                ),
              ),
            ],
          );

    final VoidCallback? handler = _isEnabled ? onPressed : null;

    final button = switch (variant) {
      AppButtonVariant.filled => FilledButton(
        onPressed: handler,
        child: content,
      ),
      AppButtonVariant.tonal => FilledButton.tonal(
        onPressed: handler,
        child: content,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: handler,
        child: content,
      ),
      AppButtonVariant.text => TextButton(onPressed: handler, child: content),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
