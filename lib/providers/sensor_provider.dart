import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class SensorProvider with ChangeNotifier {
  List<SensorData> _sensors = [];

  List<SensorData> get sensors => _sensors;

  Future<void> fetchSensorData() async {
    final url = Uri.parse('http://192.168.1.3:8000/backups/get-all/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _sensors = data.map((json) => SensorData.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load sensor data');
      }
    } catch (e) {
      print('Error fetching sensor data: $e');
    }
  }

  Future<void> deleteSensor(String id) async {
    final url = Uri.parse('http://192.168.1.3:8000/backups/delete/$id/');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _sensors.removeWhere((sensor) => sensor.id == id);
        notifyListeners();
      } else {
        throw Exception('Error al eliminar el sensor');
      }
    } catch (e) {
      print('Error eliminando sensor: $e');
      rethrow;
    }
  }
}
