import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';

class DetailIncidentScreen extends StatefulWidget {
  final Incident incident;

  const DetailIncidentScreen({super.key, required this.incident});

  @override
  State<DetailIncidentScreen> createState() => _DetailIncidentScreenState();
}

class _DetailIncidentScreenState extends State<DetailIncidentScreen> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _severityController;
  late TextEditingController _descriptionController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.incident.title);
    _dateController = TextEditingController(text: widget.incident.date);
    _severityController = TextEditingController(text: widget.incident.severity);
    _descriptionController = TextEditingController(text: widget.incident.description);
    _statusController = TextEditingController(text: widget.incident.status);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IncidentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Insiden'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Judul')),
            TextField(controller: _dateController, decoration: const InputDecoration(labelText: 'Tanggal')),
            TextField(controller: _severityController, decoration: const InputDecoration(labelText: 'Severity')),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Deskripsi')),
            TextField(controller: _statusController, decoration: const InputDecoration(labelText: 'Status')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                provider.updateIncident(
                  widget.incident.id,
                  _titleController.text,
                  _dateController.text,
                  _severityController.text,
                  _descriptionController.text,
                  _statusController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Update'),
            )
          ],
        ),
      ),
    );
  }
}