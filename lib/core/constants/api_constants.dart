// lib/core/constants/api_constants.dart

/// Konstanta untuk konfigurasi API
class ApiConstants {
  ApiConstants._();

  /// Base URL API
  /// Modifikasi username `ifs23020` sesuai dengan username kamu.
  static const String baseUrl =
      'https://pam-2026-p4-ifs23020-be.dyophanci.fun:8080';

  // ── Plants ──────────────────────────────────────────────
  static const String plants = '/plants';
  static String plantById(String id) => '/plants/$id';

  // ── Planets ──────────────────────────────────────────────
  static const String planets = '/planets';
  static String planetById(String id) => '/planets/$id';
}