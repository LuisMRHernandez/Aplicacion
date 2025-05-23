import 'package:flutter/material.dart';
import '../models/sensor_info.dart';

class SensorCard extends StatelessWidget {
  final SensorInfo sensor;
  final VoidCallback onTap;

  const SensorCard({required this.sensor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(238, 3, 238, 247),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sensors, size: 40, color: Colors.blue.shade800),
            SizedBox(height: 8),
            Text(
              sensor.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text('ID: ${sensor.id}', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
