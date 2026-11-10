import 'package:flutter_test/flutter_test.dart';
import 'package:grr/model/master_data/plant.dart';

void main() {
  group('Plant.fromJson', () {
    test('parses the contract fields', () {
      final plant = Plant.fromJson(<String, dynamic>{
        'id': 1,
        'code': 'PLT-01',
        'name': 'Plant One',
        'is_active': true,
        'created_at': '2026-11-08T07:30:00+00:00',
      });

      expect(plant.id, 1);
      expect(plant.code, 'PLT-01');
      expect(plant.name, 'Plant One');
      expect(plant.isActive, isTrue);
      expect(plant.createdAt, DateTime.parse('2026-11-08T07:30:00+00:00'));
    });

    test('defaults is_active to true when omitted', () {
      final plant = Plant.fromJson(<String, dynamic>{
        'id': 1,
        'code': 'PLT-01',
        'name': 'Plant One',
      });

      expect(plant.isActive, isTrue);
    });

    test('rejects a payload without an id', () {
      expect(
        () => Plant.fromJson(<String, dynamic>{
          'code': 'PLT-01',
          'name': 'Plant One',
        }),
        throwsFormatException,
      );
    });

    test('serializes back to backend field names', () {
      const plant = Plant(id: 1, code: 'PLT-01', name: 'Plant One');

      expect(plant.toJson(), <String, dynamic>{
        'id': 1,
        'code': 'PLT-01',
        'name': 'Plant One',
        'is_active': true,
      });
    });
  });
}
