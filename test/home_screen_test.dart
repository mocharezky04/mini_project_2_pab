import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cyber_incident_log/providers/incident_provider.dart';
import 'package:cyber_incident_log/screens/home_screen.dart';
import 'package:cyber_incident_log/services/incident_repository.dart';

void main() {
  testWidgets('Delete action asks confirmation and supports cancel/confirm', (
    tester,
  ) async {
    final provider = IncidentProvider(repository: InMemoryIncidentRepository());
    await provider.createIncident(
      title: 'Test Incident',
      incidentAt: DateTime(2026, 3, 9, 10, 00),
      severity: 'High',
      incidentType: 'Phishing',
      socAnalyst: 'SOC Tester',
      description: 'Deskripsi test',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<IncidentProvider>.value(
          value: provider,
          child: const HomeScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(provider.incidents.length, 1);

    await tester.tap(find.byTooltip('Hapus insiden'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Konfirmasi Hapus'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(provider.incidents.length, 1);

    await tester.tap(find.byTooltip('Hapus insiden'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.tap(find.text('Hapus'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(provider.incidents, isEmpty);
    expect(find.text('Insiden berhasil dihapus'), findsOneWidget);
  });
}
