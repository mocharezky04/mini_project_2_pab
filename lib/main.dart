import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/incident_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IncidentProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cyber Incident Log',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}