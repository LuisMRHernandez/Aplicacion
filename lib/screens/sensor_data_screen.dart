import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/sensor_provider.dart';
import '../models/sensor_data.dart';

class SensorDataScreen extends StatefulWidget {
  final String sensorId;
  final String sensorName;

  const SensorDataScreen({
    super.key,
    required this.sensorId,
    required this.sensorName,
  });

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
      _sensorDataFuture = Provider.of<SensorProvider>(
        context,
        listen: false,
      ).fetchSensorDataById(widget.sensorId);
      await _sensorDataFuture;
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

  Widget buildLineChart(List<SensorData> data) {
    final List<FlSpot> spots =
        data
            .map((sensor) => FlSpot(sensor.ts.toDouble(), sensor.value))
            .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 300, // altura fija para que Flutter sepa cómo dibujar
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                axisNameWidget: Text('Valor variable'),
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                axisNameWidget: Text('Tiempo'),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval:
                      (data.length > 5)
                          ? (data.last.ts - data.first.ts) / 5
                          : 1,
                  getTitlesWidget: (value, meta) {
                    final date = DateTime.fromMillisecondsSinceEpoch(
                      value.toInt() * 1000,
                    );
                    return Text(
                      '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: const Color.fromARGB(255, 243, 15, 15),
                barWidth: 4,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
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

            return Column(
              children: [
                buildLineChart(data),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      final sensor = data[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            'Valor: ${sensor.value.toStringAsFixed(2)}',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text('Fecha: ${sensor.formattedDate}'),
                              Text('ID: ${sensor.sensorId}'),
                              Text('Registro: ${sensor.row}'),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            // Acción opcional
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
