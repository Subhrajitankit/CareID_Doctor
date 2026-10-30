import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/patients/patient_directory_screen.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  const testPatients = [
    Patient(
      id: 'p-aditi',
      name: 'Aditi Sharma',
      age: 32,
      gender: 'Female',
      bloodGroup: 'B+',
      careId: '8829-0012',
      isCritical: false,
      scheduledTime: '09:00 AM',
      queueStatus: 'in_progress',
    ),
    Patient(
      id: 'p-benjamin',
      name: 'Benjamin Wright',
      age: 68,
      gender: 'Male',
      bloodGroup: 'O-',
      careId: '4410-9981',
      isCritical: true,
      scheduledTime: '10:00 AM',
      queueStatus: 'waiting',
    ),
    Patient(
      id: 'p-chen',
      name: 'Chen Wei',
      age: 29,
      gender: 'Male',
      bloodGroup: 'A+',
      careId: '1102-3345',
      isCritical: false,
      scheduledTime: '11:00 AM',
      queueStatus: 'waiting',
    ),
    Patient(
      id: 'p-dianne',
      name: 'Dianne Russell',
      age: 41,
      gender: 'Female',
      bloodGroup: 'AB-',
      careId: '7721-5509',
      isCritical: false,
      scheduledTime: '01:30 PM',
      queueStatus: 'done',
    ),
  ];

  Widget createTestWidget({List<Patient>? patients}) {
    return MaterialApp(
      routes: {
        AppRoutes.patientDirectory: (context) =>
            PatientDirectoryScreen(customPatients: patients),
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
      },
      home: PatientDirectoryScreen(customPatients: patients),
    );
  }

  testWidgets(
    'PatientDirectoryScreen renders exact Figma node 10:1104 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(patients: testPatients));
      await tester.pumpAndSettle();

      // Top App Bar
      expect(find.text('Patients'), findsNWidgets(2)); // Title & BottomNav
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

      // Search Bar
      expect(find.text('Search ID, Name, or MRN...'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);

      // Filter Chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Critical'), findsOneWidget);
      expect(find.text('Verified'), findsOneWidget);
      expect(find.text('Recently Viewed'), findsOneWidget);

      // Alphabetical List Header
      expect(find.text('Patient Records (4)'), findsOneWidget);
      expect(find.text('Sort'), findsOneWidget);

      // Patient Cards
      expect(find.text('Aditi Sharma'), findsOneWidget);
      expect(find.text('Benjamin Wright'), findsOneWidget);
      expect(find.text('Chen Wei'), findsOneWidget);
      expect(find.text('Dianne Russell'), findsOneWidget);

      // Bento box details
      expect(find.text('INTERNAL RATING'), findsNWidgets(4));
      expect(find.text('AGE/GENDER'), findsNWidgets(4));
      expect(find.text('BLOOD GROUP'), findsNWidgets(4));
      expect(find.text('32 / Female'), findsOneWidget);
      expect(find.text('68 / Male'), findsOneWidget);

      // Badges & Buttons
      expect(find.text('Active Insurance'), findsNWidgets(2));
      expect(find.text('High Risk'), findsOneWidget);
      expect(find.text('Pending Verification'), findsOneWidget);
      expect(find.text('Vitals'), findsOneWidget);
      expect(find.text('View History'), findsNWidgets(3));

      // Bottom Navigation
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );

  testWidgets('Search filters patients dynamically by name or ID', (
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

    // Enter search query 'Aditi'
    await tester.enterText(find.byType(TextField), 'Aditi');
    await tester.pumpAndSettle();

    expect(find.text('Aditi Sharma'), findsOneWidget);
    expect(find.text('Benjamin Wright'), findsNothing);
    expect(find.text('Patient Records (1)'), findsOneWidget);

    // Clear search
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pumpAndSettle();

    expect(find.text('Patient Records (4)'), findsOneWidget);
    expect(find.text('Benjamin Wright'), findsOneWidget);
  });

  testWidgets('Filter chips filter patients correctly', (
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

    // Tap 'Critical'
    await tester.tap(find.text('Critical'));
    await tester.pumpAndSettle();

    expect(find.text('Benjamin Wright'), findsOneWidget);
    expect(find.text('Aditi Sharma'), findsNothing);
    expect(find.text('Patient Records (1)'), findsOneWidget);

    // Tap 'All' to restore
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();

    expect(find.text('Patient Records (4)'), findsOneWidget);
  });

  testWidgets('Sort button toggles sorting order between A-Z and Z-A', (
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

    // Tap Sort button
    await tester.tap(find.text('Sort'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Sorted Z to A'), findsOneWidget);

    // Tap Sort again
    await tester.tap(find.text('Sort'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Sorted A to Z'), findsOneWidget);

    // Flush snackbar timer
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets('Tapping a patient card navigates to Patient Profile', (
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

    await tester.tap(find.text('Aditi Sharma'));
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

  testWidgets(
    'Tapping Doctor Avatar in TopAppBar navigates to Doctor Profile',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(patients: testPatients));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('doctor_avatar_button')));
      await tester.pumpAndSettle();

      expect(find.text('Doctor Profile Screen'), findsOneWidget);
    },
  );
}
