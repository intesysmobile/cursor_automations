import 'package:cursor_automations/api/solar_system_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('SolarSystemApi.getBody', () {
    test('parsa il body e converte i campi numerici opzionali', () async {
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          '''
{
  "id": "earth",
  "englishName": "Earth",
  "isPlanet": true,
  "mass": {"massValue": 5.972, "massExponent": 24},
  "vol": {"volValue": 1.08321, "volExponent": 12},
  "gravity": 9.8
}
''',
          200,
        );
      });

      final api = SolarSystemApi(client: client);
      final body = await api.getBody('earth');

      expect(capturedRequest.url.path, '/rest/bodies/earth');
      expect(
        capturedRequest.headers['Authorization'],
        'Bearer $solarSystemApiKey',
      );
      expect(body.id, 'earth');
      expect(body.englishName, 'Earth');
      expect(body.isPlanet, isTrue);
      expect(body.massValue, 5.972);
      expect(body.massExponent, 24);
      expect(body.volValue, 1.08321);
      expect(body.volExponent, 12);
      expect(body.gravity, 9.8);
    });

    test('lancia eccezione quando lo status non è 200', () async {
      final client = MockClient(
        (_) async => http.Response('{"message":"error"}', 500),
      );
      final api = SolarSystemApi(client: client);

      await expectLater(api.getBody('earth'), throwsA(isA<Exception>()));
    });
  });

  group('SolarSystemApi.getPlanets', () {
    test('parsa la lista dei pianeti', () async {
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          '''
{
  "bodies": [
    {"id": "earth", "englishName": "Earth", "isPlanet": true},
    {"id": "mars", "englishName": "Mars", "isPlanet": true}
  ]
}
''',
          200,
        );
      });

      final api = SolarSystemApi(client: client);
      final planets = await api.getPlanets();

      expect(capturedRequest.url.path, '/rest/bodies');
      expect(capturedRequest.url.query, contains('filter%5B%5D=isPlanet%2Ceq%2Ctrue'));
      expect(planets, hasLength(2));
      expect(planets.first.id, 'earth');
      expect(planets.last.englishName, 'Mars');
    });

    test('lancia eccezione quando lo status non è 200', () async {
      final client = MockClient((_) async => http.Response('{}', 404));
      final api = SolarSystemApi(client: client);

      await expectLater(api.getPlanets(), throwsA(isA<Exception>()));
    });
  });

  group('SolarSystemApi.getPositions', () {
    test('passa i parametri corretti e parsa la risposta', () async {
      final date = DateTime.utc(2025, 1, 2, 3, 4, 5);
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          '''
[
  {"name":"Earth","ra":"10h","dec":"20°","az":"135°","alt":"45°"}
]
''',
          200,
        );
      });

      final api = SolarSystemApi(client: client);
      final positions = await api.getPositions(
        latitude: 45.4642,
        longitude: 9.19,
        elevation: 120,
        dateTime: date,
        timeZone: 1,
      );

      expect(capturedRequest.url.path, '/rest/positions');
      expect(capturedRequest.url.queryParameters['lat'], '45.4642');
      expect(capturedRequest.url.queryParameters['lon'], '9.19');
      expect(capturedRequest.url.queryParameters['elev'], '120.0');
      expect(
        capturedRequest.url.queryParameters['datetime'],
        date.toIso8601String(),
      );
      expect(capturedRequest.url.queryParameters['zone'], '1');
      expect(positions, hasLength(1));
      expect(positions.single.name, 'Earth');
      expect(positions.single.az, '135°');
      expect(positions.single.alt, '45°');
    });

    test('lancia eccezione quando lo status non è 200', () async {
      final client = MockClient((_) async => http.Response('[]', 503));
      final api = SolarSystemApi(client: client);

      await expectLater(
        api.getPositions(
          latitude: 0,
          longitude: 0,
          elevation: 0,
          dateTime: DateTime.utc(2024),
          timeZone: 0,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
