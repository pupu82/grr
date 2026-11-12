import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/app_button.dart';
import '../../constants/app_enums.dart';
import '../../generated/localization/app_localizations.dart';
import '../../model/report/session_agreement.dart';
import '../../model/report/session_evaluation_result.dart';
import '../../model/report/session_evaluation_summary.dart';
import '../../store/auth/auth_store.dart';
import '../../store/sessions/session_evaluation_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/error_message.dart';
import '../../utils/localized_labels.dart';

/// Read-only evaluation of a completed inspection session.
///
/// Admin and Manager only. The screen displays the backend-computed session
/// agreement; it never calculates rates or derives a judgement.
class SessionEvaluationPage extends StatefulWidget {
  const SessionEvaluationPage({super.key, required this.sessionId});

  /// Public session UUID.
  final String sessionId;

  @override
  State<SessionEvaluationPage> createState() => _SessionEvaluationPageState();
}

class _SessionEvaluationPageState extends State<SessionEvaluationPage> {
  bool _forbidden = false;

  @override
  void initState() {
    super.initState();

    final role = context.read<AuthStore>().user?.role;
    if (role == UserRole.admin || role == UserRole.manager) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        context.read<SessionEvaluationStore>().load(widget.sessionId);
      });
    } else {
      // Inspectors must read their own results from the results endpoint.
      // Do not call the evaluation endpoint for them.
      _forbidden = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final store = context.watch<SessionEvaluationStore>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.evaluationPageTitle)),
      body: SafeArea(
        child: _forbidden
            ? _MessageState(
                icon: Icons.lock_outline,
                message: l10n.errorForbidden,
              )
            : switch (store.status) {
                SessionEvaluationStatus.idle ||
                SessionEvaluationStatus.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
                SessionEvaluationStatus.error => _ErrorState(
                  message: localizeAppException(l10n, store.error!),
                  onRetry: () => store.load(widget.sessionId),
                ),
                SessionEvaluationStatus.success => _EvaluationContent(
                  result: store.result!,
                ),
              },
      ),
    );
  }
}

class _EvaluationContent extends StatelessWidget {
  const _EvaluationContent({required this.result});

  final SessionEvaluationResult result;

  @override
  Widget build(BuildContext context) {
    final session = result.session;
    final participants = result.participants;
    final hasParticipants = participants.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (session != null) _SessionCard(session: session),
              if (session != null) const SizedBox(height: AppSpacing.lg),
              _AgreementCard(agreement: result.agreement),
              if (hasParticipants) const SizedBox(height: AppSpacing.lg),
              if (hasParticipants)
                _ParticipantMetricsTable(participants: participants),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParticipantMetricsTable extends StatelessWidget {
  const _ParticipantMetricsTable({required this.participants});

  final List<EvaluationParticipant> participants;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.evaluationParticipantsTitle,
              style: AppTextStyles.sectionTitle.copyWith(
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 640;
                final tableData = _buildTableData(
                  context,
                  l10n,
                  palette,
                  isWide,
                );
                return tableData;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableData(
    BuildContext context,
    AppLocalizations l10n,
    AppPalette palette,
    bool isWide,
  ) {
    if (!isWide) {
      return _buildMobileLayout(context, l10n, palette);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: const FlexColumnWidth(2),
          1: const FlexColumnWidth(1),
          2: const FlexColumnWidth(1),
          3: const FlexColumnWidth(1),
          4: const FlexColumnWidth(1),
        },
        border: TableBorder.all(color: palette.border, width: 0.5),
        children: [
          _buildHeaderRow(l10n, palette),
          ...participants.map(
            (participant) => _buildDataRow(context, participant, l10n, palette),
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow(AppLocalizations l10n, AppPalette palette) {
    Widget buildHeader(String text) {
      return CellBuilder(
        text,
        bold: true,
        align: TextAlign.center,
        l10n: l10n,
        palette: palette,
      );
    }

    return TableRow(
      decoration: const BoxDecoration(),
      children: [
        buildHeader(l10n.evaluationParticipantName),
        buildHeader(l10n.evaluationEffectiveness),
        buildHeader(l10n.evaluationMissRate),
        buildHeader(l10n.evaluationFalseAlarmRate),
        buildHeader(l10n.evaluationStatusHint),
      ],
    );
  }

  TableRow _buildDataRow(
    BuildContext context,
    EvaluationParticipant participant,
    AppLocalizations l10n,
    AppPalette palette,
  ) {
    Widget buildCell(String text, {TextAlign align = TextAlign.center}) {
      return CellBuilder(text, align: align, l10n: l10n, palette: palette);
    }

    final name =
        participant.user?.name ??
        participant.user?.employeeCode ??
        l10n.unknownValue;
    final effectiveness = _formatRate(
      context,
      participant.metrics?.effectiveness,
    );
    final missRate = _formatRate(context, participant.metrics?.missRate);
    final falseAlarmRate = _formatRate(
      context,
      participant.metrics?.falseAlarmRate,
    );
    final statusLabel = participant.isComplete == true
        ? l10n.sessionStatusCompleted
        : l10n.statusIncomplete;

    return TableRow(
      children: [
        buildCell(name, align: TextAlign.left),
        buildCell(effectiveness),
        buildCell(missRate),
        buildCell(falseAlarmRate),
        buildCell(statusLabel),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    AppLocalizations l10n,
    AppPalette palette,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final participant in participants)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: _ParticipantMetricsCard(
              participant: participant,
              l10n: l10n,
              palette: palette,
            ),
          ),
      ],
    );
  }
}

class _ParticipantMetricsCard extends StatelessWidget {
  const _ParticipantMetricsCard({
    required this.participant,
    required this.l10n,
    required this.palette,
  });

  final EvaluationParticipant participant;
  final AppLocalizations l10n;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final name =
        participant.user?.name ??
        participant.user?.employeeCode ??
        l10n.unknownValue;
    final effectiveness = _formatRate(
      context,
      participant.metrics?.effectiveness,
    );
    final missRate = _formatRate(context, participant.metrics?.missRate);
    final falseAlarmRate = _formatRate(
      context,
      participant.metrics?.falseAlarmRate,
    );
    final statusLabel = participant.isComplete == true
        ? l10n.sessionStatusCompleted
        : l10n.statusIncomplete;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTextStyles.title.copyWith(color: palette.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              _MetaItem(
                label: l10n.evaluationEffectiveness,
                value: effectiveness,
              ),
              _MetaItem(label: l10n.evaluationMissRate, value: missRate),
              _MetaItem(
                label: l10n.evaluationFalseAlarmRate,
                value: falseAlarmRate,
              ),
              _MetaItem(label: l10n.evaluationStatusHint, value: statusLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class CellBuilder extends StatelessWidget {
  const CellBuilder(
    this.text, {
    super.key,
    required this.l10n,
    required this.palette,
    this.align = TextAlign.center,
    this.bold = false,
  });

  final String text;
  final AppLocalizations l10n;
  final AppPalette palette;
  final TextAlign align;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        text,
        textAlign: align,
        style: AppTextStyles.body.copyWith(
          color: palette.textPrimary,
          fontWeight: bold ? FontWeight.w600 : null,
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});

  final SessionEvaluationSummary session;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = session.sessionDate;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.token ?? l10n.unknownValue,
              style: AppTextStyles.title.copyWith(color: palette.textPrimary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.xl,
              runSpacing: AppSpacing.md,
              children: [
                _MetaItem(
                  label: l10n.evaluationSessionStatus,
                  value: localizeSessionStatus(l10n, session.status),
                ),
                _MetaItem(
                  label: l10n.evaluationSessionDate,
                  value: date == null
                      ? l10n.unknownValue
                      : DateFormat.yMMMMd(locale).format(date),
                ),
                _MetaItem(
                  label: l10n.evaluationSamplesCount,
                  value: _formatCount(context, session.samplesCount),
                ),
                _MetaItem(
                  label: l10n.evaluationParticipantsCount,
                  value: _formatCount(context, session.participantsCount),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AgreementCard extends StatelessWidget {
  const _AgreementCard({required this.agreement});

  final SessionAgreement? agreement;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final value = agreement;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.evaluationAgreementTitle,
              style: AppTextStyles.sectionTitle.copyWith(
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (value == null)
              Text(
                l10n.evaluationNotAvailable,
                style: AppTextStyles.body.copyWith(
                  color: palette.textSecondary,
                ),
              )
            else ...[
              LayoutBuilder(
                builder: (context, constraints) {
                  final twoColumns = constraints.maxWidth >= 480;
                  final tileWidth = twoColumns
                      ? (constraints.maxWidth - AppSpacing.md) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      SizedBox(
                        width: tileWidth,
                        child: _RateTile(
                          label: l10n.evaluationBetweenAgreement,
                          value: _formatRate(context, value.betweenAgreement),
                          palette: palette,
                        ),
                      ),
                      SizedBox(
                        width: tileWidth,
                        child: _RateTile(
                          label: l10n.evaluationAllVsStandard,
                          value: _formatRate(context, value.allVsStandard),
                          palette: palette,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: [
                  _ContextChip(
                    label: l10n.evaluationComparedSamples,
                    value: _formatCount(context, value.comparedSamples),
                    palette: palette,
                  ),
                  _ContextChip(
                    label: l10n.evaluationExcludedSamples,
                    value: _formatCount(context, value.excludedSamples),
                    palette: palette,
                  ),
                  _ContextChip(
                    label: l10n.evaluationParticipantsCompared,
                    value: _formatCount(context, value.participantsCompared),
                    palette: palette,
                  ),
                ],
              ),
              if (!value.hasRates) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.evaluationAgreementUnavailableHint,
                  style: AppTextStyles.caption.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _RateTile extends StatelessWidget {
  const _RateTile({
    required this.label,
    required this.value,
    required this.palette,
  });

  final String label;
  final String value;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.display.copyWith(
              color: palette.textPrimary,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextChip extends StatelessWidget {
  const _ContextChip({
    required this.label,
    required this.value,
    required this.palette,
  });

  final String label;
  final String value;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.label.copyWith(color: palette.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: palette.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: AppTextStyles.label.copyWith(color: palette.textPrimary),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _MessageState(
      icon: Icons.error_outline,
      message: message,
      action: AppButton(
        label: l10n.actionRetry,
        icon: Icons.refresh,
        expand: false,
        onPressed: onRetry,
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.icon, required this.message, this.action});

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: palette.textSecondary),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              if (action != null) ...[
                const SizedBox(height: AppSpacing.xl),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _formatRate(BuildContext context, double? value) {
  if (value == null) {
    return AppLocalizations.of(context).evaluationNotAvailable;
  }
  final locale = Localizations.localeOf(context).toLanguageTag();
  return '${NumberFormat('0.00', locale).format(value)}%';
}

String _formatCount(BuildContext context, int? value) {
  if (value == null) {
    return AppLocalizations.of(context).unknownValue;
  }
  final locale = Localizations.localeOf(context).toLanguageTag();
  return NumberFormat.decimalPattern(locale).format(value);
}
