import 'package:flutter/material.dart';
import '../models/incident.dart';
import 'dart:math';

class IncidentProvider with ChangeNotifier {
  final List<Incident> _incidents = [];

  List<Incident> get incidents => _incidents;

  void addIncident(String title, String date, String severity, String description) {
    final newIncident = Incident(
      id: Random().nextDouble().toString(),
      title: title,
      date: date,
      severity: severity,
      description: description,
      status: "Open",
    );

    _incidents.add(newIncident);
    notifyListeners();
  }

  void deleteIncident(String id) {
    _incidents.removeWhere((incident) => incident.id == id);
    notifyListeners();
  }

  void updateIncident(String id, String title, String date, String severity, String description, String status) {
    final index = _incidents.indexWhere((incident) => incident.id == id);

    if (index != -1) {
      _incidents[index] = Incident(
        id: id,
        title: title,
        date: date,
        severity: severity,
        description: description,
        status: status,
      );
      notifyListeners();
    }
  }
}