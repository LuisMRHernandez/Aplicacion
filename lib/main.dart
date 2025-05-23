import 'package:flutter/material.dart';
import 'package:holamundo/screens/main_menu_screen.dart';
import 'package:provider/provider.dart';
import './providers/sensor_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SensorProvider())],
      child: MaterialApp(
        title: 'Sensor App',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: MainMenuScreen(),
      ),
    );
  }
}
