import '../constants/app_enums.dart';
import '../generated/localization/app_localizations.dart';

/// Localized presentation of a backend role value.
String localizeRole(AppLocalizations l10n, UserRole? role) {
  return switch (role) {
    UserRole.admin => l10n.roleAdmin,
    UserRole.manager => l10n.roleManager,
    UserRole.inspector => l10n.roleInspector,
    null => l10n.roleUnknown,
  };
}

/// Localized presentation of a backend account status.
String localizeAccountStatus(AppLocalizations l10n, AccountStatus? status) {
  return switch (status) {
    AccountStatus.pending => l10n.statusPending,
    AccountStatus.active => l10n.statusActive,
    AccountStatus.inactive => l10n.statusInactive,
    null => l10n.unknownValue,
  };
}

/// Localized presentation of a backend verdict.
///
/// Only the label is translated; the API value stays `good` or `defect`.
String localizeVerdict(AppLocalizations l10n, Verdict verdict) {
  return switch (verdict) {
    Verdict.good => l10n.verdictGood,
    Verdict.defect => l10n.verdictDefect,
  };
}
