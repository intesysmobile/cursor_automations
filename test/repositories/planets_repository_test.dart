import 'package:cursor_automations/api/solar_system_api.dart';
import 'package:cursor_automations/models/planet.dart';
import 'package:cursor_automations/repositories/planets_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const earth = Planet(
    name: 'Terra',
    description: 'desc',
    apiId: 'earth',
  );

  group('PlanetsRepository', () {
    test('fetchBodyForPlanet delega all\'API usando apiId', () async {
      String? capturedId;
      final fakeApi = _FakeSolarSystemApi(
        onGetBody: (id) async {
          capturedId = id;
          return BodyDto(id: id, englishName: 'Earth', isPlanet: true);
        },
      );
      final repository = PlanetsRepository(fakeApi);

      final body = await repository.fetchBodyForPlanet(earth);

      expect(capturedId, 'earth');
      expect(body.id, 'earth');
      expect(body.englishName, 'Earth');
    });

    test('fetchPositionForPlanet effettua match case-insensitive', () async {
      final fakeApi = _FakeSolarSystemApi(
        onGetPositions: () async => <PositionDto>[
          PositionDto(name: 'Mars', ra: '0', dec: '0', az: '0', alt: '0'),
          PositionDto(name: 'EARTH', ra: '10h', dec: '20°', az: '130°', alt: '40°'),
        ],
      );
      final repository = PlanetsRepository(fakeApi);

      final position = await repository.fetchPositionForPlanet(earth);

      expect(position, isNotNull);
      expect(position!.name, 'EARTH');
      expect(position.az, '130°');
    });

    test('fetchPositionForPlanet ritorna null se nessun pianeta combacia', () async {
      final fakeApi = _FakeSolarSystemApi(
        onGetPositions: () async => <PositionDto>[
          PositionDto(name: 'Venus', ra: '0', dec: '0', az: '0', alt: '0'),
        ],
      );
      final repository = PlanetsRepository(fakeApi);

      final position = await repository.fetchPositionForPlanet(earth);

      expect(position, isNull);
    });
  });
}

class _FakeSolarSystemApi implements SolarSystemApi {
  _FakeSolarSystemApi({
    this.onGetBody,
    this.onGetPositions,
  });

  final Future<BodyDto> Function(String id)? onGetBody;
  final Future<List<PositionDto>> Function()? onGetPositions;

  @override
  Future<BodyDto> getBody(String id) async {
    if (onGetBody != null) {
      return onGetBody!(id);
    }
    throw UnimplementedError('onGetBody non configurato');
  }

  @override
  Future<List<BodyDto>> getPlanets() {
    throw UnimplementedError();
  }

  @override
  Future<List<PositionDto>> getPositions({
    required double latitude,
    required double longitude,
    required double elevation,
    required DateTime dateTime,
    required int timeZone,
  }) async {
    if (onGetPositions != null) {
      return onGetPositions!();
    }
    throw UnimplementedError('onGetPositions non configurato');
  }
}
