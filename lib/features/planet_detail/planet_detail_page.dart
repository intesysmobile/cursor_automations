import 'package:flutter/material.dart';

import '../../models/planet.dart';

class PlanetDetailPage extends StatelessWidget {
  const PlanetDetailPage({
    super.key,
    required this.planet,
  });

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planet.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                _assetPathForPlanet(planet.name),
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              planet.name == 'Sole'
                  ? 'Descrizione della stella'
                  : 'Descrizione del pianeta',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              planet.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

String _assetPathForPlanet(String name) {
  switch (name) {
    case 'Sole':
      return 'assets/sun_50-4331c9c0-cd5d-421c-b2e0-3235b0e57fc0.png';
    case 'Mercurio':
      return 'assets/mercury_50-bd589df5-e984-4603-8b1d-564b1a90d549.png';
    case 'Venere':
      return 'assets/venus_50-e2a2ecea-7910-4148-8eb2-bb8a6155af8b.png';
    case 'Terra':
      return 'assets/earth_50-30d00b6a-53bc-4523-94b9-dfd108d6b5c9.png';
    case 'Marte':
      return 'assets/mars_50-bd9e43da-5190-4579-ab46-7c893acd5352.png';
    case 'Giove':
      return 'assets/jupiter_50-25fecc15-199d-4125-a0fd-362338ca4243.png';
    case 'Saturno':
      return 'assets/saturn_50-b3fa00c8-8c13-4b11-b652-3909d664d5e5.png';
    case 'Urano':
      return 'assets/uranus_50-f8d6b9dc-316a-4d47-a9e5-9cee60d287c9.png';
    case 'Nettuno':
      return 'assets/neptune_50-218dd2b9-5fac-4330-89f1-796e381a5455.png';
    default:
      return 'assets/earth_50-30d00b6a-53bc-4523-94b9-dfd108d6b5c9.png';
  }
}


