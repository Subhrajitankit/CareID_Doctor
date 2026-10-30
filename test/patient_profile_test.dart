import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/patients/patient_profile_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  Widget createTestWidget({Patient? patientArg, NavigatorObserver? observer}) {
    return MaterialApp(
      navigatorObservers: observer != null ? [observer] : [],
      routes: {
        AppRoutes.patientProfile: (context) =>
            PatientProfileScreen(patientArg: patientArg),
        AppRoutes.medicalRecords: (context) => Scaffold(
          appBar: AppBar(title: const Text('Medical Records Page')),
          body: const Text('Medical Records Body'),
        ),
        AppRoutes.prescriptionBuilder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Prescription Builder Page')),
          body: const Text('Prescription Builder Body'),
        ),
        AppRoutes.createReferral: (context) => Scaffold(
          appBar: AppBar(title: const Text('Create Referral Page')),
          body: const Text('Create Referral Body'),
        ),
        AppRoutes.addAddendum: (context) => Scaffold(
          appBar: AppBar(title: const Text('Add Addendum Page')),
          body: const Text('Add Addendum Body'),
        ),
        AppRoutes.notificationCenter: (context) => Scaffold(
          appBar: AppBar(title: const Text('Notification Center Page')),
          body: const Text('Notification Center Body'),
        ),
        AppRoutes.cameraPermission: (context) => Scaffold(
          appBar: AppBar(title: const Text('Camera Permission Page')),
          body: const Text('Camera Permission Body'),
        ),
        AppRoutes.appointmentsOverview: (context) => Scaffold(
          appBar: AppBar(title: const Text('Appointments Overview Page')),
          body: const Text('Appointments Overview Body'),
        ),
        AppRoutes.dashboard: (context) => Scaffold(
          appBar: AppBar(title: const Text('Dashboard Page')),
          body: const Text('Dashboard Body'),
        ),
      },
      home: PatientProfileScreen(patientArg: patientArg),
    );
  }

  testWidgets(
    'PatientProfileScreen renders exact Figma node 10:1635 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Top App Bar
      expect(find.text('Patient Profile'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

      // 2. Patient Header Card
      expect(find.text('Eleanor Thompson'), findsOneWidget);
      expect(find.byIcon(Icons.verified), findsOneWidget);
      expect(find.text('CR-8829-4410-X'), findsOneWidget);
      expect(find.text('42 Years'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('B+ Positive'), findsWidgets);

      // 3. Scrollable Tabs
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Records'), findsOneWidget);
      expect(find.text('Labs'), findsOneWidget);
      expect(find.text('Prescriptions'), findsOneWidget);
      expect(find.text('Insurance'), findsWidgets);
      expect(find.text('Timeline'), findsOneWidget);

      // 4. Clinical Alerts - Known Allergies
      expect(find.text('Known Allergies'), findsOneWidget);
      expect(find.text('Penicillin'), findsOneWidget);
      expect(find.text('Latex'), findsOneWidget);
      expect(find.text('Peanuts'), findsOneWidget);

      // 5. Behavioural Figures - Other Relevant Info
      expect(find.text('Other Relevant Info'), findsOneWidget);
      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('Height'), findsOneWidget);
      expect(find.text('Behavoiour'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);

      // 6. Latest Vitals Bento Grid
      expect(find.text('Latest Vitals'), findsOneWidget);
      expect(find.text('BLOOD PRESSURE'), findsOneWidget);
      expect(find.text('120/80'), findsOneWidget);
      expect(find.text('HEART RATE'), findsOneWidget);
      expect(find.text('72'), findsOneWidget);
      expect(find.text('TEMP'), findsOneWidget);
      expect(find.text('98.6'), findsOneWidget);
      expect(find.text('SPO2'), findsOneWidget);
      expect(find.text('98'), findsOneWidget);

      // 7. Internal Review Comments
      await tester.ensureVisible(find.text('Internal Review Comments'));
      expect(find.text('Internal Review Comments'), findsOneWidget);
      expect(find.text('No internal comments yet'), findsOneWidget);
      expect(find.text('Add internal comment'), findsOneWidget);

      // 8. Current Medications
      await tester.ensureVisible(find.text('Current Medications'));
      expect(find.text('Current Medications'), findsOneWidget);
      expect(find.text('VIEW ALL'), findsOneWidget);
      expect(find.text('Lisinopril'), findsOneWidget);
      expect(find.text('Metformin'), findsOneWidget);

      // 9. Insurance Summary
      await tester.ensureVisible(find.text('Premium Global Care'));
      expect(find.text('Premium Global Care'), findsOneWidget);
      expect(find.text('Policy: #PGC-992-AX'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);

      // 10. Care Team & Contacts
      await tester.ensureVisible(find.text('Care Team & Contacts'));
      expect(find.text('Care Team & Contacts'), findsOneWidget);
      expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
      expect(find.text('Mark Thompson (Husband)'), findsOneWidget);

      // 11. Action Buttons
      await tester.ensureVisible(find.text('Refer a Doctor'));
      expect(find.text('Refer a Doctor'), findsOneWidget);
      expect(find.text('View Health Records'), findsOneWidget);

      // 12. Floating Bottom Navigation Shell
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    },
  );

  testWidgets('PatientProfileScreen supports dynamic Patient data model', (
    WidgetTester tester,
  ) async {
    const customPatient = Patient(
      id: 'p-custom-99',
      name: 'Elena Rodriguez',
      age: 38,
      gender: 'Female',
      bloodGroup: 'O+',
      careId: 'CR-1122-3344-Y',
      allergies: ['Aspirin', 'Sulfa'],
    );

    await tester.pumpWidget(createTestWidget(patientArg: customPatient));
    await tester.pumpAndSettle();

    expect(find.text('Elena Rodriguez'), findsOneWidget);
    expect(find.text('CR-1122-3344-Y'), findsOneWidget);
    expect(find.text('38 Years'), findsOneWidget);
    expect(find.text('O+ Positive'), findsWidgets);
    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.text('Sulfa'), findsOneWidget);
  });

  testWidgets('PatientProfileScreen navigation buttons trigger correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Tap Refer a Doctor button
    await tester.ensureVisible(find.text('Refer a Doctor'));
    await tester.tap(find.text('Refer a Doctor'));
    await tester.pumpAndSettle();
    expect(find.text('Create Referral Page'), findsOneWidget);

    // Go back
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Tap View Health Records button
    await tester.ensureVisible(find.text('View Health Records'));
    await tester.tap(find.text('View Health Records'));
    await tester.pumpAndSettle();
    expect(find.text('Medical Records Page'), findsOneWidget);

    // Go back
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Tap Add internal comment
    await tester.ensureVisible(find.text('Add internal comment'));
    await tester.tap(find.text('Add internal comment'));
    await tester.pumpAndSettle();
    expect(find.text('Add Addendum Page'), findsOneWidget);
  });

  testWidgets('PatientProfileScreen tabs and bottom nav navigate correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Tap Records tab
    await tester.tap(find.text('Records'));
    await tester.pumpAndSettle();
    expect(find.text('Medical Records Page'), findsOneWidget);

    // Go back
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Tap Center QR scan button
    await tester.tap(find.byIcon(Icons.qr_code_scanner_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Camera Permission Page'), findsOneWidget);
  });
}
