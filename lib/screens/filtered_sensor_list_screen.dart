import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sensor_info.dart';
import '../providers/sensor_provider.dart';
import '../widgets/sensor_card.dart';
import 'sensor_data_screen.dart';

class FilteredSensorListScreen extends StatelessWidget {
  final String title;
  final List<String> sensorIds;

  const FilteredSensorListScreen({
    super.key,
    required this.title,
    required this.sensorIds,
    required String image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<SensorInfo>>(
        future:
            Provider.of<SensorProvider>(
              context,
              listen: false,
            ).fetchSensorList(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar sensores'));
          }

          final allSensors = snapshot.data ?? [];
          final filteredSensors =
              allSensors
                  .where((sensor) => sensorIds.contains(sensor.id))
                  .toList();

          if (filteredSensors.isEmpty) {
            return Center(
              child: Text('No hay sensores disponibles para este proceso.'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: filteredSensors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (ctx, index) {
                final sensor = filteredSensors[index];
                return SensorCard(
                  sensor: sensor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => SensorDataScreen(
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
