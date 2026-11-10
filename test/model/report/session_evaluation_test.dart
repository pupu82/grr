import 'package:flutter_test/flutter_test.dart';
import 'package:grr/model/report/session_evaluation.dart';

void main() {
  group('SessionEvaluation.fromJson', () {
    test('parses decimal metrics encoded as strings', () {
      final evaluation = SessionEvaluation.fromJson(<String, dynamic>{
        'id': 1,
        'session_id': 2,
        'between_agreement': '92.50',
        'all_vs_standard': '88.75',
        'computed_at': '2026-11-08T07:30:00+00:00',
      });

      expect(evaluation.id, 1);
      expect(evaluation.sessionId, 2);
      expect(evaluation.betweenAgreement, 92.5);
      expect(evaluation.allVsStandard, 88.75);
      expect(
        evaluation.computedAt,
        DateTime.parse('2026-11-08T07:30:00+00:00'),
      );
    });

    test('keeps unavailable metrics null', () {
      final evaluation = SessionEvaluation.fromJson(<String, dynamic>{
        'between_agreement': null,
        'all_vs_standard': null,
      });

      expect(evaluation.betweenAgreement, isNull);
      expect(evaluation.allVsStandard, isNull);
    });
  });
}
