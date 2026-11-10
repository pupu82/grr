import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/master_data/sample.dart';

void main() {
  group('Sample.fromJson', () {
    test('parses the answer key and nested part type', () {
      final sample = Sample.fromJson(<String, dynamic>{
        'id': 7,
        'code': 'SMP-01',
        'part_type_id': 2,
        'part_type': <String, dynamic>{'id': 2, 'name': 'Bracket'},
        'answer_key': 'defect',
      });

      expect(sample.id, 7);
      expect(sample.code, 'SMP-01');
      expect(sample.partTypeId, 2);
      expect(sample.partType?.name, 'Bracket');
      expect(sample.answerKey, Verdict.defect);
    });

    test('keeps answer_key null when the backend omits it', () {
      final sample = Sample.fromJson(<String, dynamic>{
        'id': 7,
        'code': 'SMP-01',
        'part_type_id': 2,
      });

      expect(sample.answerKey, isNull);
    });

    test('keeps unknown answer keys null', () {
      final sample = Sample.fromJson(<String, dynamic>{
        'id': 7,
        'code': 'SMP-01',
        'part_type_id': 2,
        'answer_key': 'unknown',
      });

      expect(sample.answerKey, isNull);
    });

    test('omits a null answer key when serializing', () {
      const sample = Sample(id: 7, code: 'SMP-01', partTypeId: 2);

      expect(sample.toJson().containsKey('answer_key'), isFalse);
    });
  });
}
