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
  bool _isRefreshing = false;

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    try {
      await Provider.of<SensorProvider>(
        context,
        listen: false,
      ).fetchSensorDataById(widget.sensorId);
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

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
      appBar: AppBar(
        title: Text(widget.sensorName),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<SensorData>>(
          future: _sensorDataFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !_isRefreshing) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error al cargar datos del sensor'),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: Text('Reintentar'),
                    ),
                  ],
                ),
              );
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
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 2,
                  child: ListTile(
                    title: Text('Valor: ${sensor.value.toStringAsFixed(2)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'Fecha: ${sensor.formattedDate}',
                        ), // Usamos el getter de fecha formateada
                        Text('ID: ${sensor.sensorId}'),
                        Text('Registro: ${sensor.row}'),
                      ],
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // Podrías navegar a un detalle más específico si lo necesitas
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
