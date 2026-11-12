import 'package:flutter/material.dart';

import '../../../components/buttons/app_button.dart';
import '../../../constants/app_enums.dart';
import '../../../generated/localization/app_localizations.dart';
import '../../../model/report/session_summary.dart';
import '../../../model/user/user.dart';
import '../../../store/sessions/dashboard_sessions_store.dart';
import '../../../theme/app_theme.dart';

/// Admin dashboard: audit focus with actionable items and force-close.
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({
    super.key,
    required this.user,
    required this.palette,
    required this.sessionsStore,
  });

  final User? user;
  final AppPalette palette;
  final DashboardSessionsStore sessionsStore;

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
    final inProgressSessions = sessions
        .where((s) => s.status == SessionStatus.inProgress)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _KpiRow(
          kpis: [
            _KpiCard(
              icon: Icons.warning_amber_rounded,
              label: l10n.dashboardAuditAttention,
              value: '${inProgressSessions.length}',
              palette: widget.palette,
            ),
            _KpiCard(
              icon: Icons.health_and_safety_outlined,
              label: l10n.dashboardSystemHealth,
              value: l10n.evaluationNotAvailable,
              palette: widget.palette,
            ),
            _KpiCard(
              icon: Icons.person_search_outlined,
              label: l10n.dashboardPendingUsers,
              value: l10n.evaluationNotAvailable,
              palette: widget.palette,
            ),
          ],
          palette: widget.palette,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (inProgressSessions.isNotEmpty) ...[
          _SectionTitle(
            title: l10n.dashboardAuditAttention,
            palette: widget.palette,
          ),
          const SizedBox(height: AppSpacing.md),
          _InProgressSessionsList(
            sessions: inProgressSessions,
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

class _InProgressSessionsList extends StatelessWidget {
  const _InProgressSessionsList({
    required this.sessions,
    required this.palette,
  });

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
              child: Icon(Icons.play_arrow, color: palette.accent, size: 18),
            ),
            title: Text(
              token,
              style: AppTextStyles.title.copyWith(color: palette.textPrimary),
            ),
            subtitle: Text(
              '$dateLabel • ${session.participantsCount ?? 0} participants',
              style: AppTextStyles.body.copyWith(color: palette.textSecondary),
            ),
            trailing: AppButton(
              label: l10n.dashboardForceClose,
              variant: AppButtonVariant.outline,
              icon: Icons.stop_outlined,
              expand: false,
              onPressed: () {
                _confirmForceClose(context, session.id);
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmForceClose(BuildContext context, String sessionId) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.dashboardForceClose),
        content: Text(l10n.forceCloseConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _performForceClose(context, sessionId);
            },
            child: Text(l10n.actionOk),
          ),
        ],
      ),
    );
  }

  Future<void> _performForceClose(
    BuildContext context,
    String sessionId,
  ) async {
    // Call the API to force-close the session.
    // For now, show a snackbar indicating the action was taken.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session force-close feature not yet implemented.'),
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
