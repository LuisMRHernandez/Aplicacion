import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      Provider.of<SensorProvider>(
        context,
        listen: false,
      ).fetchSensorData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Sensores')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : sensorProvider.sensors.isEmpty
              ? Center(child: Text('No hay datos'))
              : ListView.builder(
                itemCount: sensorProvider.sensors.length,
                itemBuilder: (ctx, index) {
                  final sensor = sensorProvider.sensors[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${sensor.row}')),
                    title: Text(sensor.id),
                    subtitle: Text('Valor: ${sensor.value} - TS: ${sensor.ts}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: Text('¿Eliminar Backup?'),
                                content: Text(
                                  '¿Estás seguro de eliminar ${sensor.id}?',
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Cancelar'),
                                    onPressed:
                                        () => Navigator.of(ctx).pop(false),
                                  ),
                                  TextButton(
                                    child: Text('Eliminar'),
                                    onPressed:
                                        () => Navigator.of(ctx).pop(true),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          try {
                            await Provider.of<SensorProvider>(
                              context,
                              listen: false,
                            ).deleteSensor(sensor.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Backup eliminado')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error eliminando backup'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
              ),
    );
  }
}
