class Incident {
  String id;
  String incidentCode;
  String title;
  DateTime incidentAt;
  String severity;
  String incidentType;
  String socAnalyst;
  String description;
  String status;
  DateTime? createdAt;

  Incident({
    required this.id,
    required this.incidentCode,
    required this.title,
    required this.incidentAt,
    required this.severity,
    required this.incidentType,
    required this.socAnalyst,
    required this.description,
    required this.status,
    this.createdAt,
  });

  factory Incident.fromMap(Map<String, dynamic> map) {
    return Incident(
      id: map['id'] as String? ?? '',
      incidentCode: map['incident_code'] as String? ?? '',
      title: map['title'] as String? ?? '',
      incidentAt: DateTime.parse(map['incident_at'] as String),
      severity: map['severity'] as String? ?? 'Low',
      incidentType: map['incident_type'] as String? ?? '',
      socAnalyst: map['soc_analyst'] as String? ?? '',
      description: map['description'] as String? ?? '',
      status: map['status'] as String? ?? 'Open',
      createdAt: map['created_at'] == null
          ? null
          : DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'incident_code': incidentCode,
      'title': title,
      'incident_at': incidentAt.toUtc().toIso8601String(),
      'severity': severity,
      'incident_type': incidentType,
      'soc_analyst': socAnalyst,
      'description': description,
      'status': status,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'incident_code': incidentCode,
      'title': title,
      'incident_at': incidentAt.toUtc().toIso8601String(),
      'severity': severity,
      'incident_type': incidentType,
      'soc_analyst': socAnalyst,
      'description': description,
      'status': status,
    };
  }

  Incident copyWith({
    String? id,
    String? incidentCode,
    String? title,
    DateTime? incidentAt,
    String? severity,
    String? incidentType,
    String? socAnalyst,
    String? description,
    String? status,
    DateTime? createdAt,
  }) {
    return Incident(
      id: id ?? this.id,
      incidentCode: incidentCode ?? this.incidentCode,
      title: title ?? this.title,
      incidentAt: incidentAt ?? this.incidentAt,
      severity: severity ?? this.severity,
      incidentType: incidentType ?? this.incidentType,
      socAnalyst: socAnalyst ?? this.socAnalyst,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
