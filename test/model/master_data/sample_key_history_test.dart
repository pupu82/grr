import 'package:flutter_test/flutter_test.dart';
import 'package:grr/constants/app_enums.dart';
import 'package:grr/model/master_data/sample_key_history.dart';

void main() {
  group('SampleKeyHistory.fromJson', () {
    test('parses the actor and key transition', () {
      final history = SampleKeyHistory.fromJson(<String, dynamic>{
        'id': 9,
        'sample_id': 7,
        'old_key': 'good',
        'new_key': 'defect',
        'changed_by': 'user-uuid-1',
        'changed_by_name': 'Rina',
        'changed_at': '2026-11-08T07:30:00+00:00',
      });

      expect(history.id, 9);
      expect(history.sampleId, 7);
      expect(history.oldKey, Verdict.good);
      expect(history.newKey, Verdict.defect);
      expect(history.changedBy, 'user-uuid-1');
      expect(history.changedByName, 'Rina');
      expect(history.changedAt, DateTime.parse('2026-11-08T07:30:00+00:00'));
    });

    test('keeps unknown keys null', () {
      final history = SampleKeyHistory.fromJson(<String, dynamic>{
        'id': 9,
        'sample_id': 7,
        'old_key': 'unknown',
        'new_key': 'defect',
      });

      expect(history.oldKey, isNull);
      expect(history.newKey, Verdict.defect);
    });
  });
}
