import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/app_button.dart';
import '../../components/forms/app_text_field.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_theme.dart';
import '../../generated/localization/app_localizations.dart';
import '../../router/app_routes.dart';
import '../../store/auth/auth_store.dart';
import '../../utils/error_message.dart';

/// Login screen. Credentials are sent to Laravel; no authentication logic is
/// implemented on the client.
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

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final store = context.watch<AuthStore>();
    final error = store.error;

    return CupertinoPageScaffold(
      backgroundColor: palette.surface,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.xxl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BrandHeader(palette: palette),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: palette.surfaceRaised,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(color: palette.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.loginTitle,
                          style: AppTextStyles.title.copyWith(
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.loginSubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                        if (error != null) ...[
                          const SizedBox(height: AppSpacing.lg),
                          _ErrorBanner(
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
                          autofillHints: const [AutofillHints.username],
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
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          enabled: !store.isSubmitting,
                          onSubmitted: (_) => _submit(),
                          suffix: CupertinoButton(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            child: Icon(
                              _obscurePassword
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_slash,
                              size: 18,
                              color: palette.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        AppButton(
                          label: l10n.signInAction,
                          icon: CupertinoIcons.arrow_right_to_line,
                          isLoading: store.isSubmitting,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.noAccountPrompt,
                        style: AppTextStyles.caption.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                        onPressed: store.isSubmitting
                            ? null
                            : () =>
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.register),
                        child: Text(
                          l10n.registerAction,
                          style: AppTextStyles.caption.copyWith(
                            color: palette.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            Navigator.of(context)
                                .pushNamed(AppRoutes.componentDemo),
                        child: Text(
                          l10n.viewComponentsAction,
                          style: AppTextStyles.caption.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        '·',
                        style: AppTextStyles.caption.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            Navigator.of(context).pushNamed(AppRoutes.settings),
                        child: Text(
                          l10n.settingsAction,
                          style: AppTextStyles.caption.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                      ),
                    ],
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

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Container(
          height: 56,
          width: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Icon(CupertinoIcons.chart_bar_alt_fill, color: palette.accent),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppConstants.appName,
          textAlign: TextAlign.center,
          style: AppTextStyles.display.copyWith(color: palette.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.brandSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
        ),
      ],
    );
  }
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
