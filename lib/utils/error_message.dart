import '../generated/localization/app_localizations.dart';
import 'app_exception.dart';

/// Resolves an [AppException] into a localized, user-presentable message.
String localizeAppException(AppLocalizations l10n, AppException error) {
  return switch (error.kind) {
    AppExceptionKind.network => l10n.errorNetwork,
    AppExceptionKind.timeout => l10n.errorTimeout,
    AppExceptionKind.unauthorized => l10n.errorUnauthorized,
    AppExceptionKind.forbidden => l10n.errorForbidden,
    AppExceptionKind.validation => l10n.errorValidation,
    AppExceptionKind.notFound => l10n.errorNotFound,
    AppExceptionKind.conflict => l10n.errorConflict,
    AppExceptionKind.server => l10n.errorServer,
    AppExceptionKind.invalidResponse => l10n.errorInvalidResponse,
    AppExceptionKind.cancelled => l10n.errorCancelled,
    AppExceptionKind.sessionRestoreFailed => l10n.errorSessionRestoreFailed,
    AppExceptionKind.sessionStorageFailed => l10n.errorSessionStorageFailed,
    AppExceptionKind.sessionClearFailed => l10n.errorSessionClearFailed,
    AppExceptionKind.unknown => l10n.errorUnknown,
  };
}
