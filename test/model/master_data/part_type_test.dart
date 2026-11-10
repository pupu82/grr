import 'package:flutter_test/flutter_test.dart';
import 'package:grr/model/master_data/part_type.dart';

void main() {
  group('PartType.fromJson', () {
    test('parses samples_count when present', () {
      final partType = PartType.fromJson(<String, dynamic>{
        'id': 2,
        'name': 'Bracket',
        'samples_count': 5,
      });

      expect(partType.id, 2);
      expect(partType.name, 'Bracket');
      expect(partType.samplesCount, 5);
    });

    test('keeps samples_count null when omitted', () {
      final partType = PartType.fromJson(<String, dynamic>{
        'id': 2,
        'name': 'Bracket',
      });

      expect(partType.samplesCount, isNull);
    });
  });
}
