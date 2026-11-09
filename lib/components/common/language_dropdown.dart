import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../store/locale/locale_store.dart';
import '../../theme/app_theme.dart';

/// Dropdown selector for switching the application language.
///
/// Includes national flags and supports both dark and light backgrounds.
class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key, this.isDarkBackground = true});

  final bool isDarkBackground;

  @override
  Widget build(BuildContext context) {
    final localeStore = context.watch<LocaleStore?>();
    final currentCode = localeStore?.locale.languageCode ?? 'id';

    const options = <_LangItem>[
      _LangItem(
        code: 'id',
        flag: '🇮🇩',
        name: 'Bahasa Indonesia',
        shortLabel: 'ID',
      ),
      _LangItem(
        code: 'en',
        flag: '🇺🇸',
        name: 'English (US)',
        shortLabel: 'EN',
      ),
      _LangItem(code: 'ko', flag: '🇰🇷', name: '한국어', shortLabel: 'KO'),
    ];

    final currentItem = options.firstWhere(
      (item) => item.code == currentCode,
      orElse: () => options.first,
    );

    final foregroundColor = isDarkBackground
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;
    final backgroundColor = isDarkBackground
        ? Colors.white.withValues(alpha: 0.16)
        : Theme.of(context).colorScheme.surfaceContainerHighest;

    return PopupMenuButton<String>(
      tooltip: 'Pilih bahasa / Language',
      initialValue: currentCode,
      onSelected: (code) {
        localeStore?.setLocale(Locale(code));
      },
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDarkBackground
                ? Colors.white.withValues(alpha: 0.28)
                : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentItem.flag, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 6),
            Text(
              currentItem.shortLabel,
              style: AppTextStyles.label.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: foregroundColor.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        return options.map((item) {
          final isSelected = item.code == currentCode;
          return PopupMenuItem<String>(
            value: item.code,
            child: Row(
              children: [
                Text(item.flag, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

class _LangItem {
  const _LangItem({
    required this.code,
    required this.flag,
    required this.name,
    required this.shortLabel,
  });

  final String code;
  final String flag;
  final String name;
  final String shortLabel;
}
