import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/appointments/reschedule_success_screen.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  const figmaAppointment = Appointment(
    id: '88204-ny',
    patient: Patient(
      id: 'p-sterling',
      name: 'Robert J. Sterling',
      age: 45,
      gender: 'Male',
      bloodGroup: 'A+',
      careId: '8472-9901',
      allergies: [],
      chronicConditions: [],
    ),
    time: '10:30 AM',
    date: 'Saturday, Oct 21, 2026',
    type: 'In-Person Review',
    status: 'rescheduled',
    notes: 'Physician Emergency Duty',
  );

  Widget createTestWidget({Appointment? appointment}) {
    return MaterialApp(
      routes: {
        AppRoutes.rescheduleSuccess: (context) =>
            RescheduleSuccessScreen(appointmentArg: appointment),
        AppRoutes.appointmentDetails: (context) =>
            const Scaffold(body: Text('Appointment Details Screen')),
        AppRoutes.reviewReschedule: (context) =>
            const Scaffold(body: Text('Review Reschedule Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
        AppRoutes.patientProfile: (context) =>
            const Scaffold(body: Text('Patient Profile Screen')),
        AppRoutes.notificationCenter: (context) =>
            const Scaffold(body: Text('Notification Center Screen')),
      },
      home: RescheduleSuccessScreen(appointmentArg: appointment),
    );
  }

  testWidgets(
    'RescheduleSuccessScreen renders exact Figma node 10:5909 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(appointment: figmaAppointment));
      await tester.pumpAndSettle();

      // TopAppBar elements
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

      // SubHeader banner elements (Node 10:5913)
      expect(find.text('ENCOUNTER UPDATED'), findsOneWidget);
      expect(find.byIcon(Icons.event_available_rounded), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // Hero Card elements (Node 10:5924)
      expect(find.text('CONFIRMED • RESCHEDULED'), findsOneWidget);
      expect(find.text('Appointment Rescheduled'), findsOneWidget);
      expect(
        find.textContaining('Slot re-allocation successfully committed'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // Appointment Details Card (Node 10:5945)
      expect(find.text('Robert J. Sterling'), findsOneWidget);
      expect(find.text('45y, M'), findsOneWidget);
      expect(find.text('Care ID #8472-9901'), findsOneWidget);
      expect(find.text('#APT-88204-NY'), findsOneWidget);

      // New Date & Time block
      expect(find.text('New Date & Time'), findsOneWidget);
      expect(find.text('Saturday, Oct 21, 2026'), findsOneWidget);
      expect(find.textContaining('10:30 AM'), findsOneWidget);
      expect(find.textContaining('(45 Mins)'), findsOneWidget);

      // Location & Desk block
      expect(find.text('Location & Desk'), findsOneWidget);
      expect(find.text('Mount Sinai Heart Center'), findsOneWidget);
      expect(
        find.text('Suite 400 • Check-in Kiosk 2, Room 412'),
        findsOneWidget,
      );

      // Grid Metric Cards (Node 10:5986)
      expect(find.text('VISIT TYPE'), findsOneWidget);
      expect(find.text('In-Person Review'), findsOneWidget);
      expect(find.text('Calendar Dispatched'), findsOneWidget);
      expect(find.text('REFERRAL'), findsOneWidget);
      expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
      expect(find.text('#REF-4491'), findsOneWidget);

      // Express QR Pass Bar (Node 10:6011)
      expect(find.text('Express QR Patient Pass'), findsOneWidget);
      expect(find.text('SYNCED • V2.4'), findsOneWidget);

      // Governance & Audit Trail Card (Node 10:6020)
      expect(find.text('Governance & Audit Trail'), findsOneWidget);
      expect(find.text('Live Audit'), findsOneWidget);
      expect(find.text('Dispatch Confirmed'), findsOneWidget);
      expect(find.text('Hospital EHR Synchronized'), findsOneWidget);
      expect(find.text('Reschedule Justification'), findsOneWidget);
      expect(find.text('Physician Emergency Duty'), findsOneWidget);

      // Action Deck (Node 10:6058)
      expect(find.text('View Appointment Details'), findsOneWidget);
      expect(find.text('Back to Appointments Overview'), findsOneWidget);
      expect(find.text('View Robert J. Sterling Profile'), findsOneWidget);

      // Floating Bottom Navigation
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );

  testWidgets('RescheduleSuccessScreen action deck navigates correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(appointment: figmaAppointment));
    await tester.pumpAndSettle();

    // Scroll down to tap "View Appointment Details"
    final detailsBtn = find.text('View Appointment Details');
    await tester.ensureVisible(detailsBtn);
    await tester.tap(detailsBtn);
    await tester.pumpAndSettle();
    expect(find.text('Review Reschedule Screen'), findsOneWidget);
  });
}
