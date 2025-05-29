import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // Necesario para formatear fechas

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
    return SfCartesianChart(
      title: ChartTitle(text: 'Datos del Sensor'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        zoomMode: ZoomMode.x,
      ),
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(text: 'Tiempo'),
        dateFormat: DateFormat.Hm(),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        intervalType: DateTimeIntervalType.minutes,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Valor'),
        labelFormat: '{value}',
      ),
      series: <LineSeries<SensorData, DateTime>>[
        LineSeries<SensorData, DateTime>(
          name: 'Lectura',
          dataSource: data,
          xValueMapper:
              (SensorData sensor, _) =>
                  DateTime.fromMillisecondsSinceEpoch(sensor.ts * 1000),
          yValueMapper: (SensorData sensor, _) => sensor.value,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          enableTooltip: true,
        ),
      ],
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
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildLineChart(data),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      final sensor = data[index];
                      return ListTile(
                        title: Text(
                          'Valor: ${sensor.value.toStringAsFixed(2)}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fecha: ${sensor.formattedDate}'),
                            Text('ID: ${sensor.sensorId}'),
                            Text('Registro: ${sensor.row}'),
                          ],
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
