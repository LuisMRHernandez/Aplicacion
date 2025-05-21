import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../models/sensor_data.dart';

class SensorDataScreen extends StatefulWidget {
  final String sensorId;
  final String sensorName;

  const SensorDataScreen({required this.sensorId, required this.sensorName});

  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  late Future<List<SensorData>> _sensorDataFuture;

  @override
  void initState() {
    super.initState();
    _sensorDataFuture = Provider.of<SensorProvider>(
      context,
      listen: false,
    ).fetchSensorDataById(widget.sensorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.sensorName)),
      body: FutureBuilder<List<SensorData>>(
        future: _sensorDataFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar datos del sensor'));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return Center(
              child: Text('No hay datos disponibles para este sensor.'),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              final sensor = data[index];
              return ListTile(
                title: Text('Valor: ${sensor.value}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${sensor.id}'),
                    Text('TS: ${sensor.ts}'),
                    Text('Fila: ${sensor.row}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
