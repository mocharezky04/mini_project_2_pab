import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import '../utils/incident_datetime_formatter.dart';

class AddIncidentScreen extends StatefulWidget {
  const AddIncidentScreen({super.key});

  @override
  State<AddIncidentScreen> createState() => _AddIncidentScreenState();
}

class _AddIncidentScreenState extends State<AddIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _socAnalystController = TextEditingController();
  final _titleFocus = FocusNode();
  final _dateFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _socAnalystFocus = FocusNode();
  bool _isSubmitting = false;

  String _selectedSeverity = 'Low';
  String _selectedIncidentType = 'Phishing';

  static const List<String> _incidentTypeOptions = [
    'Phishing',
    'Malware (Trojan)',
    'DDoS',
    'Unauthorized Access',
    'Data Leak',
  ];

  Future<void> _pickDateTime() async {
    try {
      final now = DateTime.now();
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
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
        initialTime: TimeOfDay.fromDateTime(now),
      );
      if (pickedTime == null) {
        return;
      }

      final formattedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      _dateController.text = formatIncidentDateTime(formattedDate);
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
    final incidentProvider = Provider.of<IncidentProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Insiden')),
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
                      'Form Insiden',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Isi data insiden keamanan dengan lengkap.',
                      style: TextStyle(color: Color(0xFF667085)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      focusNode: _titleFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_dateFocus);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Judul Insiden',
                      ),
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
                                await incidentProvider.createIncident(
                                  title: _titleController.text.trim(),
                                  incidentAt: parseIncidentDateTime(
                                    _dateController.text.trim(),
                                  ),
                                  severity: _selectedSeverity,
                                  incidentType: _selectedIncidentType,
                                  socAnalyst: _socAnalystController.text.trim(),
                                  description: _descriptionController.text
                                      .trim(),
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
                                      'Gagal menyimpan insiden. Coba lagi.',
                                    ),
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isSubmitting = false);
                                }
                              }
                            },
                      icon: const Icon(Icons.save_outlined),
                      label: Text(
                        _isSubmitting ? 'Menyimpan...' : 'Simpan Insiden',
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
