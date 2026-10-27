import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/dashboard/doctor_dashboard_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp(
      routes: {
        AppRoutes.dashboard: (context) => const DoctorDashboardScreen(),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory')),
        AppRoutes.referralDashboard: (context) =>
            const Scaffold(body: Text('Referral Dashboard')),
        AppRoutes.notificationCenter: (context) =>
            const Scaffold(body: Text('Notification Center')),
        AppRoutes.patientSearch: (context) =>
            const Scaffold(body: Text('Patient Search')),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile')),
        AppRoutes.patientProfile: (context) =>
            const Scaffold(body: Text('Patient Profile')),
      },
      home: const DoctorDashboardScreen(),
    );
  }

  testWidgets('Doctor Dashboard renders all sections correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify Greeting
    expect(find.textContaining('Good Morning, Dr.'), findsOneWidget);
    expect(
      find.textContaining('Chief Cardiologist • St. Jude Hospital'),
      findsOneWidget,
    );

    // Verify Stats Cards
    expect(find.text("TODAY'S PATIENTS"), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('REVIEW REFERRALS'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('CRITICAL'), findsWidgets);
    expect(find.text('1'), findsWidgets);

    // Verify Primary Quick Actions
    expect(find.text('Find Patient'), findsOneWidget);
    expect(find.text('Search by Name or ID'), findsOneWidget);
    expect(find.text('Scan QR'), findsOneWidget);
    expect(find.text('Launch visit interface'), findsOneWidget);

    // Verify Live Queue Header and Filters
    expect(find.textContaining('Live'), findsOneWidget);
    expect(find.text('View\nAll'), findsOneWidget);
    expect(find.text('Waiting'), findsOneWidget);
    expect(find.text('In\nProgress'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    // Verify Arthur Miller is in Waiting Queue
    expect(find.text('Arthur Miller'), findsOneWidget);

    // Verify Pending Tasks
    expect(find.text('Pending Tasks'), findsOneWidget);
    expect(find.text('Review Lab Report'), findsOneWidget);
    expect(find.text('Sign Prescriptions'), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    expect(find.text('4'), findsWidgets);

    // Verify Recently Viewed
    expect(find.text('Recently Viewed'), findsOneWidget);
    expect(find.text('E. Rose'), findsOneWidget);
    expect(find.text('#9832'), findsOneWidget);

    // Verify Bottom Navigation Items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Queue filter tab switches patients correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Initial state: Waiting tab selected, Arthur Miller visible
    expect(find.text('Arthur Miller'), findsOneWidget);

    // Tap In Progress tab
    await tester.tap(find.text('In\nProgress'));
    await tester.pumpAndSettle();

    // Now Sarah Jenkins should be visible
    expect(find.text('Sarah Jenkins'), findsOneWidget);

    // Tap Done tab
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Now Marcus Chen should be visible
    expect(find.text('Marcus Chen'), findsOneWidget);
  });

  testWidgets('Quick action navigates to Patient Search', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Find Patient'));
    await tester.pumpAndSettle();

    expect(find.text('Patient Search'), findsOneWidget);
  });
}
