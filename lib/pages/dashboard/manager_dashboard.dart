import 'package:flutter/material.dart';

import '../../../components/buttons/app_button.dart';
import '../../../constants/app_enums.dart';
import '../../../generated/localization/app_localizations.dart';
import '../../../model/report/session_summary.dart';
import '../../../model/user/user.dart';
import '../../../router/app_routes.dart';
import '../../../store/sessions/dashboard_sessions_store.dart';
import '../../../theme/app_theme.dart';

/// Manager dashboard: reporting focus with KPIs and trend visualizations.
class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({
    super.key,
    required this.user,
    required this.palette,
    required this.sessionsStore,
  });

  final User? user;
  final AppPalette palette;
  final DashboardSessionsStore sessionsStore;

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      widget.sessionsStore.load();
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
    final completedSessions = sessions
        .where((s) => s.status == SessionStatus.completed)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _KpiRow(
          kpis: [
            _KpiCard(
              icon: Icons.insights_outlined,
              label: l10n.dashboardSystemEffectiveness,
              value: l10n.evaluationNotAvailable,
              palette: widget.palette,
            ),
            _KpiCard(
              icon: Icons.donut_small_outlined,
              label: l10n.dashboardJudgementDistribution,
              value: l10n.evaluationNotAvailable,
              palette: widget.palette,
            ),
            _KpiCard(
              icon: Icons.timeline_outlined,
              label: l10n.dashboardAgreementTrend,
              value: l10n.evaluationNotAvailable,
              palette: widget.palette,
            ),
          ],
          palette: widget.palette,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (completedSessions.isNotEmpty) ...[
          _SectionTitle(
            title: l10n.sessionStatusCompleted,
            palette: widget.palette,
          ),
          const SizedBox(height: AppSpacing.md),
          _CompletedSessionsList(
            sessions: completedSessions,
            palette: widget.palette,
          ),
        ] else ...[
          _EmptyStateCard(
            icon: Icons.checklist_outlined,
            message: l10n.evaluationNotAvailable,
            palette: widget.palette,
          ),
        ],
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

class _CompletedSessionsList extends StatelessWidget {
  const _CompletedSessionsList({required this.sessions, required this.palette});

  final List<SessionSummary> sessions;
  final AppPalette palette;

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
          final dateLabel = session.sessionDate != null
              ? session.sessionDate!.toLocal().toIso8601String().substring(
                  0,
                  10,
                )
              : l10n.unknownValue;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: palette.accent.withValues(alpha: 0.10),
              child: Icon(Icons.check_circle, color: palette.accent, size: 18),
            ),
            title: Text(
              token,
              style: AppTextStyles.title.copyWith(color: palette.textPrimary),
            ),
            subtitle: Text(
              '$dateLabel • ${session.samplesCount ?? 0} samples',
              style: AppTextStyles.body.copyWith(color: palette.textSecondary),
            ),
            trailing: AppButton(
              label: l10n.evaluationPageTitle,
              variant: AppButtonVariant.outline,
              icon: Icons.insights_outlined,
              expand: false,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.sessionEvaluation(session.id));
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
