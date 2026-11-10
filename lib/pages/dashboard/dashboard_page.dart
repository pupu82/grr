import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/app_button.dart';
import '../../constants/app_constants.dart';
import '../../generated/localization/app_localizations.dart';
import '../../model/user/user.dart';
import '../../router/app_routes.dart';
import '../../store/auth/auth_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/localized_labels.dart';

/// Landing screen for authenticated users.
///
/// Feature modules (inspection, sessions, reports) will replace the placeholder
/// content once their backend contracts are available.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final store = context.watch<AuthStore>();
    final user = store.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: l10n.settingsPageTitle,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
          TextButton(
            onPressed: store.isSubmitting ? null : store.logout,
            child: Text(l10n.dashboardLogout),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileCard(user: user, palette: palette),
                  const SizedBox(height: AppSpacing.lg),
                  _PlaceholderCard(palette: palette),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      AppButton(
                        label: l10n.viewComponentsAction,
                        variant: AppButtonVariant.outline,
                        icon: Icons.widgets_outlined,
                        expand: false,
                        onPressed: () =>
                            Navigator.of(context)
                                .pushNamed(AppRoutes.componentDemo),
                      ),
                      AppButton(
                        label: l10n.settingsAction,
                        variant: AppButtonVariant.outline,
                        icon: Icons.settings_outlined,
                        expand: false,
                        onPressed: () =>
                            Navigator.of(context).pushNamed(AppRoutes.settings),
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user, required this.palette});

  final User? user;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = user?.name ?? l10n.unknownUser;
    final employeeCode = user?.employeeCode ?? l10n.unknownValue;
    final roleLabel = localizeRole(l10n, user?.role);
    final statusLabel = user?.status == null
        ? null
        : localizeAccountStatus(l10n, user?.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardWelcome,
              style: AppTextStyles.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              name,
              style: AppTextStyles.title.copyWith(color: palette.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _MetaChip(
                  icon: Icons.badge_outlined,
                  label: employeeCode,
                  palette: palette,
                ),
                _MetaChip(
                  icon: Icons.person_outline,
                  label: roleLabel,
                  palette: palette,
                ),
                if (statusLabel != null)
                  _MetaChip(
                    icon: Icons.verified_outlined,
                    label: statusLabel,
                    palette: palette,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.palette,
  });

  final IconData icon;
  final String label;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: palette.accent),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: palette.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardSummaryTitle,
              style: AppTextStyles.sectionTitle.copyWith(
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.dashboardSummaryBody,
              style: AppTextStyles.body.copyWith(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
