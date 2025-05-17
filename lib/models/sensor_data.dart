class SensorData {
  final int row;
  final String id;
  final double value;
  final int ts;

  SensorData({
    required this.row,
    required this.id,
    required this.value,
    required this.ts,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      row: json['row'],
      id: json['id'],
      value: json['value'].toDouble(),
      ts: json['ts'],
    );
  }
}
