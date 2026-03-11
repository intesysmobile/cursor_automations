import 'package:cursor_automations/api/solar_system_api.dart';
import 'package:cursor_automations/models/planet.dart';
import 'package:cursor_automations/repositories/planets_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlanetsRepository', () {
    test('fetchBodyForPlanet delega all API usando apiId', () async {
      final fakeApi = _FakeSolarSystemApi(
        bodyResult: BodyDto(id: 'earth', englishName: 'Earth', isPlanet: true),
      );
      final repository = PlanetsRepository(fakeApi);
      const planet = Planet(name: 'Terra', description: 'd', apiId: 'earth');

      final body = await repository.fetchBodyForPlanet(planet);

      expect(fakeApi.lastBodyId, 'earth');
      expect(body.id, 'earth');
    });

    test('fetchPositionForPlanet ritorna match case-insensitive', () async {
      final fakeApi = _FakeSolarSystemApi(
        positionsResult: <PositionDto>[
          PositionDto(name: 'mars', ra: '1h', dec: '2d', az: '3', alt: '4'),
          PositionDto(name: 'EARTH', ra: '10h', dec: '20d', az: '130', alt: '50'),
        ],
      );
      final repository = PlanetsRepository(fakeApi);
      const planet = Planet(name: 'Terra', description: 'd', apiId: 'earth');

      final position = await repository.fetchPositionForPlanet(planet);

      expect(position, isNotNull);
      expect(position!.name, 'EARTH');
      expect(fakeApi.lastLatitude, 45.4642);
      expect(fakeApi.lastLongitude, 9.19);
      expect(fakeApi.lastElevation, 120);
      expect(fakeApi.lastTimeZone, 1);
      expect(fakeApi.lastDateTime, isNotNull);
      expect(fakeApi.lastDateTime!.isUtc, isTrue);
    });

    test('fetchPositionForPlanet ritorna null se il pianeta non è presente',
        () async {
      final fakeApi = _FakeSolarSystemApi(
        positionsResult: <PositionDto>[
          PositionDto(name: 'mars', ra: '1h', dec: '2d', az: '3', alt: '4'),
        ],
      );
      final repository = PlanetsRepository(fakeApi);
      const planet = Planet(name: 'Venere', description: 'd', apiId: 'venus');

      final position = await repository.fetchPositionForPlanet(planet);

      expect(position, isNull);
    });
  });
}

class _FakeSolarSystemApi extends SolarSystemApi {
  _FakeSolarSystemApi({
    BodyDto? bodyResult,
    List<PositionDto>? positionsResult,
  })  : _bodyResult = bodyResult ??
            BodyDto(id: 'default', englishName: 'Default', isPlanet: true),
        _positionsResult = positionsResult ?? <PositionDto>[];

  final BodyDto _bodyResult;
  final List<PositionDto> _positionsResult;

  String? lastBodyId;
  double? lastLatitude;
  double? lastLongitude;
  double? lastElevation;
  DateTime? lastDateTime;
  int? lastTimeZone;

  @override
  Future<BodyDto> getBody(String id) async {
    lastBodyId = id;
    return _bodyResult;
  }

  @override
  Future<List<PositionDto>> getPositions({
    required double latitude,
    required double longitude,
    required double elevation,
    required DateTime dateTime,
    required int timeZone,
  }) async {
    lastLatitude = latitude;
    lastLongitude = longitude;
    lastElevation = elevation;
    lastDateTime = dateTime;
    lastTimeZone = timeZone;
    return _positionsResult;
  }
}
