import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/report/grr_evaluation.dart';

void main() {
  group('GrrEvaluation.fromJson', () {
    test('parses decimal metrics encoded as strings', () {
      final evaluation = GrrEvaluation.fromJson(<String, dynamic>{
        'id': 1,
        'participant_id': 3,
        'repeatability': '95.25',
        'effectiveness': '90.00',
        'miss_rate': '5.50',
        'false_alarm_rate': '4.25',
        'judgement': 'acceptable',
        'thresholds': <String, dynamic>{'effectiveness': 90},
        'computed_at': '2026-11-08T07:30:00+00:00',
      });

      expect(evaluation.repeatability, 95.25);
      expect(evaluation.effectiveness, 90);
      expect(evaluation.missRate, 5.5);
      expect(evaluation.falseAlarmRate, 4.25);
      expect(evaluation.judgement, Judgement.acceptable);
      expect(evaluation.thresholds?['effectiveness'], 90);
      expect(
        evaluation.computedAt,
        DateTime.parse('2026-11-08T07:30:00+00:00'),
      );
    });

    test('keeps unavailable metrics and unknown judgement null', () {
      final evaluation = GrrEvaluation.fromJson(<String, dynamic>{
        'repeatability': '90.00',
        'effectiveness': '80.00',
        'miss_rate': null,
        'false_alarm_rate': null,
        'judgement': 'unknown',
      });

      expect(evaluation.missRate, isNull);
      expect(evaluation.falseAlarmRate, isNull);
      expect(evaluation.judgement, isNull);
    });

    test('accepts numeric metrics', () {
      final evaluation = GrrEvaluation.fromJson(<String, dynamic>{
        'repeatability': 90,
        'effectiveness': 80.5,
      });

      expect(evaluation.repeatability, 90);
      expect(evaluation.effectiveness, 80.5);
    });
  });
}
