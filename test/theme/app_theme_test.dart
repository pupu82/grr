import 'package:flutter_test/flutter_test.dart';
import 'package:grr/generated/assets/fonts.gen.dart';
import 'package:grr/theme/app_theme.dart';

void main() {
  group('AppTheme typography', () {
    test('configures Pretendard font family on AppTextStyles tokens', () {
      expect(AppTextStyles.fontFamily, FontFamily.pretendard);
      expect(AppTextStyles.display.fontFamily, FontFamily.pretendard);
      expect(AppTextStyles.title.fontFamily, FontFamily.pretendard);
      expect(AppTextStyles.sectionTitle.fontFamily, FontFamily.pretendard);
      expect(AppTextStyles.body.fontFamily, FontFamily.pretendard);
      expect(AppTextStyles.label.fontFamily, FontFamily.pretendard);
      expect(AppTextStyles.caption.fontFamily, FontFamily.pretendard);
    });

    test('configures Pretendard font family on light and dark ThemeData', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();

      expect(AppTheme.fontFamily, FontFamily.pretendard);
      expect(light.textTheme.bodyMedium?.fontFamily, FontFamily.pretendard);
      expect(dark.textTheme.bodyMedium?.fontFamily, FontFamily.pretendard);
      expect(light.textTheme.titleLarge?.fontFamily, FontFamily.pretendard);
      expect(dark.textTheme.titleLarge?.fontFamily, FontFamily.pretendard);
    });
  });

  group('AppTheme color palette', () {
    test('defines the 5 brand palette swatches correctly', () {
      expect(AppColors.lightTeal.toARGB32(), 0xFFB2E2DF);
      expect(AppColors.softTeal.toARGB32(), 0xFF67C5C1);
      expect(AppColors.teal.toARGB32(), 0xFF1BA4A0);
      expect(AppColors.deepTeal.toARGB32(), 0xFF167F7C);
      expect(AppColors.darkTeal.toARGB32(), 0xFF105F5D);
    });

    test('exposes palette colors on AppPalette light and dark', () {
      const light = AppPalette.light;
      const dark = AppPalette.dark;

      expect(light.accent, AppColors.darkTeal);
      expect(dark.accent, AppColors.softTeal);
      expect(light.lightTeal, AppColors.lightTeal);
      expect(light.softTeal, AppColors.softTeal);
      expect(light.teal, AppColors.teal);
      expect(light.deepTeal, AppColors.deepTeal);
      expect(light.darkTeal, AppColors.darkTeal);
    });
  });
}
