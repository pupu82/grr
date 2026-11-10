import 'package:flutter_test/flutter_test.dart';
import 'package:grr/model/session/inspector_trial.dart';

void main() {
  group('InspectorTrial.fromJson', () {
    test('parses timestamps and the trial number', () {
      final trial = InspectorTrial.fromJson(<String, dynamic>{
        'id': 1,
        'participant_id': 3,
        'trial_number': 1,
        'started_at': '2026-11-08T07:30:00+00:00',
        'submitted_at': '2026-11-08T07:45:00+00:00',
      });

      expect(trial.id, 1);
      expect(trial.participantId, 3);
      expect(trial.trialNumber, 1);
      expect(trial.startedAt, DateTime.parse('2026-11-08T07:30:00+00:00'));
      expect(trial.submittedAt, DateTime.parse('2026-11-08T07:45:00+00:00'));
    });

    test('keeps submitted_at null while the trial is open', () {
      final trial = InspectorTrial.fromJson(<String, dynamic>{
        'trial_number': 2,
      });

      expect(trial.submittedAt, isNull);
    });
  });
}
