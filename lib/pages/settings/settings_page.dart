import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../constants/app_theme.dart';
import '../../generated/localization/app_localizations.dart';
import '../../store/locale/locale_store.dart';

/// Application settings. Currently exposes the language preference.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const List<_LanguageOption> _options = <_LanguageOption>[
    _LanguageOption(code: 'id'),
    _LanguageOption(code: 'en'),
    _LanguageOption(code: 'ko'),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final localeStore = context.watch<LocaleStore>();

    return CupertinoPageScaffold(
      backgroundColor: palette.surface,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.settingsPageTitle),
        backgroundColor: palette.surface,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.settingsLanguageSection,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.settingsLanguageDescription,
                    style: AppTextStyles.caption.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    decoration: BoxDecoration(
                      color: palette.surfaceRaised,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: palette.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < _options.length;
                          index++
                        ) ...[
                          if (index > 0)
                            Container(height: 1, color: palette.border),
                          _LanguageTile(
                            option: _options[index],
                            isSelected:
                                localeStore.locale.languageCode ==
                                _options[index].code,
                            onSelected: () => localeStore.setLocale(
                              Locale(_options[index].code),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({required this.code});

  final String code;

  String label(AppLocalizations l10n) {
    return switch (code) {
      'id' => l10n.languageIndonesian,
      'en' => l10n.languageEnglish,
      'ko' => l10n.languageKorean,
      _ => code,
    };
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.option,
    required this.isSelected,
    required this.onSelected,
  });

  final _LanguageOption option;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final accent = CupertinoTheme.of(context).primaryColor;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.7,
      onPressed: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.label(l10n),
                style: AppTextStyles.body.copyWith(
                  color: palette.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(CupertinoIcons.check_mark, size: 18, color: accent),
          ],
        ),
      ),
    );
  }
}
