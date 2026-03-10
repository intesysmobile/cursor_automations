import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/planet.dart';
import '../../providers/planet_remote_providers.dart';

class PlanetDetailPage extends ConsumerWidget {
  const PlanetDetailPage({
    super.key,
    required this.planet,
  });

  final Planet planet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final longDescription = _longDescriptionForPlanet(planet.name);
    final bodyAsync = ref.watch(planetDetailProvider(planet));
    final positionAsync = ref.watch(planetPositionProvider(planet));

    return Scaffold(
      appBar: AppBar(
        title: Text(planet.name),
      ),
      body: SingleChildScrollView(
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
            if (longDescription != null) ...[
              const SizedBox(height: 24),
              Text(
                'Approfondimento',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                longDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Dati dall’API',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            bodyAsync.when(
              data: (body) {
                if (body == null) {
                  return const Text('Dati non disponibili.');
                }

                final entries = <_InfoRowData>[
                  _InfoRowData('ID', body.id),
                  _InfoRowData('Nome inglese', body.englishName),
                  _InfoRowData('Tipo corpo', body.bodyType),
                  _InfoRowData('Pianeta', body.isPlanet ? 'Sì' : 'No'),
                  _InfoRowData('Raggio medio (km)', body.meanRadius),
                  _InfoRowData('Raggio equatoriale (km)', body.equaRadius),
                  _InfoRowData('Raggio polare (km)', body.polarRadius),
                  _InfoRowData('Schacciamento', body.flattening),
                  _InfoRowData('Dimensione', body.dimension),
                  _InfoRowData('Semiasse maggiore (km)', body.semimajorAxis),
                  _InfoRowData('Perielio (km)', body.perihelion),
                  _InfoRowData('Afelio (km)', body.aphelion),
                  _InfoRowData('Eccentricità', body.eccentricity),
                  _InfoRowData('Inclinazione (°)', body.inclination),
                  _InfoRowData(
                    'Massa (10^n kg)',
                    body.massValue != null && body.massExponent != null
                        ? '${body.massValue}e${body.massExponent}'
                        : null,
                  ),
                  _InfoRowData(
                    'Volume (10^n km³)',
                    body.volValue != null && body.volExponent != null
                        ? '${body.volValue}e${body.volExponent}'
                        : null,
                  ),
                  _InfoRowData('Densità (g/cm³)', body.density),
                  _InfoRowData('Gravità (m/s²)', body.gravity),
                  _InfoRowData('Velocità di fuga (m/s)', body.escape),
                  _InfoRowData('Orbita siderale (giorni)', body.sideralOrbit),
                  _InfoRowData('Rotazione siderale (ore)', body.sideralRotation),
                  _InfoRowData('Inclinazione assiale (°)', body.axialTilt),
                  _InfoRowData('Temperatura media (K)', body.avgTemp),
                  _InfoRowData('Scoperto da', body.discoveredBy),
                  _InfoRowData('Data scoperta', body.discoveryDate),
                ].where((e) => e.value != null && e.value.toString().isNotEmpty).toList();

                if (entries.isEmpty) {
                  return const Text('Nessun dato dettagliato disponibile.');
                }

                return Column(
                  children: entries
                      .map(
                        (e) => _InfoRow(
                          label: e.label,
                          value: e.value!.toString(),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => const Text('Errore nel recupero dei dati.'),
            ),
            const SizedBox(height: 16),
            Text(
              'Posizione nel cielo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            positionAsync.when(
              data: (position) {
                if (position == null) {
                  return const Text('Posizione non disponibile.');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(label: 'Ascensione retta', value: position.ra),
                    _InfoRow(label: 'Declinazione', value: position.dec),
                    _InfoRow(label: 'Azimut', value: position.az),
                    _InfoRow(label: 'Altitudine', value: position.alt),
                  ],
                );
              },
              loading: () => const Text('Calcolo posizione...'),
              error: (_, __) => const Text('Errore nel recupero della posizione.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRowData {
  _InfoRowData(this.label, this.value);

  final String label;
  final Object? value;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
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

String? _longDescriptionForPlanet(String name) {
  switch (name) {
    case 'Sole':
      return '''Il Sole è una stella di tipo spettrale G2V situata al centro del Sistema Solare. Ha un diametro di circa 1,39 milioni di km e rappresenta oltre il 99,8% della massa totale del sistema. Produce energia attraverso la fusione nucleare dell’idrogeno in elio nel suo nucleo, generando radiazione e vento solare che influenzano tutti i corpi planetari.''';
    case 'Mercurio':
      return '''Mercurio è il pianeta più vicino al Sole e il più piccolo del Sistema Solare, con un diametro di circa 4.879 km. Completa un’orbita attorno al Sole in 88 giorni terrestri. La sua superficie è fortemente craterizzata e priva di una vera atmosfera, con temperature che variano da circa −180 °C a +430 °C.''';
    case 'Venere':
      return '''Venere è il secondo pianeta dal Sole e ha dimensioni simili alla Terra, con un diametro di circa 12.104 km. Possiede una densa atmosfera composta principalmente da anidride carbonica e nubi di acido solforico. Il forte effetto serra produce temperature superficiali medie di circa 465 °C, rendendolo il pianeta più caldo del Sistema Solare.''';
    case 'Terra':
      return '''La Terra è il terzo pianeta dal Sole e l’unico conosciuto a ospitare vita. Ha un diametro di circa 12.742 km e un’atmosfera composta principalmente da azoto e ossigeno. Circa il 71% della sua superficie è coperto da acqua. Possiede una magnetosfera che protegge il pianeta dalle radiazioni solari e un satellite naturale: la Luna.''';
    case 'Marte':
      return '''Marte è il quarto pianeta dal Sole ed è noto come pianeta rosso per la presenza di ossidi di ferro nel suolo. Ha un diametro di circa 6.779 km e un’atmosfera sottile composta principalmente da anidride carbonica. Presenta importanti strutture geologiche come Olympus Mons, il vulcano più grande del Sistema Solare, e Valles Marineris, un vasto sistema di canyon.''';
    case 'Giove':
      return '''Giove è il pianeta più grande del Sistema Solare, con un diametro di circa 143.000 km. È un gigante gassoso composto principalmente da idrogeno ed elio. La sua atmosfera è caratterizzata da bande nuvolose e tempeste gigantesche, tra cui la Grande Macchia Rossa. Possiede numerosi satelliti naturali, tra cui Io, Europa, Ganimede e Callisto.''';
    case 'Saturno':
      return '''Saturno è un gigante gassoso con un diametro di circa 120.500 km ed è famoso per il suo esteso sistema di anelli composti da ghiaccio e particelle rocciose. La sua atmosfera è composta prevalentemente da idrogeno ed elio. Tra le sue lune più importanti vi sono Titano, dotato di una densa atmosfera, ed Encelado, noto per i suoi geyser di ghiaccio.''';
    case 'Urano':
      return '''Urano è un gigante ghiacciato con un diametro di circa 50.700 km. È caratterizzato da una forte inclinazione dell’asse di rotazione, circa 98°, che lo fa apparire come se ruotasse su un fianco. La sua atmosfera è composta da idrogeno, elio e metano, che conferisce al pianeta il caratteristico colore azzurro-verde.''';
    case 'Nettuno':
      return '''Nettuno è l’ottavo pianeta del Sistema Solare e il più distante dal Sole. Ha un diametro di circa 49.200 km ed è un gigante ghiacciato simile a Urano. La sua atmosfera è dinamica e presenta venti estremamente veloci, che possono superare i 2.000 km/h. Il suo satellite più grande è Tritone, che mostra attività criovulcanica.''';
    default:
      return null;
  }
}



