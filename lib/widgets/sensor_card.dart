import 'package:flutter/material.dart';
import '../models/sensor_info.dart';

final Map<String, String> sensorImages = {
  "11": "assets/bateria.png",
  "12": "assets/bateria.png",
  "13": "assets/bateria.png",
  "14": "assets/bateria.png",
  "15": "assets/caudal.png",
  "16": "assets/humedad.png",
  "17": "assets/humedad.png",
  "21": "assets/viento.png",
  "22": "assets/humedad.png",
  "23": "assets/irradiancia.png",
  "24": "assets/lluvia.png",
  "25": "assets/temp_ambiente.png",
  "26": "assets/viento.png",
  "31": "assets/temperatura.png",
  "32": "assets/humedad.png",
  "33": "assets/temperatura.png",
  "34": "assets/humedad_suelo.png",
  "35": "assets/temperatura.png",
  "36": "assets/humedad_suelo.png",
  "37": "assets/temperatura.png",
  "38": "assets/humedad_suelo.png",
  "39": "assets/humedad.png",
  "51": "assets/temperatura.png",
  "52": "assets/humedad.png",
  "53": "assets/temperatura.png",
  "54": "assets/temperatura.png",
  "55": "assets/temperatura.png",
  "56": "assets/ph.png",
  "57": "assets/brix.png",
};

class SensorCard extends StatelessWidget {
  final SensorInfo sensor;
  final VoidCallback onTap;

  const SensorCard({super.key, required this.sensor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imagePath = sensorImages[sensor.id] ?? "assets/sensors/default.png";

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                sensor.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
