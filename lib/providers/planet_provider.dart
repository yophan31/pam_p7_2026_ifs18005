// lib/providers/planet_provider.dart

import '../data/models/planet_model.dart';
import '../data/services/planet_repository.dart';
import 'package:flutter/foundation.dart';

enum PlanetStatus { initial, loading, success, error }

class PlanetProvider extends ChangeNotifier {
  PlanetProvider({PlanetRepository? repository})
      : _repository = repository ?? PlanetRepository();

  final PlanetRepository _repository;

  PlanetStatus _status = PlanetStatus.initial;
  List<PlanetModel> _planets = [];
  PlanetModel? _selectedPlanet;
  String _errorMessage = '';
  String _searchQuery = '';

  PlanetStatus get status => _status;
  PlanetModel? get selectedPlanet => _selectedPlanet;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<PlanetModel> get planets {
    if (_searchQuery.isEmpty) return List.unmodifiable(_planets);
    return _planets
        .where((p) =>
    p.namaPlanet
        .toLowerCase()
        .contains(_searchQuery.toLowerCase()) ||
        p.tipePlanet
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> loadPlanets() async {
    _setStatus(PlanetStatus.loading);
    final result = await _repository.getPlanets();
    if (result.success && result.data != null) {
      _planets = result.data!;
      _setStatus(PlanetStatus.success);
    } else {
      _errorMessage = result.message;
      _setStatus(PlanetStatus.error);
    }
  }

  Future<void> loadPlanetById(String id) async {
    _setStatus(PlanetStatus.loading);
    final result = await _repository.getPlanetById(id);
    if (result.success && result.data != null) {
      _selectedPlanet = result.data;
      _setStatus(PlanetStatus.success);
    } else {
      _errorMessage = result.message;
      _setStatus(PlanetStatus.error);
    }
  }

  Future<bool> addPlanet({
    required String namaPlanet,
    required String deskripsi,
    required double jarakDariMatahari,
    required double diameter,
    required int jumlahSatelit,
    required String tipePlanet,
  }) async {
    _setStatus(PlanetStatus.loading);
    final result = await _repository.createPlanet(
      namaPlanet: namaPlanet,
      deskripsi: deskripsi,
      jarakDariMatahari: jarakDariMatahari,
      diameter: diameter,
      jumlahSatelit: jumlahSatelit,
      tipePlanet: tipePlanet,
    );
    if (result.success) {
      await loadPlanets();
      return true;
    }
    _errorMessage = result.message;
    _setStatus(PlanetStatus.error);
    return false;
  }

  Future<bool> editPlanet({
    required String id,
    required String namaPlanet,
    required String deskripsi,
    required double jarakDariMatahari,
    required double diameter,
    required int jumlahSatelit,
    required String tipePlanet,
  }) async {
    _setStatus(PlanetStatus.loading);
    final result = await _repository.updatePlanet(
      id: id,
      namaPlanet: namaPlanet,
      deskripsi: deskripsi,
      jarakDariMatahari: jarakDariMatahari,
      diameter: diameter,
      jumlahSatelit: jumlahSatelit,
      tipePlanet: tipePlanet,
    );
    if (result.success) {
      await loadPlanetById(id);
      return true;
    }
    _errorMessage = result.message;
    _setStatus(PlanetStatus.error);
    return false;
  }

  Future<bool> removePlanet(String id) async {
    _setStatus(PlanetStatus.loading);
    final result = await _repository.deletePlanet(id);
    if (result.success) {
      _planets = _planets.where((p) => p.id != id).toList();
      _setStatus(PlanetStatus.success);
      return true;
    }
    _errorMessage = result.message;
    _setStatus(PlanetStatus.error);
    return false;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSelectedPlanet() {
    _selectedPlanet = null;
    notifyListeners();
  }

  void _setStatus(PlanetStatus status) {
    _status = status;
    notifyListeners();
  }
}
