import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/app_button.dart';
import '../../components/forms/app_text_field.dart';
import '../../constants/app_theme.dart';
import '../../generated/localization/app_localizations.dart';
import '../../store/auth/auth_store.dart';
import '../../utils/error_message.dart';

/// Self-registration screen.
///
/// The payload never contains a role: the backend always creates a pending
/// inspector account.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();

  String? _employeeCodeError;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmationError;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _employeeCodeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  bool _validate(AppLocalizations l10n) {
    final employeeCode = _employeeCodeController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmation = _confirmationController.text;

    final employeeCodeError = employeeCode.isEmpty
        ? l10n.employeeCodeRequired
        : null;
    final nameError = name.isEmpty ? l10n.fullNameRequired : null;
    final emailError = email.isNotEmpty && !_looksLikeEmail(email)
        ? l10n.emailInvalid
        : null;
    final passwordError = password.isEmpty ? l10n.passwordRequired : null;
    final confirmationError = confirmation != password
        ? l10n.passwordMismatch
        : null;

    setState(() {
      _employeeCodeError = employeeCodeError;
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmationError = confirmationError;
    });

    return employeeCodeError == null &&
        nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmationError == null;
  }

  Future<void> _submit() async {
    final store = context.read<AuthStore>();
    final l10n = AppLocalizations.of(context);
    if (store.isSubmitting || !_validate(l10n)) {
      return;
    }

    FocusScope.of(context).unfocus();
    final success = await store.register(
      employeeCode: _employeeCodeController.text.trim(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmationController.text,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      final error = store.error;
      if (error == null) {
        return;
      }
      setState(() {
        _employeeCodeError = error.fieldErrors['employee_code'];
        _nameError = error.fieldErrors['name'];
        _emailError = error.fieldErrors['email'];
        _passwordError = error.fieldErrors['password'];
        _confirmationError = error.fieldErrors['password_confirmation'];
      });
      return;
    }

    await _showSuccessDialog(l10n);
  }

  Future<void> _showSuccessDialog(AppLocalizations l10n) async {
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.registrationSuccessTitle),
        content: Text(l10n.registrationSuccessMessage),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.actionOk),
          ),
        ],
      ),
    );

    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final store = context.watch<AuthStore>();
    final error = store.error;

    return CupertinoPageScaffold(
      backgroundColor: palette.surface,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.registerPageTitle),
        backgroundColor: palette.surface,
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.registerHeadline,
                    style: AppTextStyles.title.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.registerSubtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _FormErrorBanner(
                      message: localizeAppException(l10n, error),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  AppTextField(
                    controller: _employeeCodeController,
                    label: l10n.employeeCodeLabel,
                    placeholder: l10n.employeeCodePlaceholder,
                    errorText: _employeeCodeError,
                    prefixIcon: CupertinoIcons.person,
                    textInputAction: TextInputAction.next,
                    enabled: !store.isSubmitting,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _nameController,
                    label: l10n.fullNameLabel,
                    placeholder: l10n.fullNamePlaceholder,
                    errorText: _nameError,
                    prefixIcon: CupertinoIcons.person_crop_circle,
                    textInputAction: TextInputAction.next,
                    enabled: !store.isSubmitting,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _emailController,
                    label: l10n.emailOptionalLabel,
                    placeholder: l10n.emailPlaceholder,
                    errorText: _emailError,
                    prefixIcon: CupertinoIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    enabled: !store.isSubmitting,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _passwordController,
                    label: l10n.passwordLabel,
                    placeholder: l10n.passwordPlaceholder,
                    errorText: _passwordError,
                    obscureText: _obscurePassword,
                    prefixIcon: CupertinoIcons.lock,
                    textInputAction: TextInputAction.next,
                    enabled: !store.isSubmitting,
                    suffix: CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                        size: 18,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: _confirmationController,
                    label: l10n.confirmPasswordLabel,
                    placeholder: l10n.confirmPasswordPlaceholder,
                    errorText: _confirmationError,
                    obscureText: true,
                    prefixIcon: CupertinoIcons.lock_shield,
                    textInputAction: TextInputAction.done,
                    enabled: !store.isSubmitting,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: l10n.submitRegistrationAction,
                    icon: CupertinoIcons.paperplane,
                    isLoading: store.isSubmitting,
                    onPressed: _submit,
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

bool _looksLikeEmail(String value) {
  final atIndex = value.indexOf('@');
  return atIndex > 0 && value.indexOf('.', atIndex) > atIndex + 1;
}

class _FormErrorBanner extends StatelessWidget {
  const _FormErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.danger.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.danger.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            CupertinoIcons.exclamationmark_circle_fill,
            size: 16,
            color: palette.danger,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(color: palette.danger),
            ),
          ),
        ],
      ),
    );
  }
}
