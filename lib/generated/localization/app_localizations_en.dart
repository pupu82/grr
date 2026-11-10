// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gauge R&R';

  @override
  String get brandSubtitle => 'Attribute Gauge R&R inspection system';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionOk => 'Got it';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Use your employee code and password.';

  @override
  String get employeeCodeLabel => 'Employee code';

  @override
  String get employeeCodePlaceholder => 'Example: EMP-0001';

  @override
  String get employeeCodeRequired => 'Employee code is required.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordPlaceholder => 'Enter your password';

  @override
  String get passwordRequired => 'Password is required.';

  @override
  String get signInAction => 'Sign in';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get registerAction => 'Register';

  @override
  String get viewComponentsAction => 'View UI components';

  @override
  String get settingsAction => 'Settings';

  @override
  String get registerPageTitle => 'Create account';

  @override
  String get registerHeadline => 'Create an inspector account';

  @override
  String get registerSubtitle =>
      'Registration always creates a pending inspector account.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNamePlaceholder => 'Name as recorded by the company';

  @override
  String get fullNameRequired => 'Full name is required.';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get confirmPasswordPlaceholder => 'Repeat your password';

  @override
  String get passwordMismatch => 'Password confirmation does not match.';

  @override
  String get submitRegistrationAction => 'Submit registration';

  @override
  String get registrationSuccessTitle => 'Request received';

  @override
  String get registrationSuccessMessage =>
      'Thank you. If the submitted details are eligible, an administrator will review them. Please contact your administrator for further information.';

  @override
  String get dashboardWelcome => 'Welcome';

  @override
  String get dashboardLogout => 'Sign out';

  @override
  String get dashboardSummaryTitle => 'Inspection summary';

  @override
  String get dashboardSummaryBody =>
      'Evaluation metrics, inspection sessions, and reports will appear here once their API contracts are available. All calculations remain on the Laravel backend.';

  @override
  String get unknownUser => 'User';

  @override
  String get unknownValue => '-';

  @override
  String get roleUnknown => 'Unrecognized role';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleInspector => 'Inspector';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get verdictGood => 'Good';

  @override
  String get verdictDefect => 'Defect';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageDescription =>
      'Choose the application interface language.';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English (US)';

  @override
  String get languageKorean => '한국어';

  @override
  String get componentsPageTitle => 'UI components';

  @override
  String get componentsButtonsTitle => 'Buttons';

  @override
  String get componentsButtonsDescription =>
      'Base usage, variants, loading state, and disabled state.';

  @override
  String get componentsPrimaryAction => 'Primary action';

  @override
  String get componentsTonalVariant => 'Tonal variant';

  @override
  String get componentsOutlineVariant => 'Outline variant';

  @override
  String get componentsTextVariant => 'Text variant';

  @override
  String get componentsLoadingIdle => 'Try the loading state';

  @override
  String get componentsLoadingBusy => 'Processing…';

  @override
  String get componentsDisabledAction => 'Disabled without handler';

  @override
  String get componentsInputsTitle => 'Text inputs';

  @override
  String get componentsInputsDescription =>
      'Label, helper, error, password, and disabled states.';

  @override
  String get componentsHelperText => 'Demo only, nothing is sent to the API.';

  @override
  String get componentsErrorFieldLabel => 'Input with error';

  @override
  String get componentsErrorFieldPlaceholder => 'Try typing something';

  @override
  String get componentsErrorFieldMessage =>
      'Example backend validation message.';

  @override
  String get componentsPasswordFieldLabel => 'Password';

  @override
  String get componentsDisabledFieldLabel => 'Disabled input';

  @override
  String get componentsDisabledFieldValue => 'Disabled';

  @override
  String get componentsInteractionTitle => 'Desktop and mobile interaction';

  @override
  String get componentsInteractionDescription =>
      'Collapsible area to verify tap, click, and keyboard behavior.';

  @override
  String get componentsShowDetails => 'Show details';

  @override
  String get componentsHideDetails => 'Hide details';

  @override
  String get componentsInteractionBody =>
      'This content comes from real state, not a static animation. Use Tab to move focus and Enter to activate buttons.';

  @override
  String get errorNetwork => 'Cannot reach the server. Check your connection.';

  @override
  String get errorTimeout =>
      'The server took too long to respond. Please try again.';

  @override
  String get errorUnauthorized =>
      'Your session has ended. Please sign in again.';

  @override
  String get errorForbidden => 'You do not have access to this action.';

  @override
  String get errorValidation =>
      'The submitted data is not valid. Please review your input.';

  @override
  String get errorNotFound => 'The requested data was not found.';

  @override
  String get errorConflict => 'The request conflicts with the current data.';

  @override
  String get errorServer =>
      'The server is having trouble. Please try again later.';

  @override
  String get errorInvalidResponse =>
      'The server response was not recognized. Contact an administrator if the problem continues.';

  @override
  String get errorCancelled => 'The request was cancelled.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get errorSessionRestoreFailed =>
      'The stored session could not be read. Please sign in again.';

  @override
  String get errorSessionStorageFailed =>
      'The session could not be saved on this device. Please try again.';

  @override
  String get errorSessionClearFailed =>
      'The local session could not be fully cleared. Close the app and sign in again.';

  @override
  String get errorUnauthenticated =>
      'Your session has ended. Please sign in again.';

  @override
  String get errorInvalidCredentials =>
      'Employee code or password is incorrect.';

  @override
  String get errorAccountPending =>
      'Your account is still waiting for administrator approval.';

  @override
  String get errorAccountInactive =>
      'Your account is inactive. Contact your administrator.';

  @override
  String get errorPasswordChangeRequired =>
      'You must change your password before continuing.';

  @override
  String get errorMethodNotAllowed => 'This request is not supported.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get errorHttpError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get companyName => 'PT TKG TAEKWANG INDONESIA';

  @override
  String get digitalGrrSystem => 'Digital Gauge R&R System';

  @override
  String get qualityControlPlatform => 'QUALITY CONTROL PLATFORM';

  @override
  String get heroTitle => 'Measurement you can trust.';

  @override
  String get heroSubtitle =>
      'Consistent, accurate, and audit-ready measurement system evaluation.';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeSubtitle => 'Sign in using your company account.';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordMessage =>
      'Please contact your company\'s system administrator to reset your account password.';

  @override
  String get securityBadge => 'Encrypted & protected internal access';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get registerHeroSubtitle =>
      'Join the company quality inspection system.';
}
