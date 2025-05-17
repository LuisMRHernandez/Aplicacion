import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/sensor_provider.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SensorProvider())],
      child: MaterialApp(
        title: 'Sensor App',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: HomeScreen(),
      ),
    );
  }
}
