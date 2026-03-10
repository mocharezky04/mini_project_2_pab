import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import '../utils/incident_datetime_formatter.dart';

class DetailIncidentScreen extends StatefulWidget {
  final Incident incident;

  const DetailIncidentScreen({super.key, required this.incident});

  @override
  State<DetailIncidentScreen> createState() => _DetailIncidentScreenState();
}

class _DetailIncidentScreenState extends State<DetailIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _descriptionController;
  late TextEditingController _socAnalystController;
  final _titleFocus = FocusNode();
  final _dateFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _socAnalystFocus = FocusNode();
  bool _isSubmitting = false;
  late String _selectedSeverity;
  late String _selectedStatus;
  late String _selectedIncidentType;

  static const List<String> _incidentTypeOptions = [
    'Phishing',
    'Malware (Trojan)',
    'DDoS',
    'Unauthorized Access',
    'Data Leak',
  ];

  Future<void> _pickDateTime() async {
    try {
      final initial = _dateController.text.trim().isEmpty
          ? DateTime.now()
          : parseIncidentDateTime(_dateController.text);
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (pickedDate == null) {
        return;
      }
      if (!mounted) {
        return;
      }

      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initial),
      );
      if (pickedTime == null) {
        return;
      }

      final selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      _dateController.text = formatIncidentDateTime(selectedDateTime);
      if (mounted) {
        FocusScope.of(context).requestFocus(_descriptionFocus);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memilih tanggal/waktu. Coba lagi.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.incident.title);
    _dateController = TextEditingController(
      text: formatIncidentDateTime(widget.incident.incidentAt),
    );
    _descriptionController = TextEditingController(
      text: widget.incident.description,
    );
    _socAnalystController = TextEditingController(
      text: widget.incident.socAnalyst,
    );
    _selectedSeverity = widget.incident.severity;
    _selectedStatus = widget.incident.status;
    _selectedIncidentType = widget.incident.incidentType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _socAnalystController.dispose();
    _titleFocus.dispose();
    _dateFocus.dispose();
    _descriptionFocus.dispose();
    _socAnalystFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IncidentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Insiden')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update Data Insiden',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Lakukan perubahan lalu simpan.',
                      style: TextStyle(color: Color(0xFF667085)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: widget.incident.incidentCode,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'ID Insiden',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      focusNode: _titleFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_dateFocus);
                      },
                      decoration: const InputDecoration(labelText: 'Judul'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Judul wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dateController,
                      focusNode: _dateFocus,
                      readOnly: true,
                      onTap: _pickDateTime,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tanggal & Waktu',
                        hintText: 'Contoh: 22-02-2026 14:30',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Tanggal & waktu wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSeverity,
                      decoration: const InputDecoration(labelText: 'Severity'),
                      items: const [
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                        DropdownMenuItem(
                          value: 'Medium',
                          child: Text('Medium'),
                        ),
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
                        DropdownMenuItem(
                          value: 'Closed',
                          child: Text('Closed'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedStatus = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocus,
                      minLines: 3,
                      maxLines: 4,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _descriptionFocus.unfocus(),
                      decoration: const InputDecoration(labelText: 'Deskripsi'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Deskripsi wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedIncidentType,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Insiden',
                      ),
                      items: _incidentTypeOptions
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedIncidentType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _socAnalystController,
                      focusNode: _socAnalystFocus,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _socAnalystFocus.unfocus(),
                      decoration: const InputDecoration(
                        labelText: 'Analis SOC',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Analis SOC wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              if (_isSubmitting) {
                                return;
                              }
                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              setState(() => _isSubmitting = true);
                              try {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                await provider.updateIncident(
                                  id: widget.incident.id,
                                  incidentCode: widget.incident.incidentCode,
                                  title: _titleController.text.trim(),
                                  incidentAt: parseIncidentDateTime(
                                    _dateController.text.trim(),
                                  ),
                                  severity: _selectedSeverity,
                                  incidentType: _selectedIncidentType,
                                  socAnalyst: _socAnalystController.text.trim(),
                                  description: _descriptionController.text
                                      .trim(),
                                  status: _selectedStatus,
                                );
                                if (mounted) {
                                  navigator.pop(true);
                                }
                              } catch (_) {
                                if (!mounted) {
                                  return;
                                }
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Gagal memperbarui insiden. Coba lagi.',
                                    ),
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isSubmitting = false);
                                }
                              }
                            },
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text(
                        _isSubmitting ? 'Menyimpan...' : 'Update Insiden',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
