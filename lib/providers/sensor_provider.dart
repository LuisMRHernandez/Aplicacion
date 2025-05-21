import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';
import '../models/sensor_info.dart';

class SensorProvider with ChangeNotifier {
  List<SensorData> _sensors = [];

  List<SensorData> get sensors => _sensors;

  Future<List<SensorInfo>> fetchSensorList() async {
    final url = Uri.parse('http://192.168.1.3:8000/sensors/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => SensorInfo.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener la lista de sensores');
      }
    } catch (e) {
      print('Error al obtener sensores: $e');
      return [];
    }
  }

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

  Future<SensorData?> fetchSensorById(int rowId) async {
    final url = Uri.parse('http://192.168.1.3:8000/backups/$rowId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SensorData.fromJson(data);
      } else if (response.statusCode == 404) {
        print('Backup no encontrado');
        return null;
      } else {
        throw Exception('Error al obtener el backup');
      }
    } catch (e) {
      print('Error obteniendo backup: $e');
      return null;
    }
  }

  Future<List<SensorData>> fetchSensorDataById(String sensorId) async {
    final url = Uri.parse(
      'http://192.168.1.3:8000/backups/get-all/?sensor_id=$sensorId',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => SensorData.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener los datos del sensor');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
