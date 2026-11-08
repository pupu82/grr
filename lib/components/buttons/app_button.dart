import 'package:flutter/cupertino.dart';

import '../../constants/app_theme.dart';

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
    final palette = AppPalette.of(context);
    final accent = CupertinoTheme.of(context).primaryColor;

    final (
      Color background,
      Color foreground,
      Color? border,
    ) = switch (variant) {
      AppButtonVariant.filled => (accent, CupertinoColors.white, null),
      AppButtonVariant.tonal => (accent.withValues(alpha: 0.12), accent, null),
      AppButtonVariant.outline => (
        CupertinoColors.transparent,
        palette.textPrimary,
        palette.border,
      ),
      AppButtonVariant.text => (CupertinoColors.transparent, accent, null),
    };

    var effectiveBackground = background;
    var contentColor = foreground;
    if (!_isEnabled) {
      contentColor = foreground.withValues(alpha: 0.45);
      if (variant == AppButtonVariant.filled) {
        effectiveBackground = background.withValues(alpha: 0.35);
      }
    }

    final content = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CupertinoActivityIndicator(radius: 9, color: contentColor),
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

    final button = CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: _isEnabled ? 0.72 : 1,
      onPressed: _isEnabled ? onPressed : null,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: effectiveBackground,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: border == null
              ? null
              : Border.all(
                  color: _isEnabled ? border : border.withValues(alpha: 0.5),
                ),
        ),
        child: content,
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
