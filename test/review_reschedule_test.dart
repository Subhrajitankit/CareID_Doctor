import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/appointments/review_reschedule_screen.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  const testAppointment = Appointment(
    id: '88204-ny',
    patient: Patient(
      id: 'p-sterling',
      name: 'Robert J. Sterling',
      age: 45,
      gender: 'Male',
      bloodGroup: 'O Pos (+)',
      careId: '#8472-9901',
      allergies: [],
      chronicConditions: [],
    ),
    time: '10:30 AM',
    date: 'Saturday, Oct 21, 2026',
    type: 'In-Person Review',
    status: 'scheduled',
    notes: 'Lipid panel follow-up',
  );

  Widget createTestWidget({Appointment? appointment}) {
    return MaterialApp(
      routes: {
        AppRoutes.reviewReschedule: (context) =>
            ReviewRescheduleScreen(appointmentArg: appointment),
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
      home: ReviewRescheduleScreen(appointmentArg: appointment),
    );
  }

  testWidgets(
    'ReviewRescheduleScreen renders exact Figma node 10:6438 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(appointment: testAppointment));
      await tester.pumpAndSettle();

      // Top Header & Stepper
      expect(find.text('Review Reschedule'), findsOneWidget);
      expect(find.text('Step 2 of 2: Confirmation'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);

      // Patient Context Card
      expect(find.text('Robert J. Sterling'), findsOneWidget);
      expect(find.text('Male, 45y'), findsOneWidget);
      expect(find.text('Care ID: #8472-9901'), findsOneWidget);
      expect(find.text('O Pos (+)'), findsOneWidget);
      expect(find.text('BlueCross | Pre-authorized'), findsOneWidget);
      expect(find.text('Chief Complaint'), findsOneWidget);
      expect(
        find.textContaining('Persistent lower back pain radiating to left leg'),
        findsOneWidget,
      );

      // Comparison Matrix
      expect(find.text('Schedule Adjustment'), findsOneWidget);
      expect(find.text('CURRENT SLOT'), findsOneWidget);
      expect(find.text('To be Released'), findsOneWidget);
      expect(find.text('Wednesday, Oct 18, 2026'), findsOneWidget);
      expect(find.text('NEW PROPOSED SLOT'), findsOneWidget);
      expect(find.text('Selected Slot'), findsOneWidget);
      expect(find.text('Saturday, Oct 21, 2026'), findsOneWidget);
      expect(find.text('ECG Ready'), findsOneWidget);
      expect(find.text('Accessible'), findsOneWidget);

      // Clinical Justification Card
      expect(find.text('Clinical Justification'), findsOneWidget);
      expect(find.text('Physician Emergency Duty'), findsOneWidget);
      expect(find.text('Physician Clinical Remarks:'), findsOneWidget);

      // Automated Dispatch Protocol
      expect(find.text('Automated Dispatch Protocol'), findsOneWidget);
      expect(
        find.textContaining(
          'Confirming will immediately update the hospital scheduling registry',
        ),
        findsOneWidget,
      );

      // Action Buttons
      expect(find.text('Confirm Reschedule'), findsOneWidget);
      expect(find.text('Back to Slot Selection'), findsOneWidget);
    },
  );

  testWidgets(
    'ReviewRescheduleScreen navigation triggers on Confirm Reschedule',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(appointment: testAppointment));
      await tester.pumpAndSettle();

      final confirmBtn = find.text('Confirm Reschedule');
      expect(confirmBtn, findsOneWidget);

      await tester.ensureVisible(confirmBtn);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.text('Reschedule Success Screen'), findsOneWidget);
    },
  );
}
