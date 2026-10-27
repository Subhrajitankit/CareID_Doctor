import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/appointments/appointments_overview_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp(
      routes: {
        AppRoutes.appointmentsOverview: (context) =>
            const AppointmentsOverviewScreen(),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile')),
        AppRoutes.notificationCenter: (context) =>
            const Scaffold(body: Text('Notification Center')),
        AppRoutes.appointmentDetails: (context) =>
            const Scaffold(body: Text('Appointment Details')),
        AppRoutes.rescheduleAppointment: (context) =>
            const Scaffold(body: Text('Reschedule Appointment')),
      },
      home: const AppointmentsOverviewScreen(),
    );
  }

  testWidgets(
      'AppointmentsOverviewScreen renders Figma node 10:5164 elements correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify Header Bar
    expect(find.text('Clinical Appointments'), findsOneWidget);
    expect(find.text('Triage & Schedule Flow'), findsOneWidget);

    // Verify Status Filter Chips
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);

    // Verify Date Navigator & Search
    expect(find.text('Today • Oct 18, 2026'), findsOneWidget);
    expect(
      find.text('Search appointments by patient, ID, or procedure...'),
      findsOneWidget,
    );

    // Verify Patient Cards
    expect(find.text('Robert J. Sterling'), findsOneWidget);
    expect(find.text('Eleanor Pena'), findsOneWidget);
    expect(find.text('Arthur Miller'), findsOneWidget);

    // Verify Status Badges
    expect(find.text('Confirmed'), findsNWidgets(2));
    expect(find.text('Requested'), findsOneWidget);

    // Verify Action Buttons
    expect(find.text('Reschedule'), findsNWidgets(2));
    expect(find.text('Review Request'), findsOneWidget);
    expect(find.text('View Details'), findsNWidgets(3));

    // Verify Bottom Caseload Banner
    expect(find.text("Today's Caseload"), findsOneWidget);
    expect(find.text('Sync with Hospital EHR'), findsOneWidget);
  });

  testWidgets('Search input filters appointments correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Search for Eleanor
    await tester.enterText(find.byType(TextField), 'Eleanor');
    await tester.pumpAndSettle();

    expect(find.text('Eleanor Pena'), findsOneWidget);
    expect(find.text('Robert J. Sterling'), findsNothing);
    expect(find.text('Arthur Miller'), findsNothing);

    // Clear search
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    expect(find.text('Robert J. Sterling'), findsOneWidget);
    expect(find.text('Eleanor Pena'), findsOneWidget);
    expect(find.text('Arthur Miller'), findsOneWidget);
  });

  testWidgets('Status tab switching updates selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Tap Completed tab
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();

    expect(find.text('Completed'), findsOneWidget);
  });
}
