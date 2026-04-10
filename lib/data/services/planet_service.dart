// lib/data/services/planet_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planet_model.dart';
import '../models/api_response_model.dart';
import '../../core/constants/api_constants.dart';

class PlanetService {
  PlanetService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // GET /planets
  Future<ApiResponse<List<PlanetModel>>> getPlanets({String search = ''}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.planets}')
        .replace(
        queryParameters:
        search.isNotEmpty ? {'search': search} : null);

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataMap = body['data'] as Map<String, dynamic>;
      final List<dynamic> jsonList =
      dataMap['planets'] as List<dynamic>;
      final planets = jsonList
          .map((e) => PlanetModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Berhasil.',
        data: planets,
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  // GET /planets/:id
  Future<ApiResponse<PlanetModel>> getPlanetById(String id) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.planetById(id)}');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataMap = body['data'] as Map<String, dynamic>;
      final planet =
      PlanetModel.fromJson(dataMap['planet'] as Map<String, dynamic>);
      return ApiResponse(
        success: true,
        message: body['message'] as String? ?? 'Berhasil.',
        data: planet,
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  // POST /planets — application/json
  Future<ApiResponse<String>> createPlanet({
    required String namaPlanet,
    required String deskripsi,
    required double jarakDariMatahari,
    required double diameter,
    required int jumlahSatelit,
    required String tipePlanet,
  }) async {
    final uri =
    Uri.parse('${ApiConstants.baseUrl}${ApiConstants.planets}');

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'namaPlanet': namaPlanet,
        'deskripsi': deskripsi,
        'jarakDariMatahari': jarakDariMatahari,
        'diameter': diameter,
        'jumlahSatelit': jumlahSatelit,
        'tipePlanet': tipePlanet,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final dataMap = body['data'] as Map<String, dynamic>;
      return ApiResponse(
        success: true,
        message:
        body['message'] as String? ?? 'Planet berhasil ditambahkan.',
        data: dataMap['planetId'] as String,
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  // PUT /planets/:id — application/json
  Future<ApiResponse<void>> updatePlanet({
    required String id,
    required String namaPlanet,
    required String deskripsi,
    required double jarakDariMatahari,
    required double diameter,
    required int jumlahSatelit,
    required String tipePlanet,
  }) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.planetById(id)}');

    final response = await _client.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'namaPlanet': namaPlanet,
        'deskripsi': deskripsi,
        'jarakDariMatahari': jarakDariMatahari,
        'diameter': diameter,
        'jumlahSatelit': jumlahSatelit,
        'tipePlanet': tipePlanet,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse(
        success: true,
        message:
        body['message'] as String? ?? 'Planet berhasil diperbarui.',
      );
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  // DELETE /planets/:id
  Future<ApiResponse<void>> deletePlanet(String id) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.planetById(id)}');
    final response = await _client.delete(uri);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return const ApiResponse(
          success: true, message: 'Planet berhasil dihapus.');
    }

    return ApiResponse(success: false, message: _parseErrorMessage(response));
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['message'] as String? ??
          'Gagal. Kode: ${response.statusCode}';
    } catch (_) {
      return 'Gagal. Kode: ${response.statusCode}';
    }
  }

  void dispose() => _client.close();
}
