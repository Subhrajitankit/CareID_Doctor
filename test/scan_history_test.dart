import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/qr_scan/scan_history_screen.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp(
      routes: {
        AppRoutes.scanHistory: (context) => const ScanHistoryScreen(),
        AppRoutes.patientProfile: (context) =>
            const Scaffold(body: Text('Patient Profile Screen')),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission Screen')),
        AppRoutes.notificationCenter: (context) =>
            const Scaffold(body: Text('Notification Center Screen')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
      },
      home: const ScanHistoryScreen(),
    );
  }

  testWidgets('ScanHistoryScreen renders exact Figma node 10:866 components', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Top App Bar
    expect(find.text('Scan History'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

    // Search & Filter Section
    expect(find.text('Search patients or dates...'), findsOneWidget);
    expect(find.text('All History'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('This Week'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);

    // Recent Scans Section Heading
    expect(find.text('Recent Scans'), findsOneWidget);

    // Verify Patient Cards from Figma
    expect(find.text('Elena Rodriguez'), findsOneWidget);
    expect(find.text('Marcus Chen'), findsOneWidget);
    expect(find.text('Sarah Jenkins'), findsOneWidget);
    expect(find.text('David Wilson'), findsOneWidget);
    expect(find.text('Amara Okafor'), findsOneWidget);

    // Status badges
    expect(find.text('Verified'), findsNWidgets(3));
    expect(find.text('Denied'), findsOneWidget);
    expect(find.text('Expired'), findsOneWidget);

    // Summary Stats Bento Cards
    expect(find.text('SCANNED'), findsOneWidget);
    expect(find.text('124'), findsOneWidget);
    expect(find.text('SUCCESS'), findsOneWidget);
    expect(find.text('98%'), findsOneWidget);
    expect(find.text('ISSUES'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Floating Action Button
    expect(find.byIcon(Icons.add_a_photo_rounded), findsOneWidget);

    // Bottom Navigation items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Search input filters patient scans accurately', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Enter search text 'Elena'
    await tester.enterText(find.byType(TextField), 'Elena');
    await tester.pumpAndSettle();

    expect(find.text('Elena Rodriguez'), findsOneWidget);
    expect(find.text('Marcus Chen'), findsNothing);
    expect(find.text('Sarah Jenkins'), findsNothing);

    // Clear search
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pumpAndSettle();

    expect(find.text('Elena Rodriguez'), findsOneWidget);
    expect(find.text('Marcus Chen'), findsOneWidget);
  });

  testWidgets('Filter chips filter list according to selection', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Tap 'Today' chip (May 12, 2024 items: Elena and Marcus)
    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();

    expect(find.text('Elena Rodriguez'), findsOneWidget);
    expect(find.text('Marcus Chen'), findsOneWidget);
    expect(find.text('Sarah Jenkins'), findsNothing);

    // Tap 'All History' to reset
    await tester.tap(find.text('All History'));
    await tester.pumpAndSettle();

    expect(find.text('Sarah Jenkins'), findsOneWidget);
  });

  testWidgets('Tapping a patient card navigates to patient profile', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Elena Rodriguez'));
    await tester.pumpAndSettle();

    expect(find.text('Patient Profile Screen'), findsOneWidget);
  });

  testWidgets('Tapping FAB navigates to camera permission', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_a_photo_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Camera Permission Screen'), findsOneWidget);
  });

  testWidgets('Tapping notification bell navigates to notification center', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Notification Center Screen'), findsOneWidget);
  });
}
