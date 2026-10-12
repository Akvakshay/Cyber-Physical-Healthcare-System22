// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:medirescue/app.dart';
import 'package:medirescue/providers/medical_profile_provider.dart';
import 'package:medirescue/screens/medical_profile/add_prescription_screen.dart';
import 'package:medirescue/screens/medical_profile/medical_profile_screen.dart';
import 'package:medirescue/widgets/voice_recording_sheet.dart';

void main() {
  testWidgets('App renders login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediRescueApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });

  testWidgets('MedicalProfileScreen renders floating actions for voice and prescription',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MedicalProfileProvider()),
        ],
        child: const MaterialApp(
          home: MedicalProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A. Demographics'), findsOneWidget);
    expect(find.text('B. Emergency Type'), findsOneWidget);
    expect(find.byIcon(Icons.mic), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('AddPrescriptionScreen renders upload card, options, and form fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MedicalProfileProvider()),
        ],
        child: const MaterialApp(
          home: AddPrescriptionScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('C. Add Prescription'), findsOneWidget);
    expect(find.text('Tap to upload prescription'), findsOneWidget);
    expect(find.text('Take Photo'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('prescription_01.jpg'), findsOneWidget);
    expect(find.text("Doctor's Name"), findsOneWidget);
    expect(find.text('Prescription Date'), findsOneWidget);
    expect(find.text('Medicines / Notes'), findsOneWidget);
    expect(find.text('SAVE PRESCRIPTION'), findsOneWidget);
  });

  testWidgets('VoiceRecordingSheet renders recording controls and timer',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VoiceRecordingSheet(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Recording...'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Stop'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
