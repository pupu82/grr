import 'package:flutter/cupertino.dart'
    show CupertinoAlertDialog, CupertinoDialogAction, showCupertinoDialog;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/app_button.dart';
import '../../components/common/language_dropdown.dart';
import '../../components/forms/app_text_field.dart';
import '../../generated/assets/assets.gen.dart';
import '../../generated/localization/app_localizations.dart';
import '../../router/app_routes.dart';
import '../../store/auth/auth_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/error_message.dart';

/// Login screen that follows the corporate Taekwang Gauge R&R visual identity.
///
/// Credentials are sent to Laravel; no authentication logic is implemented
/// on the client.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _employeeCodeError;
  String? _passwordError;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _employeeCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate(AppLocalizations l10n) {
    final employeeCode = _employeeCodeController.text.trim();
    final password = _passwordController.text;

    final employeeCodeError = employeeCode.isEmpty
        ? l10n.employeeCodeRequired
        : null;
    final passwordError = password.isEmpty ? l10n.passwordRequired : null;

    setState(() {
      _employeeCodeError = employeeCodeError;
      _passwordError = passwordError;
    });

    return employeeCodeError == null && passwordError == null;
  }

  Future<void> _submit() async {
    final store = context.read<AuthStore>();
    final l10n = AppLocalizations.of(context);
    if (store.isSubmitting || !_validate(l10n)) {
      return;
    }

    FocusScope.of(context).unfocus();
    final success = await store.login(
      employeeCode: _employeeCodeController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted || success) {
      return;
    }

    final error = store.error;
    if (error == null) {
      return;
    }

    setState(() {
      _employeeCodeError = error.fieldErrors['employee_code'];
      _passwordError = error.fieldErrors['password'];
    });
  }

  void _showForgotPasswordDialog() {
    final l10n = AppLocalizations.of(context);
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.forgotPassword),
        content: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(l10n.forgotPasswordMessage),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.actionOk),
          ),
        ],
      ),
    );
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  16,
                                  24,
                                  0,
                                ),
                                child: _AuthTopBar(l10n: l10n),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  28,
                                  24,
                                  28,
                                ),
                                child: _AuthHero(l10n: l10n),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: palette.surfaceRaised,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(32),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.12,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, -4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    24,
                                    28,
                                    24,
                                    32,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        l10n.welcomeTitle,
                                        style: AppTextStyles.title.copyWith(
                                          color: palette.textPrimary,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.welcomeSubtitle,
                                        style: AppTextStyles.body.copyWith(
                                          color: palette.textSecondary,
                                          fontSize: 13.5,
                                        ),
                                      ),
                                      if (error != null) ...[
                                        const SizedBox(height: 16),
                                        _ErrorBanner(
                                          message: localizeAppException(
                                            l10n,
                                            error,
                                          ),
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
                                        placeholder:
                                            'inspector01@taekwang.co.id',
                                        errorText: _employeeCodeError,
                                        prefixIcon: Icons.badge_outlined,
                                        textInputAction: TextInputAction.next,
                                        autofillHints: const [
                                          AutofillHints.username,
                                        ],
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
                                        placeholder: '••••••••••',
                                        errorText: _passwordError,
                                        obscureText: _obscurePassword,
                                        prefixIcon: Icons.lock_outline,
                                        textInputAction: TextInputAction.done,
                                        autofillHints: const [
                                          AutofillHints.password,
                                        ],
                                        enabled: !store.isSubmitting,
                                        onSubmitted: (_) => _submit(),
                                        suffix: IconButton(
                                          onPressed: () => setState(
                                            () => _obscurePassword =
                                                !_obscurePassword,
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
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: Checkbox(
                                              value: _rememberMe,
                                              onChanged: store.isSubmitting
                                                  ? null
                                                  : (val) => setState(
                                                      () => _rememberMe =
                                                          val ?? false,
                                                    ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              activeColor: AppColors.darkTeal,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: store.isSubmitting
                                                ? null
                                                : () => setState(
                                                    () => _rememberMe =
                                                        !_rememberMe,
                                                  ),
                                            child: Text(
                                              l10n.rememberMe,
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                    color: palette.textPrimary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            onPressed:
                                                _showForgotPasswordDialog,
                                            child: Text(
                                              l10n.forgotPassword,
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                    color: AppColors.darkTeal,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      AppButton(
                                        label: l10n.signInAction.toUpperCase(),
                                        icon: Icons.login,
                                        isLoading: store.isSubmitting,
                                        onPressed: _submit,
                                      ),
                                      const SizedBox(height: 18),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                    fontSize: 11.5,
                                                    color:
                                                        palette.textSecondary,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            l10n.noAccountPrompt,
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                  color: palette.textSecondary,
                                                ),
                                          ),
                                          TextButton(
                                            onPressed: store.isSubmitting
                                                ? null
                                                : () => Navigator.of(context)
                                                      .pushNamed(
                                                        AppRoutes.register,
                                                      ),
                                            child: Text(
                                              l10n.registerAction,
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                    color: AppColors.darkTeal,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pushNamed(
                                                  AppRoutes.componentDemo,
                                                ),
                                            child: Text(
                                              l10n.viewComponentsAction,
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                    color:
                                                        palette.textSecondary,
                                                    fontSize: 11.5,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            '·',
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                  color: palette.textSecondary,
                                                ),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              context,
                                            ).pushNamed(AppRoutes.settings),
                                            child: Text(
                                              l10n.settingsAction,
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                    color:
                                                        palette.textSecondary,
                                                    fontSize: 11.5,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTopBar extends StatelessWidget {
  const _AuthTopBar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Assets.images.logo.tkg.tkgWhite.image(height: 24, fit: BoxFit.contain),
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
                  color: Colors.white.withValues(alpha: 0.8),
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
    );
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          l10n.heroSubtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.88),
            fontSize: 13.5,
            height: 1.35,
          ),
        ),
      ],
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

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

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
