import 'package:flutter/material.dart';
import 'package:holamundo/screens/sensor_data_screen.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../models/sensor_info.dart';
// Importa tu pantalla de detalle si deseas navegar luego
// import 'sensor_detail_screen.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late Future<List<SensorInfo>> _sensorListFuture;

  @override
  void initState() {
    super.initState();
    _sensorListFuture =
        Provider.of<SensorProvider>(context, listen: false).fetchSensorList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selecciona un sensor')),
      body: FutureBuilder<List<SensorInfo>>(
        future: _sensorListFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar sensores'));
          }

          final sensors = snapshot.data ?? [];

          if (sensors.isEmpty) {
            return Center(child: Text('No hay sensores disponibles'));
          }

          return ListView.builder(
            itemCount: sensors.length,
            itemBuilder: (ctx, index) {
              final sensor = sensors[index];
              return ListTile(
                title: Text(sensor.name),
                subtitle: Text('ID: ${sensor.id}'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (ctx) => SensorDataScreen(
                            sensorId: sensor.id,
                            sensorName: sensor.name,
                          ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
