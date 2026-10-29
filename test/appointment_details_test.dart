import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/appointments/appointment_details_screen.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp(
      routes: {
        AppRoutes.appointmentDetails: (context) =>
            const AppointmentDetailsScreen(),
        AppRoutes.patientProfile: (context) =>
            const Scaffold(body: Text('Patient Profile Screen')),
        AppRoutes.rescheduleAppointment: (context) =>
            const Scaffold(body: Text('Reschedule Appointment Screen')),
        AppRoutes.cancelAppointment: (context) =>
            const Scaffold(body: Text('Cancel Appointment Screen')),
        AppRoutes.notificationCenter: (context) =>
            const Scaffold(body: Text('Notification Center Screen')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
        AppRoutes.referralDetails: (context) =>
            const Scaffold(body: Text('Referral Details Screen')),
      },
      home: const AppointmentDetailsScreen(),
    );
  }

  testWidgets(
      'AppointmentDetailsScreen renders exact Figma node 10:4923 components',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify Title Header
    expect(find.text('Appointment Details'), findsOneWidget);
    expect(
      find.text('Encounter schedule & clinician authorization'),
      findsOneWidget,
    );

    // Verify Status Hero Card
    expect(find.text('CONFIRMED • UPCOMING'), findsOneWidget);
    expect(find.text('In 2 Hours'), findsOneWidget);
    expect(find.text('#APT-88204-NY'), findsOneWidget);
    expect(find.text('45-minute In-Person Evaluation'), findsOneWidget);

    // Verify Referral Inbound Card
    expect(find.text('Referred Patient'), findsOneWidget);
    expect(find.text('Ref #REF-4491'), findsOneWidget);
    expect(find.text('View Inbound Referral Packet'), findsOneWidget);

    // Verify Critical Clinical Alerts
    expect(find.text('Critical Clinical Alerts'), findsOneWidget);
    expect(find.text('SEVERE ALLERGY'), findsOneWidget);
    expect(find.text('KNOWN CONDITION'), findsOneWidget);

    // Verify Patient Summary Card
    expect(find.text('O Pos (+)'), findsOneWidget);
    expect(find.text('Insured • BlueCross'), findsOneWidget);
    expect(find.text('EHR Pre-authorized'), findsOneWidget);
    expect(find.text('Emergency Contact'), findsOneWidget);
    expect(find.text('Sarah Sterling (Wife)'), findsOneWidget);
    expect(find.text('Call'), findsOneWidget);
    expect(find.text('View Full Patient Medical Profile'), findsOneWidget);

    // Verify Specification & Logistics Bento
    expect(find.text('Specification & Logistics'), findsOneWidget);
    expect(find.text('Room 412'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Wednesday, Oct 18, 2026'), findsOneWidget);
    expect(find.text('Facility Location'), findsOneWidget);
    expect(find.text('Mount Sinai Hospital • Heart Center'), findsOneWidget);
    expect(find.text('Chief Complaint'), findsOneWidget);
    expect(find.text('Pre-authorized Vault Records'), findsOneWidget);
    expect(find.text('5 Shared'), findsOneWidget);
    expect(find.text('Oct 10'), findsOneWidget);
    expect(find.text('Sep 28'), findsOneWidget);
    expect(find.text('Sep 20'), findsOneWidget);

    // Verify Clinical Actions
    expect(find.text('Clinical Actions'), findsOneWidget);
    expect(find.text('Start Clinical Visit'), findsOneWidget);
    expect(find.text('Reschedule'), findsOneWidget);
    expect(find.text('Cancel Visit'), findsOneWidget);

    // Verify Governance Policy Note (RichText)
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is RichText &&
            w.text.toPlainText().contains(
              'Care ID Clinical Governance Protocol:',
            ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Start Clinical Visit navigates to patient profile',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Start Clinical Visit'));
    await tester.tap(find.text('Start Clinical Visit'));
    await tester.pumpAndSettle();

    expect(find.text('Patient Profile Screen'), findsOneWidget);
  });

  testWidgets('Reschedule button navigates to reschedule screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Reschedule'));
    await tester.tap(find.text('Reschedule'));
    await tester.pumpAndSettle();

    expect(find.text('Reschedule Appointment Screen'), findsOneWidget);
  });

  testWidgets('Cancel Visit button navigates to cancel screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Cancel Visit'));
    await tester.tap(find.text('Cancel Visit'));
    await tester.pumpAndSettle();

    expect(find.text('Cancel Appointment Screen'), findsOneWidget);
  });
}
