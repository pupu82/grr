import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/session/inspection_result.dart';

void main() {
  group('InspectionResult.fromJson', () {
    test('parses the verdict and trial number', () {
      final result = InspectionResult.fromJson(<String, dynamic>{
        'id': 12,
        'participant_id': 3,
        'session_sample_id': 5,
        'trial_number': 2,
        'verdict': 'good',
      });

      expect(result.id, 12);
      expect(result.participantId, 3);
      expect(result.sessionSampleId, 5);
      expect(result.trialNumber, 2);
      expect(result.verdict, Verdict.good);
    });

    test('keeps an unknown verdict null', () {
      final result = InspectionResult.fromJson(<String, dynamic>{
        'trial_number': 1,
        'verdict': 'unknown',
      });

      expect(result.verdict, isNull);
    });

    test('requires a trial number', () {
      expect(
        () => InspectionResult.fromJson(<String, dynamic>{}),
        throwsFormatException,
      );
    });
  });
}
