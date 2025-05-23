import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../models/sensor_data.dart';

class SensorDetailScreen extends StatefulWidget {
  final int rowId;

  const SensorDetailScreen({super.key, required this.rowId});

  @override
  _SensorDetailScreenState createState() => _SensorDetailScreenState();
}

class _SensorDetailScreenState extends State<SensorDetailScreen> {
  SensorData? _sensor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSensor();
  }

  Future<void> _loadSensor() async {
    final provider = Provider.of<SensorProvider>(context, listen: false);
    final result = await provider.fetchSensorById(widget.rowId);
    setState(() {
      _sensor = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle del Backup')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _sensor == null
              ? Center(child: Text('Backup no encontrado'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text('ID: ${_sensor!.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text('Valor: ${_sensor!.value}'),
                        Text('Timestamp: ${_sensor!.ts}'),
                        Text('Fila: ${_sensor!.row}'),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
