import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/appointments/reschedule_appointment_screen.dart';

import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  const figmaAppointment = Appointment(
    id: 'apt-figma-reschedule',
    patient: Patient(
      id: 'p-sterling',
      name: 'Robert J. Sterling',
      age: 45,
      gender: 'Male',
      bloodGroup: 'A+',
      careId: 'HV-94285-M',
      allergies: [],
      chronicConditions: [],
    ),
    time: '10:30 AM',
    date: 'Oct 18, 2026',
    type: 'Cardiology Evaluation',
    status: 'conflict',
    notes: 'Collision state',
  );

  Widget createTestWidget({Appointment? appointment}) {
    return MaterialApp(
      routes: {
        AppRoutes.rescheduleAppointment: (context) =>
            RescheduleAppointmentScreen(appointmentArg: appointment),
        AppRoutes.appointmentDetails: (context) =>
            const Scaffold(body: Text('Appointment Details Screen')),
        AppRoutes.rescheduleSuccess: (context) =>
            const Scaffold(body: Text('Reschedule Success Screen')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
        AppRoutes.notificationCenter: (context) =>
            const Scaffold(body: Text('Notification Center Screen')),
      },
      home: RescheduleAppointmentScreen(appointmentArg: appointment),
    );
  }

  testWidgets(
    'RescheduleAppointmentScreen renders exact Figma node 10:5393 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(appointment: figmaAppointment));
      await tester.pumpAndSettle();

      // Verify Sub-Header Navigation
      expect(find.text('Appointment Details'), findsOneWidget);
      expect(find.text('Conflict Detected'), findsOneWidget);

      // Verify Heading
      expect(find.text('Reschedule Slot'), findsOneWidget);
      expect(
        find.text(
          'Resolve physician calendar collision & dispatch re-booking notice',
        ),
        findsOneWidget,
      );

      // Verify Current Appointment Context Card
      expect(find.text('Collision State'), findsOneWidget);
      expect(find.text('Robert J. Sterling'), findsOneWidget);
      expect(find.text('45y'), findsOneWidget);
      expect(find.text('Mount Sinai Heart Center'), findsOneWidget);
      expect(find.text('Oct 18, 2026 • 10:30 AM'), findsOneWidget);

      // Verify Calendar Section
      expect(find.text('October 2026'), findsOneWidget);
      expect(find.text('Conflict Slot'), findsOneWidget);
      expect(find.text('Selected'), findsOneWidget);
      expect(find.text('Open Slots'), findsOneWidget);

      // Verify Time Slots Panel
      expect(find.text('Saturday, Oct 21'), findsWidgets);
      expect(find.text('Cardiology Department Open Hours'), findsOneWidget);
      expect(find.text('4 Openings'), findsOneWidget);
      expect(find.text('MORNING WINDOW (08:00 AM – 12:00 PM)'), findsOneWidget);
      expect(
        find.text('AFTERNOON WINDOW (01:00 PM – 04:30 PM)'),
        findsOneWidget,
      );

      // Verify Clinical Reason Card
      expect(find.text('Clinical Reason for Reschedule'), findsOneWidget);
      expect(find.text('Mandatory'), findsOneWidget);
      expect(find.text('Physician Emergency Duty'), findsWidgets);
      expect(find.text('Clinic Equipment Maintenance'), findsOneWidget);
      expect(find.text('Patient Mutual Request'), findsOneWidget);
      expect(find.text('Schedule Rebalance'), findsOneWidget);

      // Verify Transition Summary
      expect(find.text('SCHEDULE TRANSITION SUMMARY'), findsOneWidget);
      expect(find.text('Wed, Oct 18'), findsOneWidget);

      // Verify Action Deck
      expect(find.text('Confirm Reschedule'), findsOneWidget);
      expect(find.text('Cancel & Keep Current Slot'), findsOneWidget);
    },
  );

  testWidgets(
    'Selecting a new date and time slot updates the transition summary',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on open day 22
      final day22Finder = find.text('22');
      expect(day22Finder, findsOneWidget);
      await tester.tap(day22Finder);
      await tester.pumpAndSettle();

      // Verify date title updated to Thursday, Oct 22
      expect(find.text('Thursday, Oct 22'), findsWidgets);

      // Tap on time slot 08:30 AM
      final slotFinder = find.text('08:30 AM');
      expect(slotFinder, findsOneWidget);
      await tester.tap(slotFinder);
      await tester.pumpAndSettle();

      // Verify transition summary shows Thu, Oct 22 and 08:30 AM
      expect(find.text('Thu, Oct 22'), findsOneWidget);
      expect(find.text('08:30 AM'), findsWidgets);
    },
  );
}
