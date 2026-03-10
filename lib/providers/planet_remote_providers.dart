import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/solar_system_api.dart';
import '../models/planet.dart';
import '../repositories/planets_repository.dart';

final solarSystemApiProvider = Provider<SolarSystemApi>(
  (ref) => SolarSystemApi(),
);

final planetsRepositoryProvider = Provider<PlanetsRepository>(
  (ref) => PlanetsRepository(ref.watch(solarSystemApiProvider)),
);

final planetDetailProvider =
    FutureProvider.family<BodyDto?, Planet>((ref, planet) async {
  final repo = ref.watch(planetsRepositoryProvider);

  try {
    return await repo.fetchBodyForPlanet(planet);
  } catch (_) {
    return null;
  }
});

final planetPositionProvider =
    FutureProvider.family<PositionDto?, Planet>((ref, planet) async {
  final repo = ref.watch(planetsRepositoryProvider);

  try {
    return await repo.fetchPositionForPlanet(planet);
  } catch (_) {
    return null;
  }
});

