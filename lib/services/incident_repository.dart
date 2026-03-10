import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/incident.dart';

abstract class IncidentRepository {
  Future<List<Incident>> fetchIncidents();
  Future<Incident> insertIncident(Incident incident);
  Future<void> updateIncident(Incident incident);
  Future<void> deleteIncident(String id);
}

class SupabaseIncidentRepository implements IncidentRepository {
  SupabaseIncidentRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Incident>> fetchIncidents() async {
    final response = await _client
        .from('incidents')
        .select()
        .order('incident_at', ascending: false);
    return response.map(Incident.fromMap).toList();
  }

  @override
  Future<Incident> insertIncident(Incident incident) async {
    final inserted = await _client
        .from('incidents')
        .insert(incident.toInsertMap())
        .select()
        .single();
    return Incident.fromMap(inserted);
  }

  @override
  Future<void> updateIncident(Incident incident) async {
    await _client
        .from('incidents')
        .update(incident.toUpdateMap())
        .eq('id', incident.id);
  }

  @override
  Future<void> deleteIncident(String id) async {
    await _client.from('incidents').delete().eq('id', id);
  }
}

class InMemoryIncidentRepository implements IncidentRepository {
  InMemoryIncidentRepository();

  static const Uuid _uuid = Uuid();
  final List<Incident> _storage = [];

  @override
  Future<List<Incident>> fetchIncidents() async {
    return List<Incident>.from(_storage)
      ..sort((a, b) => b.incidentAt.compareTo(a.incidentAt));
  }

  @override
  Future<Incident> insertIncident(Incident incident) async {
    final inserted = incident.copyWith(
      id: incident.id.isEmpty ? _uuid.v4() : incident.id,
      createdAt: incident.createdAt ?? DateTime.now(),
    );
    _storage.add(inserted);
    return inserted;
  }

  @override
  Future<void> updateIncident(Incident incident) async {
    final index = _storage.indexWhere((item) => item.id == incident.id);
    if (index != -1) {
      _storage[index] = incident;
    }
  }

  @override
  Future<void> deleteIncident(String id) async {
    _storage.removeWhere((item) => item.id == id);
  }
}
