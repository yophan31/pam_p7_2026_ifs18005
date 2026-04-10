// lib/data/models/planet_model.dart

/// Model data untuk planet
/// Field disesuaikan dengan PlanetDAO di backend
class PlanetModel {
  const PlanetModel({
    this.id,
    required this.namaPlanet,
    required this.deskripsi,
    required this.jarakDariMatahari,
    required this.diameter,
    required this.jumlahSatelit,
    required this.tipePlanet,
    this.createdAt,
    this.updatedAt,
  });

  /// UUID dari database
  final String? id;
  final String namaPlanet;
  final String deskripsi;

  /// Jarak dari matahari dalam satuan AU (Astronomical Unit)
  final double jarakDariMatahari;

  /// Diameter dalam kilometer
  final double diameter;

  /// Jumlah satelit alami
  final int jumlahSatelit;

  /// Tipe planet, contoh: "Terestrial", "Gas Giant", "Ice Giant", "Dwarf"
  final String tipePlanet;

  final String? createdAt;
  final String? updatedAt;

  /// Membuat PlanetModel dari JSON (response API)
// lib/data/models/planet_model.dart

  factory PlanetModel.fromJson(Map<String, dynamic> json) {
    return PlanetModel(
      id: json['id'] as String?,
      namaPlanet: json['namaPlanet'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',

      // ✅ Handle jika nilai dari BE berupa String atau num
      jarakDariMatahari: _parseDouble(json['jarakDariMatahari']),
      diameter: _parseDouble(json['diameter']),
      jumlahSatelit: _parseInt(json['jumlahSatelit']),

      tipePlanet: json['tipePlanet'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  /// Parse nilai yang bisa berupa num atau String ke double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    // Jika String, ambil angka saja (buang satuan seperti "juta km", "AU", dll)
    final cleaned = value.toString().replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Parse nilai yang bisa berupa num atau String ke int
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    final cleaned = value.toString().replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  /// Mengonversi PlanetModel ke JSON (untuk request API)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'namaPlanet': namaPlanet,
      'deskripsi': deskripsi,
      'jarakDariMatahari': jarakDariMatahari,
      'diameter': diameter,
      'jumlahSatelit': jumlahSatelit,
      'tipePlanet': tipePlanet,
    };
  }

  PlanetModel copyWith({
    String? id,
    String? namaPlanet,
    String? deskripsi,
    double? jarakDariMatahari,
    double? diameter,
    int? jumlahSatelit,
    String? tipePlanet,
    String? createdAt,
    String? updatedAt,
  }) {
    return PlanetModel(
      id: id ?? this.id,
      namaPlanet: namaPlanet ?? this.namaPlanet,
      deskripsi: deskripsi ?? this.deskripsi,
      jarakDariMatahari: jarakDariMatahari ?? this.jarakDariMatahari,
      diameter: diameter ?? this.diameter,
      jumlahSatelit: jumlahSatelit ?? this.jumlahSatelit,
      tipePlanet: tipePlanet ?? this.tipePlanet,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlanetModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlanetModel(id: $id, namaPlanet: $namaPlanet)';
}
