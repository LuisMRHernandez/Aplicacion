import 'package:flutter/material.dart';
import 'package:holamundo/screens/sensor_data_screen.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../models/sensor_info.dart';
import '../widgets/sensor_card.dart';

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
      appBar: AppBar(
        toolbarHeight: 120.0, //cambia la altura de imagen
        title: Column(
          children: [
            Image.asset(
              'assets/ecom.png', //
              height: 80, // Altura de la imagen
            ),
            SizedBox(height: 8), // Espacio entre la imagen y el texto
            Text(
              'SELECCIONA UN SENSOR',
              style: TextStyle(
                fontSize: 20, // Aumenta el tamaño de la fuente del texto
                fontWeight: FontWeight.bold, // Opcional: hazlo más audaz
                color: const Color.fromARGB(255, 5, 86, 235),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
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

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: sensors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Tres columnas
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (ctx, index) {
                final sensor = sensors[index];
                return SensorCard(
                  sensor: sensor,
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
            ),
          );
        },
      ),
    );
  }
}
