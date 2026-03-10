import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cyber_incident_log/providers/incident_provider.dart';
import 'package:cyber_incident_log/screens/add_incident_screen.dart';
import 'package:cyber_incident_log/services/incident_repository.dart';

void main() {
  testWidgets('Add form validates and saves incident', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1600));
    final provider = IncidentProvider(repository: InMemoryIncidentRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<IncidentProvider>.value(
          value: provider,
          child: const AddIncidentScreen(),
        ),
      ),
    );

    final saveButton = find.widgetWithText(ElevatedButton, 'Simpan Insiden');
    await tester.scrollUntilVisible(
      saveButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Judul wajib diisi'), findsOneWidget);
    expect(find.text('Tanggal & waktu wajib diisi'), findsOneWidget);
    expect(find.text('Deskripsi wajib diisi'), findsOneWidget);
    expect(find.text('Analis SOC wajib diisi'), findsOneWidget);
    expect(provider.incidents, isEmpty);

    await tester.enterText(find.byType(TextFormField).at(0), 'Server down');
    await tester.tap(find.byType(TextFormField).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'Terjadi outage pada API gateway.',
    );
    await tester.enterText(find.byType(TextFormField).at(3), 'SOC Tester');

    await tester.scrollUntilVisible(
      saveButton,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(provider.incidents.length, 1);
    expect(provider.incidents.first.title, 'Server down');
    expect(provider.incidents.first.socAnalyst, 'SOC Tester');

    await tester.binding.setSurfaceSize(null);
  });
}
