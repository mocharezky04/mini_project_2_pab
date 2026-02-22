import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import 'add_incident_screen.dart';
import 'detail_incident_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color _severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return const Color(0xFFB42318);
      case 'medium':
        return const Color(0xFFB54708);
      default:
        return const Color(0xFF027A48);
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return const Color(0xFF175CD3);
      default:
        return const Color(0xFF7A2E0E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final incidentProvider = Provider.of<IncidentProvider>(context);
    final incidents = incidentProvider.incidents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyber Incident Log'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B3C5D), Color(0xFF1D6FA3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              '${incidents.length} incident tercatat',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: incidents.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: incidents.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final incident = incidents[index];

                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                          title: Text(
                            incident.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _InfoChip(
                                  label: 'Severity: ${incident.severity}',
                                  color: _severityColor(incident.severity),
                                ),
                                _InfoChip(
                                  label: 'Status: ${incident.status}',
                                  color: _statusColor(incident.status),
                                ),
                                _InfoChip(
                                  label: incident.date,
                                  color: const Color(0xFF475467),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailIncidentScreen(incident: incident),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              incidentProvider.deleteIncident(incident.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddIncidentScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.security_outlined, size: 48, color: Color(0xFF98A2B3)),
            SizedBox(height: 12),
            Text(
              'Belum ada incident',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Tekan tombol Tambah untuk membuat catatan insiden baru.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF667085)),
            ),
          ],
        ),
      ),
    );
  }
}


