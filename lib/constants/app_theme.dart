import 'package:flutter/cupertino.dart';

/// Raw color values for the Gauge R&R design system.
///
/// Widgets should use [AppPalette] tokens instead of referencing these
/// constants directly, so light and dark surfaces stay consistent.
abstract final class AppColors {
  static const Color accent = Color(0xFF2F6BFF);

  static const Color success = Color(0xFF1F9D55);
  static const Color warning = Color(0xFFB7791F);
  static const Color danger = Color(0xFFD64545);

  static const Color lightSurface = Color(0xFFF6F7F9);
  static const Color lightSurfaceRaised = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE1E5EB);
  static const Color lightTextPrimary = Color(0xFF14181F);
  static const Color lightTextSecondary = Color(0xFF5C6573);

  static const Color darkSurface = Color(0xFF11141A);
  static const Color darkSurfaceRaised = Color(0xFF181C23);
  static const Color darkBorder = Color(0xFF262C36);
  static const Color darkTextPrimary = Color(0xFFF2F4F7);
  static const Color darkTextSecondary = Color(0xFF9AA4B2);
}

/// Semantic color tokens resolved for the current brightness.
@immutable
class AppPalette {
  const AppPalette({
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.success,
    required this.warning,
    required this.danger,
  });

  static const AppPalette light = AppPalette(
    surface: AppColors.lightSurface,
    surfaceRaised: AppColors.lightSurfaceRaised,
    border: AppColors.lightBorder,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    accent: AppColors.accent,
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
  );

  static const AppPalette dark = AppPalette(
    surface: AppColors.darkSurface,
    surfaceRaised: AppColors.darkSurfaceRaised,
    border: AppColors.darkBorder,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    accent: AppColors.accent,
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
  );

  /// Resolves the palette that matches the active [CupertinoTheme].
  static AppPalette of(BuildContext context) {
    return CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? dark
        : light;
  }

  final Color surface;
  final Color surfaceRaised;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final Color success;
  final Color warning;
  final Color danger;
}

/// Spacing scale used for padding, gaps, and layout rhythm.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Corner radius scale.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

/// Typography tokens. Colors are applied by widgets from [AppPalette].
abstract final class AppTextStyles {
  static const TextStyle display = TextStyle(
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    height: 1.35,
    fontWeight: FontWeight.w400,
  );
}

/// Application-wide Cupertino theme configuration.
abstract final class AppTheme {
  static CupertinoThemeData light() => _build(Brightness.light);

  static CupertinoThemeData dark() => _build(Brightness.dark);

  static CupertinoThemeData _build(Brightness brightness) {
    final palette = brightness == Brightness.dark
        ? AppPalette.dark
        : AppPalette.light;

    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: palette.accent,
      primaryContrastingColor: CupertinoColors.white,
      scaffoldBackgroundColor: palette.surface,
      barBackgroundColor: palette.surfaceRaised,
      selectionHandleColor: palette.accent,
      textTheme: CupertinoTextThemeData(
        primaryColor: palette.accent,
        textStyle: AppTextStyles.body.copyWith(color: palette.textPrimary),
        navTitleTextStyle: AppTextStyles.sectionTitle.copyWith(
          color: palette.textPrimary,
        ),
        navLargeTitleTextStyle: AppTextStyles.display.copyWith(
          color: palette.textPrimary,
        ),
        navActionTextStyle: AppTextStyles.body.copyWith(
          color: palette.accent,
          fontWeight: FontWeight.w600,
        ),
        actionTextStyle: AppTextStyles.body.copyWith(
          color: palette.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
