import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';

class AddIncidentScreen extends StatefulWidget {
  const AddIncidentScreen({super.key});

  @override
  State<AddIncidentScreen> createState() => _AddIncidentScreenState();
}

class _AddIncidentScreenState extends State<AddIncidentScreen> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _severityController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final incidentProvider = Provider.of<IncidentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Insiden'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Insiden'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Tanggal'),
            ),
            TextField(
              controller: _severityController,
              decoration: const InputDecoration(labelText: 'Severity (Low/Medium/High)'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                incidentProvider.addIncident(
                  _titleController.text,
                  _dateController.text,
                  _severityController.text,
                  _descriptionController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}