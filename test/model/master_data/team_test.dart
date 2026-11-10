import 'package:flutter_test/flutter_test.dart';
import 'package:grr/model/master_data/team.dart';

void main() {
  group('Team.fromJson', () {
    test('parses a nested plant relation', () {
      final team = Team.fromJson(<String, dynamic>{
        'id': 4,
        'name': 'Line 1',
        'plant_id': 1,
        'plant': <String, dynamic>{
          'id': 1,
          'code': 'PLT-01',
          'name': 'Plant One',
          'is_active': true,
        },
      });

      expect(team.id, 4);
      expect(team.name, 'Line 1');
      expect(team.plantId, 1);
      expect(team.plant?.code, 'PLT-01');
    });

    test('keeps the plant null when the relation is not loaded', () {
      final team = Team.fromJson(<String, dynamic>{
        'id': 4,
        'name': 'Line 1',
        'plant_id': 1,
      });

      expect(team.plant, isNull);
    });
  });
}
