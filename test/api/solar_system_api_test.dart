import 'dart:convert';

import 'package:cursor_automations/api/solar_system_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('SolarSystemApi', () {
    test('getBody usa endpoint corretto, header auth e parsing BodyDto', () async {
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode(<String, dynamic>{
            'id': 'earth',
            'englishName': 'Earth',
            'isPlanet': true,
            'mass': <String, dynamic>{'massValue': 5.972, 'massExponent': 24},
            'vol': <String, dynamic>{'volValue': 1.083, 'volExponent': 12},
          }),
          200,
        );
      });

      final api = SolarSystemApi(client: client);
      final body = await api.getBody('earth');

      expect(capturedRequest.method, 'GET');
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
      expect(body.volValue, 1.083);
      expect(body.volExponent, 12);
    });

    test('getBody lancia eccezione su status code non 200', () async {
      final client = MockClient(
        (_) async => http.Response('errore', 500),
      );
      final api = SolarSystemApi(client: client);

      await expectLater(
        () => api.getBody('mars'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'messaggio',
            contains('500'),
          ),
        ),
      );
    });

    test('getPlanets converte la lista bodies con fallback sui campi mancanti',
        () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode(<String, dynamic>{
            'bodies': <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 'earth',
                'englishName': 'Earth',
                'isPlanet': true,
              },
              <String, dynamic>{
                'id': 'unknown',
              },
            ],
          }),
          200,
        );
      });

      final api = SolarSystemApi(client: client);
      final planets = await api.getPlanets();

      expect(planets, hasLength(2));
      expect(planets.first.id, 'earth');
      expect(planets.first.isPlanet, isTrue);
      expect(planets[1].englishName, '');
      expect(planets[1].isPlanet, isFalse);
    });

    test('getPositions usa query params attesi e converte PositionDto', () async {
      final date = DateTime.utc(2026, 1, 2, 3, 4, 5);
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode(<Map<String, dynamic>>[
            <String, dynamic>{
              'name': 'earth',
              'ra': '10h',
              'dec': '20d',
              'az': '120',
              'alt': '45',
            },
          ]),
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
      expect(capturedRequest.url.queryParameters['datetime'], date.toIso8601String());
      expect(capturedRequest.url.queryParameters['zone'], '1');
      expect(positions, hasLength(1));
      expect(positions.single.name, 'earth');
      expect(positions.single.az, '120');
      expect(positions.single.alt, '45');
    });
  });
}
