import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import 'add_incident_screen.dart';
import 'detail_incident_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentProvider = Provider.of<IncidentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyber Incident Log'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: incidentProvider.incidents.length,
        itemBuilder: (context, index) {
          final incident = incidentProvider.incidents[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: const Color(0xFFE8EAF6),
            child: ListTile(
              title: Text(incident.title),
              subtitle: Text('Severity: ${incident.severity} | Status: ${incident.status}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailIncidentScreen(incident: incident),
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  incidentProvider.deleteIncident(incident.id);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddIncidentScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
