// lib/features/planets/planets_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../providers/planet_provider.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/top_app_bar_widget.dart';
import '../../data/models/planet_model.dart';

class PlanetsDetailScreen extends StatefulWidget {
  const PlanetsDetailScreen({super.key, required this.planetId});

  final String planetId;

  @override
  State<PlanetsDetailScreen> createState() => _PlanetsDetailScreenState();
}

class _PlanetsDetailScreenState extends State<PlanetsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlanetProvider>().loadPlanetById(widget.planetId);
    });
  }

  Future<void> _confirmDelete(
      BuildContext context, PlanetProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Planet'),
        content: const Text(
            'Apakah kamu yakin ingin menghapus planet ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final success = await provider.removePlanet(widget.planetId);
    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Planet berhasil dihapus.')),
      );
      context.go(RouteConstants.planets);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanetProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: TopAppBarWidget(
            title: 'Detail Planet',
            showBackButton: true,
            actions: provider.status == PlanetStatus.success &&
                provider.selectedPlanet != null
                ? [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: () => context.push(
                  RouteConstants.planetsEdit(widget.planetId),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Hapus',
                onPressed: () => _confirmDelete(context, provider),
              ),
            ]
                : null,
          ),
          body: switch (provider.status) {
            PlanetStatus.loading || PlanetStatus.initial =>
            const LoadingWidget(),
            PlanetStatus.error => AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () =>
                  provider.loadPlanetById(widget.planetId),
            ),
            PlanetStatus.success => provider.selectedPlanet == null
                ? const AppErrorWidget(message: 'Data planet tidak ditemukan.')
                : _PlanetDetailBody(planet: provider.selectedPlanet!),
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body detail
// ─────────────────────────────────────────────────────────────────────────────

class _PlanetDetailBody extends StatelessWidget {
  const _PlanetDetailBody({required this.planet});

  final PlanetModel planet;

  String _emojiForType(String tipe) {
    final t = tipe.toLowerCase();
    if (t.contains('gas')) return '🪐';
    if (t.contains('ice') || t.contains('es')) return '🔵';
    if (t.contains('dwarf') || t.contains('kerdil')) return '🌑';
    return '🌍';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero planet ──
          Card(
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                children: [
                  Text(
                    _emojiForType(planet.tipePlanet),
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    planet.namaPlanet,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      planet.tipePlanet,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Statistik ──
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Statistik',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Divider(height: 16),
                  _StatRow(
                    icon: Icons.straighten,
                    label: 'Jarak dari Matahari',
                    value: '${planet.jarakDariMatahari} AU',
                  ),
                  _StatRow(
                    icon: Icons.circle_outlined,
                    label: 'Diameter',
                    value: '${planet.diameter.toStringAsFixed(0)} km',
                  ),
                  _StatRow(
                    icon: Icons.satellite_alt,
                    label: 'Jumlah Satelit',
                    value: '${planet.jumlahSatelit}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Deskripsi ──
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deskripsi',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(planet.deskripsi, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
