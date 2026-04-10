// lib/data/services/planet_repository.dart

import '../models/planet_model.dart';
import '../models/api_response_model.dart';
import 'planet_service.dart';

class PlanetRepository {
  PlanetRepository({PlanetService? service})
      : _service = service ?? PlanetService();

  final PlanetService _service;

  Future<ApiResponse<List<PlanetModel>>> getPlanets(
      {String search = ''}) async {
    try {
      return await _service.getPlanets(search: search);
    } catch (e) {
      return ApiResponse(
          success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  Future<ApiResponse<PlanetModel>> getPlanetById(String id) async {
    try {
      return await _service.getPlanetById(id);
    } catch (e) {
      return ApiResponse(
          success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  Future<ApiResponse<String>> createPlanet({
    required String namaPlanet,
    required String deskripsi,
    required double jarakDariMatahari,
    required double diameter,
    required int jumlahSatelit,
    required String tipePlanet,
  }) async {
    try {
      return await _service.createPlanet(
        namaPlanet: namaPlanet,
        deskripsi: deskripsi,
        jarakDariMatahari: jarakDariMatahari,
        diameter: diameter,
        jumlahSatelit: jumlahSatelit,
        tipePlanet: tipePlanet,
      );
    } catch (e) {
      return ApiResponse(
          success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  Future<ApiResponse<void>> updatePlanet({
    required String id,
    required String namaPlanet,
    required String deskripsi,
    required double jarakDariMatahari,
    required double diameter,
    required int jumlahSatelit,
    required String tipePlanet,
  }) async {
    try {
      return await _service.updatePlanet(
        id: id,
        namaPlanet: namaPlanet,
        deskripsi: deskripsi,
        jarakDariMatahari: jarakDariMatahari,
        diameter: diameter,
        jumlahSatelit: jumlahSatelit,
        tipePlanet: tipePlanet,
      );
    } catch (e) {
      return ApiResponse(
          success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  Future<ApiResponse<void>> deletePlanet(String id) async {
    try {
      return await _service.deletePlanet(id);
    } catch (e) {
      return ApiResponse(
          success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }
}
