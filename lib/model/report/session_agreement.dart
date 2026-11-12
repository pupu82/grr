import 'package:flutter/foundation.dart';

import '../../constants/app_enums.dart';
import '../model_json.dart';

/// Session-level agreement metrics.
@immutable
class SessionAgreement {
  const SessionAgreement({
    this.participantsCompared,
    this.comparedSamples,
    this.excludedSamples,
    this.betweenAgreement,
    this.allVsStandard,
    this.judgement,
  });

  factory SessionAgreement.fromJson(Map<String, dynamic> json) {
    return SessionAgreement(
      participantsCompared: readInt(json, 'participants_compared'),
      comparedSamples: readInt(json, 'compared_samples'),
      excludedSamples: readInt(json, 'excluded_samples'),
      betweenAgreement: readDecimal(json, 'between_agreement'),
      allVsStandard: readDecimal(json, 'all_vs_standard'),
      judgement: Judgement.tryParse(json['judgement']),
    );
  }

  final int? participantsCompared;
  final int? comparedSamples;
  final int? excludedSamples;
  final double? betweenAgreement;
  final double? allVsStandard;
  final Judgement? judgement;

  bool get hasRates => betweenAgreement != null || allVsStandard != null;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    putIfNotNull(json, 'participants_compared', participantsCompared);
    putIfNotNull(json, 'compared_samples', comparedSamples);
    putIfNotNull(json, 'excluded_samples', excludedSamples);
    putIfNotNull(json, 'between_agreement', betweenAgreement);
    putIfNotNull(json, 'all_vs_standard', allVsStandard);
    putIfNotNull(json, 'judgement', judgement?.apiValue);
    return json;
  }
}
