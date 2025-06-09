import 'package:flutter/material.dart';
import 'package:Ecomindala/screens/filtered_sensor_list_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  final List<Map<String, dynamic>> processButtons = const [
    {
      'label': 'Fermentación',
      'image': 'assets/fermentacion.png',
      'sensorIds': ['51', '52', '53', '54', '55', '56', '57'],
    },
    {
      'label': 'Secado',
      'image': 'assets/secado.png',
      'sensorIds': ['31', '32', '33', '34', '35', '36', '37', '38', '39'],
    },
    {
      'label': 'Climatología',
      'image': 'assets/climatica.png',
      'sensorIds': ['21', '22', '23', '24', '25', '26'],
    },
    {
      'label': 'Cultivo',
      'image': 'assets/cultivo.png',
      'sensorIds': ['11', '12', '13', '14', '15', '16', '17'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120.0,
        title: Column(
          children: [
            Image.asset('assets/ecom.png', height: 80),
            const SizedBox(height: 8),
            const Text(
              'SELECCIONA UN PROCESO',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(110, 139, 119, 2),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children:
              processButtons.map((data) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => FilteredSensorListScreen(
                              title: data['label'] as String,
                              image: data['image'] as String,
                              sensorIds: List<String>.from(data['sensorIds']),
                            ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          data['image'] as String,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
