// lib/features/planets/planets_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../data/models/planet_model.dart';
import '../../providers/planet_provider.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/top_app_bar_widget.dart';

class PlanetsScreen extends StatefulWidget {
  const PlanetsScreen({super.key});

  @override
  State<PlanetsScreen> createState() => _PlanetsScreenState();
}

class _PlanetsScreenState extends State<PlanetsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlanetProvider>().loadPlanets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanetProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: TopAppBarWidget(
            title: 'Daftar Planet',
            withSearch: true,
            searchQuery: provider.searchQuery,
            onSearchQueryChange: provider.updateSearchQuery,
          ),
          body: _buildBody(provider),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final added =
              await context.push<bool>(RouteConstants.planetsAdd);
              if (added == true && context.mounted) {
                provider.loadPlanets();
              }
            },
            tooltip: 'Tambah Planet',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(PlanetProvider provider) {
    return switch (provider.status) {
      PlanetStatus.loading || PlanetStatus.initial => const LoadingWidget(),
      PlanetStatus.error => AppErrorWidget(
        message: provider.errorMessage,
        onRetry: () => provider.loadPlanets(),
      ),
      PlanetStatus.success => _PlanetsBody(
        planets: provider.planets,
        onOpen: (id) => context.go(RouteConstants.planetsDetail(id)),
      ),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body: daftar planet
// ─────────────────────────────────────────────────────────────────────────────

class _PlanetsBody extends StatelessWidget {
  const _PlanetsBody({required this.planets, required this.onOpen});

  final List<PlanetModel> planets;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    if (planets.isEmpty) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.public_off_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tidak ada data planet!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<PlanetProvider>().loadPlanets(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: planets.length,
        itemBuilder: (context, index) {
          return _PlanetItemCard(
            planet: planets[index],
            onOpen: onOpen,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card item planet
// ─────────────────────────────────────────────────────────────────────────────

class _PlanetItemCard extends StatelessWidget {
  const _PlanetItemCard({required this.planet, required this.onOpen});

  final PlanetModel planet;
  final ValueChanged<String> onOpen;

  /// Emoji sesuai tipe planet
  String _emojiForType(String tipe) {
    final t = tipe.toLowerCase();
    if (t.contains('gas')) return '🪐';
    if (t.contains('ice') || t.contains('es')) return '🔵';
    if (t.contains('dwarf') || t.contains('kerdil')) return '🌑';
    return '🌍'; // terestrial / default
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onOpen(planet.id!),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar planet dengan emoji
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _emojiForType(planet.tipePlanet),
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info planet
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planet.namaPlanet,
                      style:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Tipe planet sebagai chip kecil
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        planet.tipePlanet,
                        style:
                        Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      planet.deskripsi,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Statistik ringkas
                    Row(
                      children: [
                        Icon(Icons.straighten,
                            size: 12,
                            color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text(
                          '${planet.jarakDariMatahari} AU',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                              color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.satellite_alt,
                            size: 12,
                            color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 2),
                        Text(
                          '${planet.jumlahSatelit} satelit',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                              color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
