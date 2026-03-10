import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/planet_providers.dart';
import '../../providers/planet_remote_providers.dart';
import '../planet_detail/planet_detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planets = ref.watch(planetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema Solare'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: planets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final planet = planets[index];
          final isSun = planet.name == 'Sole';
          final positionAsync = ref.watch(planetPositionProvider(planet));

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isSun
                    ? Colors.amber
                    : Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  planet.name.characters.first,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                planet.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    planet.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  positionAsync.when(
                    data: (position) {
                      if (position == null) {
                        return const Text(
                          'Posizione nel cielo non disponibile',
                          style: TextStyle(fontSize: 12),
                        );
                      }
                      return Text(
                        'Azimut: ${position.az}  ·  Altitudine: ${position.alt}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      );
                    },
                    loading: () => const Text(
                      'Calcolo posizione...',
                      style: TextStyle(fontSize: 12),
                    ),
                    error: (_, __) => const Text(
                      'Errore nel recupero posizione',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PlanetDetailPage(planet: planet),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

