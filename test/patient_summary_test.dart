import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/patients/patient_summary_screen.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  const testPatient = Patient(
    id: 'p-test-eleanor',
    name: 'Eleanor Thompson',
    age: 42,
    gender: 'Female',
    bloodGroup: 'B+',
    careId: '8829-4410-X',
    isCritical: false,
    queueStatus: 'in_progress',
    scheduledTime: '10:30 AM',
    primaryComplaint: 'Hypertension & Type 2 Diabetes Management',
    allergies: ['Penicillin', 'Latex', 'Peanuts'],
    chronicConditions: ['Hypertension', 'Type 2 Diabetes'],
  );

  Widget createTestWidget({Patient? patient}) {
    return MaterialApp(
      routes: {
        AppRoutes.patientSummary: (context) =>
            PatientSummaryScreen(patientArg: patient),
        AppRoutes.patientProfile: (context) =>
            const Scaffold(body: Text('Patient Profile Screen')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
        AppRoutes.notificationCenter: (context) =>
            const Scaffold(body: Text('Notification Center Screen')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission Screen')),
      },
      home: PatientSummaryScreen(patientArg: patient),
    );
  }

  testWidgets(
    'PatientSummaryScreen renders exact Figma node 10:1346 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(patient: testPatient));
      await tester.pumpAndSettle();

      // 1. Top App Bar (Node 10:1347)
      expect(find.text('Patient Summary'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

      // 2. Patient Profile Card (Node 10:1359)
      expect(find.text('Eleanor Thompson'), findsOneWidget);
      expect(find.text('CR-ID: 8829-4410-X'), findsOneWidget);
      expect(find.text('42 Years'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('B+ Positive'), findsOneWidget);
      expect(find.byIcon(Icons.verified_rounded), findsOneWidget);

      // 3. Known Allergies Alert Card (Node 10:1377)
      expect(find.text('Known Allergies'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.text('Penicillin'), findsOneWidget);
      expect(find.text('Latex'), findsOneWidget);
      expect(find.text('Peanuts'), findsOneWidget);

      // 4. Insurance Status Card (Node 10:1390)
      expect(find.text('INSURANCE STATUS'), findsOneWidget);
      expect(find.text('Premium Global Care'), findsOneWidget);
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

      // 5. Clinical Assignment Card (Node 10:1400)
      expect(find.text('Clinical Assignment'), findsOneWidget);
      expect(find.text('Primary Physician'), findsOneWidget);
      expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
      expect(find.text('Emergency Contact'), findsOneWidget);
      expect(find.text('Mark Thompson (Husband)'), findsOneWidget);
      expect(find.text('+1 (555) 092-4412'), findsOneWidget);

      // 6. Current Medications Card (Node 10:1426)
      expect(find.text('Current Medications'), findsOneWidget);
      expect(find.text('Lisinopril 10mg'), findsOneWidget);
      expect(find.text('1x Daily (Morning)'), findsOneWidget);
      expect(find.text('Metformin 500mg'), findsOneWidget);
      expect(find.text('2x Daily (Post-meal)'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsNWidgets(2));

      // 7. Recent Vitals Trend Card (Node 10:1448)
      expect(find.text('Recent Vitals Trend'), findsOneWidget);
      expect(find.text('BP'), findsOneWidget);
      expect(find.text('120/80'), findsOneWidget);
      expect(find.text('Stable'), findsOneWidget);
      expect(find.text('Heart Rate'), findsOneWidget);
      expect(find.text('72 bpm'), findsOneWidget);
      expect(find.text('SpO2'), findsOneWidget);
      expect(find.text('98%'), findsOneWidget);
      expect(find.text('Optimal'), findsOneWidget);
      expect(find.text('Temp'), findsOneWidget);
      expect(find.text('98.6°F'), findsOneWidget);
      expect(
        find.text('Normal'),
        findsNWidgets(2),
      ); // Heart Rate Normal + Temp Normal

      // 8. Action Pad (Nodes 10:1476 & 10:1481)
      expect(find.text('Open Full Profile'), findsOneWidget);
      expect(find.text('Scan Another QR'), findsOneWidget);

      // 9. Bottom Navigation Shell (Node 10:1486)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsWidgets);
    },
  );

  testWidgets('Tapping Open Full Profile navigates to Patient Profile', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(patient: testPatient));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Open Full Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Full Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Patient Profile Screen'), findsOneWidget);
  });

  testWidgets('Tapping Scan Another QR navigates to Camera Permission', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(patient: testPatient));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Scan Another QR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scan Another QR'));
    await tester.pumpAndSettle();

    expect(find.text('Camera Permission Screen'), findsOneWidget);
  });

  testWidgets('Tapping notification bell navigates to Notification Center', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(patient: testPatient));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Notification Center Screen'), findsOneWidget);
  });
}
