import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utsapp/main.dart';

void main() {
  testWidgets('Temperature Dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the dashboard title exists
    expect(find.text('Ringkasan Suhu'), findsOneWidget);
    expect(find.text('Detail Pengukuran'), findsOneWidget);
    expect(find.text('Periode Waktu'), findsOneWidget);

    // Verify temperature values
    expect(find.text('37°C'), findsOneWidget);
    expect(find.text('18°C'), findsOneWidget);
    expect(find.text('22.14°C'), findsOneWidget);

    // Verify that we have measurement icons
    expect(find.byIcon(Icons.thermostat), findsWidgets);
    expect(find.byIcon(Icons.water_drop), findsWidgets);
    expect(find.byIcon(Icons.wb_sunny), findsWidgets);
  });
}
