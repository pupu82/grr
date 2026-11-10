import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/session/session_sample.dart';

void main() {
  group('SessionSample.fromJson', () {
    test('parses the frozen answer key and nested results', () {
      final sample = SessionSample.fromJson(<String, dynamic>{
        'id': 5,
        'session_id': 2,
        'sample_id': 7,
        'answer_key': 'good',
        'position': 1,
        'sample': <String, dynamic>{
          'id': 7,
          'code': 'SMP-01',
          'part_type_id': 2,
        },
        'results': <dynamic>[
          <String, dynamic>{'trial_number': 1, 'verdict': 'good'},
          <String, dynamic>{'trial_number': 2, 'verdict': 'defect'},
        ],
      });

      expect(sample.id, 5);
      expect(sample.sessionId, 2);
      expect(sample.sampleId, 7);
      expect(sample.answerKey, Verdict.good);
      expect(sample.position, 1);
      expect(sample.sample?.code, 'SMP-01');
      expect(sample.results, hasLength(2));
      expect(sample.results[1].verdict, Verdict.defect);
    });

    test('keeps the answer key null when omitted for inspectors', () {
      final sample = SessionSample.fromJson(<String, dynamic>{
        'sample_id': 7,
        'position': 1,
      });

      expect(sample.answerKey, isNull);
    });

    test('requires a position', () {
      expect(
        () => SessionSample.fromJson(<String, dynamic>{'sample_id': 7}),
        throwsFormatException,
      );
    });
  });
}
