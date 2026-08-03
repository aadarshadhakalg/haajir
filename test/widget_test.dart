import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haajir/screens/attendance_detail_screen.dart';

void main() {
  testWidgets('stats card renders Firestore-backed values', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StatsCard(totalDays: 12, year: 2026)),
      ),
    );

    expect(find.text('12'), findsOneWidget);
    expect(find.text('days in 2026'), findsOneWidget);
    expect(find.text('Synced from Firestore'), findsOneWidget);
  });
}
