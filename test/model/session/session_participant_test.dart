import 'package:flutter_test/flutter_test.dart';
import 'package:grr/model/session/session_participant.dart';

void main() {
  group('SessionParticipant.fromJson', () {
    test('parses the nested user, trials, results and evaluation', () {
      final participant = SessionParticipant.fromJson(<String, dynamic>{
        'id': 3,
        'session_id': 2,
        'user_id': 8,
        'user': <String, dynamic>{
          'id': 'user-uuid-1',
          'employee_code': 'EMP-0001',
          'name': 'Rina',
          'role': 'inspector',
          'status': 'active',
        },
        'trials': <dynamic>[
          <String, dynamic>{'trial_number': 1},
        ],
        'results': <dynamic>[
          <String, dynamic>{'trial_number': 1, 'verdict': 'good'},
        ],
        'evaluation': <String, dynamic>{
          'repeatability': '90.00',
          'effectiveness': '80.50',
          'miss_rate': '10.00',
          'false_alarm_rate': null,
          'judgement': 'marginal',
        },
      });

      expect(participant.id, 3);
      expect(participant.sessionId, 2);
      expect(participant.userId, 8);
      expect(participant.user?.employeeCode, 'EMP-0001');
      expect(participant.trials, hasLength(1));
      expect(participant.results.single.trialNumber, 1);
      expect(participant.evaluation?.repeatability, 90);
      expect(participant.evaluation?.effectiveness, 80.5);
      expect(participant.evaluation?.missRate, 10);
      expect(participant.evaluation?.falseAlarmRate, isNull);
    });
  });
}
