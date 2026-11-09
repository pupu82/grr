import 'package:flutter/material.dart';

import '../../components/buttons/app_button.dart';
import '../../components/forms/app_text_field.dart';
import '../../generated/localization/app_localizations.dart';
import '../../theme/app_theme.dart';

/// Demo page required for every reusable component.
///
/// Shows base usage, common variants, and edge states for [AppButton] and
/// [AppTextField]. Interactions are real: the loading button actually runs a
/// short async task and the text fields are editable.
class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  final TextEditingController _plainController = TextEditingController(
    text: 'EMP-0001',
  );
  final TextEditingController _errorController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(
    text: 'contoh-sandi',
  );
  final TextEditingController _disabledController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _toggleExpanded = false;

  @override
  void dispose() {
    _plainController.dispose();
    _errorController.dispose();
    _passwordController.dispose();
    _disabledController.dispose();
    super.dispose();
  }

  Future<void> _runLoadingDemo() async {
    if (_isLoading) {
      return;
    }
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.componentsPageTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DemoSection(
                    title: l10n.componentsButtonsTitle,
                    description: l10n.componentsButtonsDescription,
                    children: [
                      AppButton(
                        label: l10n.componentsPrimaryAction,
                        icon: Icons.check,
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: l10n.componentsTonalVariant,
                        variant: AppButtonVariant.tonal,
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: l10n.componentsOutlineVariant,
                        variant: AppButtonVariant.outline,
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: l10n.componentsTextVariant,
                        variant: AppButtonVariant.text,
                        onPressed: () {},
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: _isLoading
                            ? l10n.componentsLoadingBusy
                            : l10n.componentsLoadingIdle,
                        isLoading: _isLoading,
                        onPressed: _runLoadingDemo,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(label: l10n.componentsDisabledAction),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _DemoSection(
                    title: l10n.componentsInputsTitle,
                    description: l10n.componentsInputsDescription,
                    children: [
                      AppTextField(
                        controller: _plainController,
                        label: l10n.employeeCodeLabel,
                        placeholder: l10n.employeeCodePlaceholder,
                        helperText: l10n.componentsHelperText,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _errorController,
                        label: l10n.componentsErrorFieldLabel,
                        placeholder: l10n.componentsErrorFieldPlaceholder,
                        errorText: l10n.componentsErrorFieldMessage,
                        prefixIcon: Icons.error_outline,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _passwordController,
                        label: l10n.componentsPasswordFieldLabel,
                        obscureText: _obscurePassword,
                        prefixIcon: Icons.lock_outline,
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
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _disabledController,
                        label: l10n.componentsDisabledFieldLabel,
                        placeholder: l10n.componentsDisabledFieldValue,
                        enabled: false,
                        prefixIcon: Icons.lock_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _DemoSection(
                    title: l10n.componentsInteractionTitle,
                    description: l10n.componentsInteractionDescription,
                    children: [
                      AppButton(
                        label: _toggleExpanded
                            ? l10n.componentsHideDetails
                            : l10n.componentsShowDetails,
                        variant: AppButtonVariant.outline,
                        icon: _toggleExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        onPressed: () =>
                            setState(() => _toggleExpanded = !_toggleExpanded),
                      ),
                      if (_toggleExpanded) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.componentsInteractionBody,
                          style: AppTextStyles.body.copyWith(
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
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

class _DemoSection extends StatelessWidget {
  const _DemoSection({
    required this.title,
    required this.description,
    required this.children,
  });

  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              style: AppTextStyles.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...children,
          ],
        ),
      ),
    );
  }
}
