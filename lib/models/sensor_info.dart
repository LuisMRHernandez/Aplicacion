class SensorInfo {
  final String id;
  final String name;

  SensorInfo({required this.id, required this.name});

  factory SensorInfo.fromJson(Map<String, dynamic> json) {
    return SensorInfo(
      id: json['id'].toString(),
      name: json['name'] ?? 'Desconocido',
    );
  }
}
