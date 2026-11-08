import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grr/generated/localization/app_localizations.dart';
import 'package:grr/store/locale/locale_store.dart';

import '../helpers/locale_fakes.dart';

Map<String, String> _values(AppLocalizations l10n) {
  return <String, String>{
    'appTitle': l10n.appTitle,
    'brandSubtitle': l10n.brandSubtitle,
    'actionRetry': l10n.actionRetry,
    'actionOk': l10n.actionOk,
    'loginTitle': l10n.loginTitle,
    'loginSubtitle': l10n.loginSubtitle,
    'employeeCodeLabel': l10n.employeeCodeLabel,
    'employeeCodePlaceholder': l10n.employeeCodePlaceholder,
    'employeeCodeRequired': l10n.employeeCodeRequired,
    'passwordLabel': l10n.passwordLabel,
    'passwordPlaceholder': l10n.passwordPlaceholder,
    'passwordRequired': l10n.passwordRequired,
    'signInAction': l10n.signInAction,
    'noAccountPrompt': l10n.noAccountPrompt,
    'registerAction': l10n.registerAction,
    'viewComponentsAction': l10n.viewComponentsAction,
    'settingsAction': l10n.settingsAction,
    'registerPageTitle': l10n.registerPageTitle,
    'registerHeadline': l10n.registerHeadline,
    'registerSubtitle': l10n.registerSubtitle,
    'fullNameLabel': l10n.fullNameLabel,
    'fullNamePlaceholder': l10n.fullNamePlaceholder,
    'fullNameRequired': l10n.fullNameRequired,
    'emailOptionalLabel': l10n.emailOptionalLabel,
    'emailPlaceholder': l10n.emailPlaceholder,
    'emailInvalid': l10n.emailInvalid,
    'confirmPasswordLabel': l10n.confirmPasswordLabel,
    'confirmPasswordPlaceholder': l10n.confirmPasswordPlaceholder,
    'passwordMismatch': l10n.passwordMismatch,
    'submitRegistrationAction': l10n.submitRegistrationAction,
    'registrationSuccessTitle': l10n.registrationSuccessTitle,
    'registrationSuccessMessage': l10n.registrationSuccessMessage,
    'dashboardWelcome': l10n.dashboardWelcome,
    'dashboardLogout': l10n.dashboardLogout,
    'dashboardSummaryTitle': l10n.dashboardSummaryTitle,
    'dashboardSummaryBody': l10n.dashboardSummaryBody,
    'unknownUser': l10n.unknownUser,
    'unknownValue': l10n.unknownValue,
    'roleUnknown': l10n.roleUnknown,
    'roleAdmin': l10n.roleAdmin,
    'roleManager': l10n.roleManager,
    'roleInspector': l10n.roleInspector,
    'statusPending': l10n.statusPending,
    'statusActive': l10n.statusActive,
    'statusInactive': l10n.statusInactive,
    'verdictGood': l10n.verdictGood,
    'verdictDefect': l10n.verdictDefect,
    'settingsPageTitle': l10n.settingsPageTitle,
    'settingsLanguageSection': l10n.settingsLanguageSection,
    'settingsLanguageDescription': l10n.settingsLanguageDescription,
    'languageIndonesian': l10n.languageIndonesian,
    'languageEnglish': l10n.languageEnglish,
    'languageKorean': l10n.languageKorean,
    'componentsPageTitle': l10n.componentsPageTitle,
    'componentsButtonsTitle': l10n.componentsButtonsTitle,
    'componentsButtonsDescription': l10n.componentsButtonsDescription,
    'componentsPrimaryAction': l10n.componentsPrimaryAction,
    'componentsTonalVariant': l10n.componentsTonalVariant,
    'componentsOutlineVariant': l10n.componentsOutlineVariant,
    'componentsTextVariant': l10n.componentsTextVariant,
    'componentsLoadingIdle': l10n.componentsLoadingIdle,
    'componentsLoadingBusy': l10n.componentsLoadingBusy,
    'componentsDisabledAction': l10n.componentsDisabledAction,
    'componentsInputsTitle': l10n.componentsInputsTitle,
    'componentsInputsDescription': l10n.componentsInputsDescription,
    'componentsHelperText': l10n.componentsHelperText,
    'componentsErrorFieldLabel': l10n.componentsErrorFieldLabel,
    'componentsErrorFieldPlaceholder': l10n.componentsErrorFieldPlaceholder,
    'componentsErrorFieldMessage': l10n.componentsErrorFieldMessage,
    'componentsPasswordFieldLabel': l10n.componentsPasswordFieldLabel,
    'componentsDisabledFieldLabel': l10n.componentsDisabledFieldLabel,
    'componentsDisabledFieldValue': l10n.componentsDisabledFieldValue,
    'componentsInteractionTitle': l10n.componentsInteractionTitle,
    'componentsInteractionDescription': l10n.componentsInteractionDescription,
    'componentsShowDetails': l10n.componentsShowDetails,
    'componentsHideDetails': l10n.componentsHideDetails,
    'componentsInteractionBody': l10n.componentsInteractionBody,
    'errorNetwork': l10n.errorNetwork,
    'errorTimeout': l10n.errorTimeout,
    'errorUnauthorized': l10n.errorUnauthorized,
    'errorForbidden': l10n.errorForbidden,
    'errorValidation': l10n.errorValidation,
    'errorNotFound': l10n.errorNotFound,
    'errorConflict': l10n.errorConflict,
    'errorServer': l10n.errorServer,
    'errorInvalidResponse': l10n.errorInvalidResponse,
    'errorCancelled': l10n.errorCancelled,
    'errorUnknown': l10n.errorUnknown,
    'errorSessionRestoreFailed': l10n.errorSessionRestoreFailed,
    'errorSessionStorageFailed': l10n.errorSessionStorageFailed,
    'errorSessionClearFailed': l10n.errorSessionClearFailed,
  };
}

void main() {
  group('supported locales', () {
    test('exposes Bahasa Indonesia, English, and Korean', () {
      final codes = AppLocalizations.supportedLocales
          .map((locale) => locale.languageCode)
          .toSet();

      expect(codes, containsAll(<String>['id', 'en', 'ko']));
    });

    test('defaults to Bahasa Indonesia', () async {
      final store = LocaleStore(storage: InMemoryLocaleStorage());
      await store.restore();

      expect(store.locale, const Locale('id'));
    });
  });

  group('translation availability', () {
    for (final locale in AppLocalizations.supportedLocales) {
      test('${locale.languageCode} provides every message', () {
        final values = _values(lookupAppLocalizations(locale));

        for (final entry in values.entries) {
          expect(
            entry.value.trim(),
            isNotEmpty,
            reason: '${locale.languageCode}.${entry.key} is empty',
          );
        }
      });
    }

    test('English and Korean differ from the default translations', () {
      final idValues = _values(lookupAppLocalizations(const Locale('id')));
      final enValues = _values(lookupAppLocalizations(const Locale('en')));
      final koValues = _values(lookupAppLocalizations(const Locale('ko')));

      expect(enValues, isNot(equals(idValues)));
      expect(koValues, isNot(equals(idValues)));
    });
  });
}
