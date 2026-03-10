import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/planet.dart';

final planetsProvider = Provider<List<Planet>>(
  (ref) => const [
    Planet(
      name: 'Sole',
      description:
          'La stella al centro del Sistema Solare, fonte primaria di luce e calore.',
      apiId: 'sun',
    ),
    Planet(
      name: 'Mercurio',
      description:
          'Il pianeta più interno e più piccolo, con escursioni termiche estreme.',
      apiId: 'mercury',
    ),
    Planet(
      name: 'Venere',
      description:
          'Pianeta ricoperto da una densa atmosfera, il più caldo del Sistema Solare.',
      apiId: 'venus',
    ),
    Planet(
      name: 'Terra',
      description:
          'Il nostro pianeta, l’unico noto a ospitare la vita, ricco di acqua liquida.',
      apiId: 'earth',
    ),
    Planet(
      name: 'Marte',
      description:
          'Il pianeta rosso, con vulcani giganti e valli profonde, possibile sede di vita passata.',
      apiId: 'mars',
    ),
    Planet(
      name: 'Giove',
      description:
          'Il più grande pianeta del Sistema Solare, un gigante gassoso con la Grande Macchia Rossa.',
      apiId: 'jupiter',
    ),
    Planet(
      name: 'Saturno',
      description:
          'Famoso per i suoi spettacolari anelli di ghiaccio e roccia.',
      apiId: 'saturn',
    ),
    Planet(
      name: 'Urano',
      description:
          'Gigante ghiacciato che ruota quasi “sdraiato” sul proprio fianco.',
      apiId: 'uranus',
    ),
    Planet(
      name: 'Nettuno',
      description:
          'Gigante ghiacciato più esterno, noto per i suoi forti venti e il colore blu intenso.',
      apiId: 'neptune',
    ),
  ],
);

