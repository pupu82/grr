import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grr/api/session_api.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/report/session_evaluation_result.dart';
import 'package:grr/store/sessions/session_evaluation_store.dart';

import '../../helpers/stub_http_adapter.dart';

SessionEvaluationStore _store(StubHandler handler) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test/api/v1'))
    ..httpClientAdapter = StubHttpAdapter(handler);
  return SessionEvaluationStore(api: SessionApi(dio));
}

void main() {
  group('SessionEvaluationStore', () {
    test('loads a successful evaluation and exposes the agreement', () async {
      final store = _store((options) async {
        return jsonResponse(<String, dynamic>{
          'data': <String, dynamic>{
            'agreement': <String, dynamic>{
              'participants_compared': 2,
              'compared_samples': 2,
              'excluded_samples': 0,
              'between_agreement': '80.00',
              'all_vs_standard': '40.00',
            },
          },
        });
      });

      expect(store.status, SessionEvaluationStatus.idle);

      await store.load('6c1f0f7e-0000-0000-0000-000000000001');

      expect(store.status, SessionEvaluationStatus.success);
      expect(store.sessionId, '6c1f0f7e-0000-0000-0000-000000000001');
      expect(store.result, isA<SessionEvaluationResult>());
      expect(store.error, isNull);
      expect(store.result!.agreement!.betweenAgreement, 80);
      expect(store.result!.agreement!.allVsStandard, 40);
    });

    test('keeps an error state when the backend forbids the session', () async {
      final store = _store((options) async {
        return jsonResponse(<String, dynamic>{
          'message': 'Evaluation is not allowed.',
          'code': 'forbidden',
        }, statusCode: 403);
      });

      await store.load('uuid');

      expect(store.status, SessionEvaluationStatus.error);
      expect(store.error!.code, ErrorCode.forbidden);
      expect(store.result, isNull);
    });

    test('clears the state', () async {
      final store = _store((options) async {
        return jsonResponse(<String, dynamic>{'data': <String, dynamic>{}});
      });

      await store.load('uuid');
      expect(store.status, SessionEvaluationStatus.success);

      store.clear();

      expect(store.status, SessionEvaluationStatus.idle);
      expect(store.result, isNull);
      expect(store.error, isNull);
    });
  });
}
