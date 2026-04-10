// lib/features/planets/planets_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/planet_model.dart';
import '../../providers/planet_provider.dart';
import '../../shared/widgets/top_app_bar_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/error_widget.dart';

class PlanetsEditScreen extends StatefulWidget {
  const PlanetsEditScreen({super.key, required this.planetId});

  final String planetId;

  @override
  State<PlanetsEditScreen> createState() => _PlanetsEditScreenState();
}

class _PlanetsEditScreenState extends State<PlanetsEditScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlanetProvider>().loadPlanetById(widget.planetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanetProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: const TopAppBarWidget(
            title: 'Edit Planet',
            showBackButton: true,
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
                ? const AppErrorWidget(
                message: 'Data planet tidak ditemukan.')
                : _EditForm(planet: provider.selectedPlanet!),
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Form edit
// ─────────────────────────────────────────────────────────────────────────────

class _EditForm extends StatefulWidget {
  const _EditForm({required this.planet});
  final PlanetModel planet;

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  late final TextEditingController _namaController;
  late final TextEditingController _deskripsiController;
  late final TextEditingController _jarakController;
  late final TextEditingController _diameterController;
  late final TextEditingController _satelitController;
  late String _tipePlanet;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  static const List<String> _tipeOptions = [
    'Terestrial',
    'Gas Giant',
    'Ice Giant',
    'Dwarf Planet',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.planet;
    _namaController = TextEditingController(text: p.namaPlanet);
    _deskripsiController = TextEditingController(text: p.deskripsi);
    _jarakController =
        TextEditingController(text: p.jarakDariMatahari.toString());
    _diameterController =
        TextEditingController(text: p.diameter.toString());
    _satelitController =
        TextEditingController(text: p.jumlahSatelit.toString());
    // Pastikan nilai default valid
    _tipePlanet = _tipeOptions.contains(p.tipePlanet)
        ? p.tipePlanet
        : _tipeOptions.first;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _jarakController.dispose();
    _diameterController.dispose();
    _satelitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await context.read<PlanetProvider>().editPlanet(
      id: widget.planet.id!,
      namaPlanet: _namaController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      jarakDariMatahari:
      double.tryParse(_jarakController.text.trim()) ?? 0,
      diameter:
      double.tryParse(_diameterController.text.trim()) ?? 0,
      jumlahSatelit:
      int.tryParse(_satelitController.text.trim()) ?? 0,
      tipePlanet: _tipePlanet,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Planet berhasil diperbarui.')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read<PlanetProvider>().errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField(
              controller: _namaController,
              label: 'Nama Planet',
              hint: 'Contoh: Mars',
              icon: Icons.public,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _tipePlanet,
              decoration: const InputDecoration(
                labelText: 'Tipe Planet',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
              items: _tipeOptions
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _tipePlanet = val);
              },
            ),
            const SizedBox(height: 16),

            _buildField(
              controller: _deskripsiController,
              label: 'Deskripsi',
              hint: 'Deskripsikan planet ini...',
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildNumberField(
                    controller: _jarakController,
                    label: 'Jarak (AU)',
                    hint: '1.52',
                    icon: Icons.straighten,
                    isDouble: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNumberField(
                    controller: _diameterController,
                    label: 'Diameter (km)',
                    hint: '6779',
                    icon: Icons.circle_outlined,
                    isDouble: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildNumberField(
              controller: _satelitController,
              label: 'Jumlah Satelit',
              hint: '2',
              icon: Icons.satellite_alt,
              isDouble: false,
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.save_outlined),
              label: Text(_isLoading ? 'Menyimpan...' : 'Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label tidak boleh kosong.';
        }
        return null;
      },
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDouble,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
      const TextInputType.numberWithOptions(decimal: true, signed: false),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label tidak boleh kosong.';
        }
        if (isDouble) {
          if (double.tryParse(value.trim()) == null) {
            return 'Masukkan angka yang valid.';
          }
        } else {
          if (int.tryParse(value.trim()) == null) {
            return 'Masukkan bilangan bulat.';
          }
        }
        return null;
      },
    );
  }
}
