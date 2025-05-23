import 'package:intl/intl.dart';

class SensorData {
  final int row;
  final String id;
  final double value;
  final int ts;
  final DateTime dateTime;

  SensorData({
    required this.row,
    required this.id,
    required this.value,
    required this.ts,
  }) : dateTime = DateTime.fromMillisecondsSinceEpoch(ts * 1000);

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      row: json['row'],
      id: json['id'],
      value: json['value'].toDouble(),
      ts: json['ts'],
    );
  }

  String getFormattedDate() {
    return DateFormat('HH:mm:ss dd-MM-yyyy').format(dateTime);
  }

  // O si prefieres tenerlo como propiedad calculada
  String get formattedDate {
    return DateFormat('HH:mm:ss dd-MM-yyyy').format(dateTime);
  }

  get sensorId => id;
}
