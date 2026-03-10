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

    // L'API ritorna un elenco di corpi (Sole, pianeti, ecc.). Cerchiamo
    // quello il cui nome inglese corrisponde all'id del pianeta.
    final match = positions.where(
      (p) => p.name.toLowerCase() == planet.apiId.toLowerCase(),
    );

    if (match.isEmpty) {
      return null;
    }

    return match.first;
  }
}

