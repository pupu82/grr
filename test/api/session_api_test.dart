import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grr/api/session_api.dart';
import 'package:grr/utils/app_exception.dart';

import '../helpers/stub_http_adapter.dart';

SessionApi _api(StubHandler handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test/api/v1'))
    ..httpClientAdapter = StubHttpAdapter(handler);
  return SessionApi(dio);
}

void main() {
  group('SessionApi.fetchEvaluation', () {
    test('gets the session evaluation path and parses the result', () async {
      late RequestOptions captured;
      final api = _api((options) async {
        captured = options;
        return jsonResponse(<String, dynamic>{
          'data': <String, dynamic>{
            'session': <String, dynamic>{
              'id': '6c1f0f7e-0000-0000-0000-000000000001',
              'token': 'SES-2026-0001',
              'status': 'completed',
              'session_date': '2026-11-12',
              'response_time_limit_ms': 90000,
              'started_at': '2026-11-12T08:00:00+00:00',
              'completed_at': '2026-11-12T09:00:00+00:00',
              'samples_count': 20,
              'participants_count': 1,
            },
            'participants': <Map<String, dynamic>>[
              <String, dynamic>{
                'participant_id': 7,
                'user': <String, dynamic>{
                  'id': '0f1c7c1e-0000-0000-0000-000000000001',
                  'employee_code': 'EMP-1000',
                  'name': 'Siti Inspector',
                },
                'started_at': '2026-11-12T08:00:00+00:00',
                'completed_at': '2026-11-12T08:40:00+00:00',
                'is_complete': true,
                'metrics': <String, dynamic>{
                  'effectiveness': '95.00',
                  'miss_rate': '10.00',
                  'false_alarm_rate': '0.00',
                  'decisions': 19,
                  'correct_decisions': 18,
                  'defect_decisions': 10,
                  'good_decisions': 9,
                  'missed_defects': 1,
                  'false_alarms': 0,
                  'timed_out_samples': 1,
                },
              },
            ],
            'agreement': <String, dynamic>{
              'participants_compared': 1,
              'compared_samples': 19,
              'excluded_samples': 1,
              'between_agreement': '90.00',
              'all_vs_standard': '45.50',
            },
          },
        });
      });

      final result = await api.fetchEvaluation(
        '6c1f0f7e-0000-0000-0000-000000000001',
      );

      expect(captured.method, 'GET');
      expect(
        captured.path,
        '/sessions/6c1f0f7e-0000-0000-0000-000000000001/evaluation',
      );
      expect(result.session, isNotNull);
      expect(result.agreement, isNotNull);
      expect(result.agreement!.betweenAgreement, 90);
      expect(result.agreement!.allVsStandard, 45.5);
      expect(result.agreement!.comparedSamples, 19);
      expect(result.agreement!.excludedSamples, 1);
      expect(result.agreement!.participantsCompared, 1);
      expect(result.participants.length, 1);

      final participant = result.participants.single;
      expect(participant.participantId, 7);
      expect(participant.user?.employeeCode, 'EMP-1000');
      expect(participant.isComplete, isTrue);
      expect(participant.metrics, isNotNull);
      expect(participant.metrics!.effectiveness, 95.0);
      expect(participant.metrics!.missRate, 10.0);
      expect(participant.metrics!.falseAlarmRate, 0.0);
      expect(participant.metrics!.decisions, 19);
      expect(participant.metrics!.correctDecisions, 18);
      expect(participant.metrics!.defectDecisions, 10);
      expect(participant.metrics!.goodDecisions, 9);
      expect(participant.metrics!.missedDefects, 1);
      expect(participant.metrics!.falseAlarms, 0);
      expect(participant.metrics!.timedOutSamples, 1);
    });

    test(
      'maps a non-object response payload to an invalid response error',
      () async {
        final api = _api((options) async {
          return jsonResponse('not a json map');
        });

        await expectLater(
          api.fetchEvaluation('uuid'),
          throwsA(
            isA<AppException>().having(
              (error) => error.kind,
              'kind',
              AppExceptionKind.invalidResponse,
            ),
          ),
        );
      },
    );
  });
}
