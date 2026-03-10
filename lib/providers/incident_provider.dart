import 'package:flutter/material.dart';
import '../models/incident.dart';
import '../services/incident_repository.dart';

class IncidentProvider with ChangeNotifier {
  IncidentProvider({required IncidentRepository repository})
    : _repository = repository;

  final IncidentRepository _repository;
  final List<Incident> _incidents = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Incident> get incidents => List.unmodifiable(_incidents);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadIncidents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.fetchIncidents();
      _incidents
        ..clear()
        ..addAll(data);
    } catch (e) {
      _errorMessage = 'Gagal memuat data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createIncident({
    required String title,
    required DateTime incidentAt,
    required String severity,
    required String incidentType,
    required String socAnalyst,
    required String description,
  }) async {
    _errorMessage = null;
    final incidentCode = _generateIncidentCode(incidentAt);
    final draft = Incident(
      id: '',
      incidentCode: incidentCode,
      title: title,
      incidentAt: incidentAt,
      severity: severity,
      incidentType: incidentType,
      socAnalyst: socAnalyst,
      description: description,
      status: 'Open',
      createdAt: DateTime.now(),
    );

    final inserted = await _repository.insertIncident(draft);
    _incidents.insert(0, inserted);
    notifyListeners();
  }

  Future<void> updateIncident({
    required String id,
    required String incidentCode,
    required String title,
    required DateTime incidentAt,
    required String severity,
    required String incidentType,
    required String socAnalyst,
    required String description,
    required String status,
  }) async {
    _errorMessage = null;
    final index = _incidents.indexWhere((incident) => incident.id == id);
    if (index == -1) {
      return;
    }

    final updated = _incidents[index].copyWith(
      incidentCode: incidentCode,
      title: title,
      incidentAt: incidentAt,
      severity: severity,
      incidentType: incidentType,
      socAnalyst: socAnalyst,
      description: description,
      status: status,
    );

    await _repository.updateIncident(updated);
    _incidents[index] = updated;
    notifyListeners();
  }

  Future<void> deleteIncident(String id) async {
    _errorMessage = null;
    await _repository.deleteIncident(id);
    _incidents.removeWhere((incident) => incident.id == id);
    notifyListeners();
  }

  String _generateIncidentCode(DateTime incidentAt, {int? serialOverride}) {
    final local = incidentAt.toLocal();
    final yyyy = local.year.toString().padLeft(4, '0');
    final mm = local.month.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');

    final serial = serialOverride ?? _nextDailySerial(local);
    final serialStr = serial.toString().padLeft(2, '0');
    return 'INC-$yyyy-$mm$dd-$serialStr';
  }

  int _nextDailySerial(DateTime localIncidentAt) {
    var count = 0;
    for (final incident in _incidents) {
      final dt = incident.incidentAt.toLocal();
      if (dt.year == localIncidentAt.year &&
          dt.month == localIncidentAt.month &&
          dt.day == localIncidentAt.day) {
        count++;
      }
    }
    return count + 1;
  }
}
