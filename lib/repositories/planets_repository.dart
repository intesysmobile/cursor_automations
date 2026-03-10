import '../api/solar_system_api.dart';
import '../models/planet.dart';

class PlanetsRepository {
  PlanetsRepository(this._api);

  final SolarSystemApi _api;

  Future<BodyDto> fetchBodyForPlanet(Planet planet) {
    return _api.getBody(planet.apiId);
  }

  Future<PositionDto?> fetchPositionForPlanet(Planet planet) async {
    // Parametri di esempio per l'osservatore: Milano circa.
    final DateTime now = DateTime.now().toUtc();

    final positions = await _api.getPositions(
      latitude: 45.4642,
      longitude: 9.19,
      elevation: 120,
      dateTime: now,
      timeZone: 1,
    );

    // L'API ritorna un elenco di corpi (Sole, pianeti, ecc.).
    // Usiamo il nome inglese standard per il matching, indipendentemente
    // dall'id francese usato per /bodies.
    final englishName = _englishNameForPlanet(planet);

    final match = positions.where(
      (p) => p.name.toLowerCase() == englishName.toLowerCase(),
    );

    if (match.isEmpty) {
      return null;
    }

    return match.first;
  }
}

String _englishNameForPlanet(Planet planet) {
  switch (planet.name) {
    case 'Sole':
      return 'Sun';
    case 'Mercurio':
      return 'Mercury';
    case 'Venere':
      return 'Venus';
    case 'Terra':
      return 'Earth';
    case 'Marte':
      return 'Mars';
    case 'Giove':
      return 'Jupiter';
    case 'Saturno':
      return 'Saturn';
    case 'Urano':
      return 'Uranus';
    case 'Nettuno':
      return 'Neptune';
    default:
      return planet.apiId;
  }
}


