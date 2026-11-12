import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/buttons/app_button.dart';
import '../../../constants/app_enums.dart';
import '../../../generated/localization/app_localizations.dart';
import '../../../model/report/session_summary.dart';
import '../../../model/user/user.dart';
import '../../../store/sessions/dashboard_sessions_store.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/localized_labels.dart';

/// Inspector dashboard: operational focus with KPIs and quick actions.
class InspectorDashboard extends StatefulWidget {
  const InspectorDashboard({
    super.key,
    required this.user,
    required this.palette,
    required this.sessionsStore,
  });

  final User? user;
  final AppPalette palette;
  final DashboardSessionsStore sessionsStore;

  @override
  State<InspectorDashboard> createState() => _InspectorDashboardState();
}

class _InspectorDashboardState extends State<InspectorDashboard> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      widget.sessionsStore.load(status: 'in_progress');
    }
  }

  @override
  void dispose() {
    widget.sessionsStore.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sessions = widget.sessionsStore.sessions;
    final activeSessions = sessions
        .where((s) => s.status == SessionStatus.inProgress)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _KpiRow(
          kpis: [
            _KpiCard(
              icon: Icons.play_arrow_outlined,
              label: l10n.dashboardActiveSessions,
              value: '${activeSessions.length}',
              palette: widget.palette,
            ),
            _KpiCard(
              icon: Icons.checklist_outlined,
              label: l10n.dashboardInspectionProgress,
              value: activeSessions.isNotEmpty
                  ? '${activeSessions.first.samplesCount ?? 0} samples'
                  : l10n.evaluationNotAvailable,
              palette: widget.palette,
            ),
            _KpiCard(
              icon: Icons.insights_outlined,
              label: l10n.dashboardLastEffectiveness,
              value: l10n.evaluationNotAvailable,
              palette: widget.palette,
            ),
          ],
          palette: widget.palette,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (activeSessions.isNotEmpty) ...[
          _SectionTitle(
            title: l10n.dashboardActiveSessions,
            palette: widget.palette,
          ),
          const SizedBox(height: AppSpacing.md),
          _ActiveSessionsList(
            sessions: activeSessions,
            palette: widget.palette,
            userUuid: widget.user?.uuid,
          ),
        ] else ...[
          _EmptyStateCard(
            icon: Icons.checklist_outlined,
            message: l10n.evaluationNotAvailable,
            palette: widget.palette,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: l10n.dashboardQuickStart,
          variant: AppButtonVariant.filled,
          icon: Icons.rocket_launch_outlined,
          expand: true,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Quick start session feature not yet implemented.',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.kpis, required this.palette});

  final List<Widget> kpis;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: kpis,
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.palette,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 24, color: palette.accent),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: AppTextStyles.title.copyWith(color: palette.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.palette});

  final String title;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.sectionTitle.copyWith(color: palette.textPrimary),
    );
  }
}

class _ActiveSessionsList extends StatelessWidget {
  const _ActiveSessionsList({
    required this.sessions,
    required this.palette,
    this.userUuid,
  });

  final List<SessionSummary> sessions;
  final AppPalette palette;
  final String? userUuid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          final token = session.token ?? session.id;
          final statusLabel = localizeSessionStatus(l10n, session.status);
          final dateLabel = session.sessionDate != null
              ? DateFormat.yMMMd().format(session.sessionDate!.toLocal())
              : l10n.unknownValue;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: palette.accent.withValues(alpha: 0.10),
              child: Icon(Icons.play_arrow, color: palette.accent, size: 18),
            ),
            title: Text(
              token,
              style: AppTextStyles.title.copyWith(color: palette.textPrimary),
            ),
            subtitle: Text(
              '$statusLabel • $dateLabel',
              style: AppTextStyles.body.copyWith(color: palette.textSecondary),
            ),
            trailing: AppButton(
              label: l10n.dashboardQuickStart,
              variant: AppButtonVariant.outline,
              icon: Icons.play_arrow_outlined,
              expand: false,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session run flow not yet implemented.'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.icon,
    required this.message,
    required this.palette,
  });

  final IconData icon;
  final String message;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: palette.textSecondary),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
