import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/session/inspection_session.dart';

void main() {
  group('InspectionSession.fromJson', () {
    test('parses the session and nested relations', () {
      final session = InspectionSession.fromJson(<String, dynamic>{
        'id': 2,
        'uuid': 'session-uuid-1',
        'token': 'ABCD1234',
        'plant_id': 1,
        'team_id': 4,
        'part_type_id': 2,
        'created_by': 8,
        'session_date': '2026-11-08',
        'trial_count': 3,
        'status': 'in_progress',
        'plant': <String, dynamic>{
          'id': 1,
          'code': 'PLT-01',
          'name': 'Plant One',
        },
        'team': <String, dynamic>{'id': 4, 'name': 'Line 1', 'plant_id': 1},
        'part_type': <String, dynamic>{'id': 2, 'name': 'Bracket'},
        'creator': <String, dynamic>{
          'id': 'user-uuid-1',
          'employee_code': 'EMP-0001',
          'name': 'Rina',
        },
        'session_samples': <dynamic>[
          <String, dynamic>{'position': 1, 'sample_id': 7},
        ],
        'participants': <dynamic>[
          <String, dynamic>{
            'user': <String, dynamic>{
              'id': 'user-uuid-2',
              'employee_code': 'EMP-0002',
              'name': 'Budi',
            },
          },
        ],
        'evaluation': <String, dynamic>{
          'between_agreement': '95.00',
          'all_vs_standard': '88.50',
        },
      });

      expect(session.uuid, 'session-uuid-1');
      expect(session.token, 'ABCD1234');
      expect(session.plantId, 1);
      expect(session.teamId, 4);
      expect(session.partTypeId, 2);
      expect(session.createdBy, 8);
      expect(session.sessionDate, DateTime.parse('2026-11-08'));
      expect(session.trialCount, 3);
      expect(session.status, SessionStatus.inProgress);
      expect(session.plant?.code, 'PLT-01');
      expect(session.team?.name, 'Line 1');
      expect(session.partType?.name, 'Bracket');
      expect(session.creator?.employeeCode, 'EMP-0001');
      expect(session.sessionSamples, hasLength(1));
      expect(session.participants.single.user?.name, 'Budi');
      expect(session.evaluation?.betweenAgreement, 95);
      expect(session.evaluation?.allVsStandard, 88.5);
    });

    test('keeps an unknown status null', () {
      final session = InspectionSession.fromJson(<String, dynamic>{
        'uuid': 'session-uuid-1',
        'token': 'ABCD1234',
        'plant_id': 1,
        'team_id': 4,
        'part_type_id': 2,
        'session_date': '2026-11-08',
        'trial_count': 1,
        'status': 'archived',
      });

      expect(session.status, isNull);
      expect(session.sessionSamples, isEmpty);
      expect(session.participants, isEmpty);
    });

    test('requires the public uuid', () {
      expect(
        () => InspectionSession.fromJson(<String, dynamic>{
          'token': 'ABCD1234',
          'plant_id': 1,
          'team_id': 4,
          'part_type_id': 2,
          'session_date': '2026-11-08',
          'trial_count': 1,
        }),
        throwsFormatException,
      );
    });
  });
}
