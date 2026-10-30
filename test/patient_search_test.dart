import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/patients/patient_search_screen.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  const testPatients = [
    Patient(
      id: 'p-elena-1',
      name: 'Elena Rodriguez Garcia',
      age: 34,
      gender: 'Female',
      bloodGroup: 'O+',
      careId: 'HV-9021',
      isCritical: true,
      queueStatus: 'waiting',
      primaryComplaint: 'Severe Acute Asthma & Hypoxia',
    ),
    Patient(
      id: 'p-elena-2',
      name: 'Elena M. Thompson',
      age: 52,
      gender: 'Female',
      bloodGroup: 'A+',
      careId: 'HV-7732',
      isCritical: false,
      queueStatus: 'in_progress',
      primaryComplaint: 'Post-operative observation',
    ),
    Patient(
      id: 'p-elena-3',
      name: 'Elena Petrova',
      age: 28,
      gender: 'Female',
      bloodGroup: 'B-',
      careId: 'HV-1149',
      isCritical: false,
      queueStatus: 'done',
      primaryComplaint: 'Outpatient Follow-up Consultation',
    ),
  ];

  Widget createTestWidget({String? initialQuery, List<Patient>? patients}) {
    return MaterialApp(
      routes: {
        AppRoutes.patientSearch: (context) => PatientSearchScreen(
          initialQuery: initialQuery,
          customPatients: patients,
        ),
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
      home: PatientSearchScreen(
        initialQuery: initialQuery,
        customPatients: patients,
      ),
    );
  }

  testWidgets(
    'PatientSearchScreen renders exact Figma node 10:1511 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(initialQuery: 'Elena', patients: testPatients),
      );
      await tester.pumpAndSettle();

      // 1. Top App Bar (node 10:1537)
      expect(find.text('Search Results'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

      // 2. Search Input
      expect(find.text('Search ID, Name, or MRN...'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(
        find.byIcon(Icons.cancel),
        findsOneWidget,
      ); // Because query 'Elena' is present

      // 3. Section - Header Info & Sort (node 10:1546)
      expect(find.text('3 Results for "Elena"'), findsOneWidget);
      expect(
        find.text('Matching patient records found in your directory'),
        findsOneWidget,
      );
      expect(find.text('Recently Visited'), findsOneWidget);

      // 4. Section - Filter Chips (node 10:1561)
      expect(find.text('All Results'), findsOneWidget);
      expect(find.text('Critical'), findsWidgets); // chip + card status badge
      expect(find.text('In-Patient'), findsOneWidget);
      expect(
        find.text('Out-Patient'),
        findsWidgets,
      ); // chip + card status badge
      expect(find.text('Emergency'), findsOneWidget);
      expect(find.text('Follow-up'), findsOneWidget);

      // 5. Patient Result Cards (node 10:1574)
      expect(find.text('Elena Rodriguez Garcia'), findsOneWidget);
      expect(find.text('Elena M. Thompson'), findsOneWidget);
      expect(find.text('Elena Petrova'), findsOneWidget);
      expect(find.text('ID: HV-9021'), findsOneWidget);
      expect(find.text('ID: HV-7732'), findsOneWidget);
      expect(find.text('ID: HV-1149'), findsOneWidget);

      // Action Buttons
      expect(find.text('Vitals'), findsWidgets);
      expect(find.text('History'), findsWidgets);
      expect(find.text('Open File'), findsNWidgets(3));

      // 6. Bottom Navigation Shell (node 10:1512)
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    },
  );

  testWidgets('Search query dynamically filters patients', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(patients: testPatients));
    await tester.pumpAndSettle();

    // All 3 patients visible initially
    expect(find.text('Elena Rodriguez Garcia'), findsOneWidget);
    expect(find.text('Elena M. Thompson'), findsOneWidget);
    expect(find.text('Elena Petrova'), findsOneWidget);

    // Enter search query
    await tester.enterText(find.byType(TextField), 'Thompson');
    await tester.pumpAndSettle();

    expect(find.text('1 Results for "Thompson"'), findsOneWidget);
    expect(find.text('Elena M. Thompson'), findsOneWidget);
    expect(find.text('Elena Rodriguez Garcia'), findsNothing);
    expect(find.text('Elena Petrova'), findsNothing);

    // Clear search
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pumpAndSettle();

    expect(find.text('3 Patient Records'), findsOneWidget);
    expect(find.text('Elena Rodriguez Garcia'), findsOneWidget);
    expect(find.text('Elena M. Thompson'), findsOneWidget);
    expect(find.text('Elena Petrova'), findsOneWidget);
  });

  testWidgets('Filter chips filter results by clinical category', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(patients: testPatients));
    await tester.pumpAndSettle();

    // Tap Critical filter chip
    await tester.tap(find.text('Critical').first);
    await tester.pumpAndSettle();

    expect(find.text('Elena Rodriguez Garcia'), findsOneWidget);
    expect(find.text('Elena M. Thompson'), findsNothing);
    expect(find.text('Elena Petrova'), findsNothing);

    // Tap In-Patient filter chip
    await tester.tap(find.text('In-Patient'));
    await tester.pumpAndSettle();

    expect(find.text('Elena M. Thompson'), findsOneWidget);
    expect(
      find.text('Elena Rodriguez Garcia'),
      findsOneWidget,
    ); // waiting/in_progress
    expect(find.text('Elena Petrova'), findsNothing); // done

    // Tap All Results to restore
    await tester.tap(find.text('All Results'));
    await tester.pumpAndSettle();

    expect(find.text('Elena Rodriguez Garcia'), findsOneWidget);
    expect(find.text('Elena M. Thompson'), findsOneWidget);
    expect(find.text('Elena Petrova'), findsOneWidget);
  });

  testWidgets('Sort picker opens bottom sheet and changes sort order', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(patients: testPatients));
    await tester.pumpAndSettle();

    // Tap sort dropdown bar
    await tester.tap(find.text('Recently Visited'));
    await tester.pumpAndSettle();

    expect(find.text('Sort Patients By'), findsOneWidget);
    expect(find.text('Name: A to Z'), findsOneWidget);
    expect(find.text('Name: Z to A'), findsOneWidget);
    expect(find.text('Risk: High to Low'), findsOneWidget);

    // Select Name: Z to A
    await tester.tap(find.text('Name: Z to A'));
    await tester.pumpAndSettle();

    expect(find.text('Name: Z to A'), findsOneWidget);
  });

  testWidgets('Tapping Open File navigates to Patient Profile', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(patients: testPatients));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open File').first);
    await tester.pumpAndSettle();

    expect(find.text('Patient Profile Screen'), findsOneWidget);
  });

  testWidgets('Tapping Notification bell navigates to Notification Center', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(patients: testPatients));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Notification Center Screen'), findsOneWidget);
  });

  testWidgets('Empty search shows EmptyStateView with Scan QR action', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(patients: testPatients));
    await tester.pumpAndSettle();

    // Enter non-matching query
    await tester.enterText(find.byType(TextField), 'NonExistentPatient123');
    await tester.pumpAndSettle();

    expect(find.text('No Patients Found'), findsOneWidget);
    expect(find.text('Scan QR Code Instead'), findsOneWidget);

    // Tap Scan QR Code Instead
    await tester.tap(find.text('Scan QR Code Instead'));
    await tester.pumpAndSettle();

    expect(find.text('Camera Permission Screen'), findsOneWidget);
  });
}
