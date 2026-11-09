import 'package:flutter/cupertino.dart'
    show CupertinoAlertDialog, CupertinoDialogAction, showCupertinoDialog;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/app_button.dart';
import '../../components/common/language_dropdown.dart';
import '../../components/forms/app_text_field.dart';
import '../../generated/assets/assets.gen.dart';
import '../../generated/localization/app_localizations.dart';
import '../../store/auth/auth_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/error_message.dart';

/// Self-registration screen that follows the corporate Taekwang Gauge R&R visual identity.
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

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C4644), Color(0xFF147572)],
          ),
        ),
        child: CustomPaint(
          painter: const _GridBackgroundPainter(),
          child: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Row(
                          children: [
                            Assets.images.logo.tkg.tkgWhite.image(
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l10n.companyName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.digitalGrrSystem,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const LanguageDropdown(isDarkBackground: true),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.qualityControlPlatform,
                              style: const TextStyle(
                                color: Color(0xFFB2E2DF),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.heroTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.registerHeroSubtitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.88),
                                fontSize: 13.5,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: palette.surfaceRaised,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 16,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.registerHeadline,
                              style: AppTextStyles.title.copyWith(
                                color: palette.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.registerSubtitle,
                              style: AppTextStyles.body.copyWith(
                                color: palette.textSecondary,
                                fontSize: 13.5,
                              ),
                            ),
                            if (error != null) ...[
                              const SizedBox(height: 16),
                              _FormErrorBanner(
                                message: localizeAppException(l10n, error),
                              ),
                            ],
                            const SizedBox(height: 20),
                            Text(
                              l10n.employeeCodeLabel,
                              style: AppTextStyles.label.copyWith(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AppTextField(
                              controller: _employeeCodeController,
                              placeholder: l10n.employeeCodePlaceholder,
                              errorText: _employeeCodeError,
                              prefixIcon: Icons.badge_outlined,
                              textInputAction: TextInputAction.next,
                              enabled: !store.isSubmitting,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.fullNameLabel,
                              style: AppTextStyles.label.copyWith(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AppTextField(
                              controller: _nameController,
                              placeholder: l10n.fullNamePlaceholder,
                              errorText: _nameError,
                              prefixIcon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                              enabled: !store.isSubmitting,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.emailOptionalLabel,
                              style: AppTextStyles.label.copyWith(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AppTextField(
                              controller: _emailController,
                              placeholder: l10n.emailPlaceholder,
                              errorText: _emailError,
                              prefixIcon: Icons.mail_outline,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              enabled: !store.isSubmitting,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.passwordLabel,
                              style: AppTextStyles.label.copyWith(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AppTextField(
                              controller: _passwordController,
                              placeholder: l10n.passwordPlaceholder,
                              errorText: _passwordError,
                              obscureText: _obscurePassword,
                              prefixIcon: Icons.lock_outline,
                              textInputAction: TextInputAction.next,
                              enabled: !store.isSubmitting,
                              suffix: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: palette.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.confirmPasswordLabel,
                              style: AppTextStyles.label.copyWith(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AppTextField(
                              controller: _confirmationController,
                              placeholder: l10n.confirmPasswordPlaceholder,
                              errorText: _confirmationError,
                              obscureText: true,
                              prefixIcon: Icons.lock_reset,
                              textInputAction: TextInputAction.done,
                              enabled: !store.isSubmitting,
                              onSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              label: l10n.submitRegistrationAction
                                  .toUpperCase(),
                              icon: Icons.send_outlined,
                              isLoading: store.isSubmitting,
                              onPressed: _submit,
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  size: 15,
                                  color: palette.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    l10n.securityBadge,
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 11.5,
                                      color: palette.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  l10n.alreadyHaveAccount,
                                  style: AppTextStyles.caption.copyWith(
                                    color: palette.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: store.isSubmitting
                                      ? null
                                      : () => Navigator.of(context).pop(),
                                  child: Text(
                                    l10n.signInAction,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.darkTeal,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridBackgroundPainter extends CustomPainter {
  const _GridBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 1.0;

    const double hSpacing = 38.0;
    for (double y = 0; y <= size.height; y += hSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    const double vSpacing = 42.0;
    for (double x = 0; x <= size.width; x += vSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
          Icon(Icons.error_outline, size: 18, color: palette.danger),
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
