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
  late TextEditingController _descriptionController;
  late String _selectedSeverity;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.incident.title);
    _dateController = TextEditingController(text: widget.incident.date);
    _descriptionController = TextEditingController(text: widget.incident.description);
    _selectedSeverity = widget.incident.severity;
    _selectedStatus = widget.incident.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IncidentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Insiden'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Data Insiden',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Lakukan perubahan lalu simpan.',
                    style: TextStyle(color: Color(0xFF667085)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Judul'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Tanggal'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedSeverity,
                    decoration: const InputDecoration(labelText: 'Severity'),
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedSeverity = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedStatus,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(value: 'Open', child: Text('Open')),
                      DropdownMenuItem(value: 'Closed', child: Text('Closed')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedStatus = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.updateIncident(
                        widget.incident.id,
                        _titleController.text,
                        _dateController.text,
                        _selectedSeverity,
                        _descriptionController.text,
                        _selectedStatus,
                      );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Update Insiden'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


