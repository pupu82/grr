import '../constants/app_enums.dart';
import '../generated/localization/app_localizations.dart';
import 'app_exception.dart';

/// Resolves an [AppException] into a localized, user-presentable message.
///
/// The backend `code` is authoritative. [AppException.kind] is only a fallback
/// for transport and unexpected errors.
String localizeAppException(AppLocalizations l10n, AppException error) {
  final code = error.code;
  if (code != null) {
    return switch (code) {
      ErrorCode.unauthenticated => l10n.errorUnauthenticated,
      ErrorCode.invalidCredentials => l10n.errorInvalidCredentials,
      ErrorCode.accountPending => l10n.errorAccountPending,
      ErrorCode.accountInactive => l10n.errorAccountInactive,
      ErrorCode.passwordChangeRequired => l10n.errorPasswordChangeRequired,
      ErrorCode.forbidden => l10n.errorForbidden,
      ErrorCode.notFound => l10n.errorNotFound,
      ErrorCode.methodNotAllowed => l10n.errorMethodNotAllowed,
      ErrorCode.validationFailed => l10n.errorValidation,
      ErrorCode.tooManyRequests => l10n.errorTooManyRequests,
      ErrorCode.httpError => l10n.errorHttpError,
    };
  }

  return switch (error.kind) {
    AppExceptionKind.network => l10n.errorNetwork,
    AppExceptionKind.timeout => l10n.errorTimeout,
    AppExceptionKind.unauthorized => l10n.errorUnauthorized,
    AppExceptionKind.forbidden => l10n.errorForbidden,
    AppExceptionKind.validation => l10n.errorValidation,
    AppExceptionKind.notFound => l10n.errorNotFound,
    AppExceptionKind.conflict => l10n.errorConflict,
    AppExceptionKind.methodNotAllowed => l10n.errorMethodNotAllowed,
    AppExceptionKind.tooManyRequests => l10n.errorTooManyRequests,
    AppExceptionKind.server => l10n.errorServer,
    AppExceptionKind.invalidResponse => l10n.errorInvalidResponse,
    AppExceptionKind.cancelled => l10n.errorCancelled,
    AppExceptionKind.sessionRestoreFailed => l10n.errorSessionRestoreFailed,
    AppExceptionKind.sessionStorageFailed => l10n.errorSessionStorageFailed,
    AppExceptionKind.sessionClearFailed => l10n.errorSessionClearFailed,
    AppExceptionKind.unknown => l10n.errorUnknown,
  };
}
