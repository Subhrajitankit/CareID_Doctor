import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/appointments/cancellation_confirmation_screen.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  const testAppointment = Appointment(
    id: '88204-ny',
    patient: Patient(
      id: 'p-sterling',
      name: 'Robert J. Sterling',
      age: 45,
      gender: 'Male',
      bloodGroup: 'A+',
      careId: '#8472-9901',
      allergies: [],
      chronicConditions: [],
    ),
    time: '10:30 AM',
    date: 'Wednesday, Oct 18, 2026',
    type: 'In-Person Clinical Review (Cardiology)',
    status: 'scheduled',
    notes: 'Lipid panel follow-up',
  );

  Widget createTestWidget({Appointment? appointment}) {
    return MaterialApp(
      routes: {
        AppRoutes.cancellationConfirmation: (context) =>
            CancellationConfirmationScreen(appointmentArg: appointment),
        AppRoutes.appointmentCancelled: (context) =>
            const Scaffold(body: Text('Appointment Cancelled Screen')),
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
      home: CancellationConfirmationScreen(appointmentArg: appointment),
    );
  }

  testWidgets(
    'CancellationConfirmationScreen renders exact Figma node 10:6834 components',
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
      expect(find.text('CLINICAL SCHEDULE • STEP 2 OF 2'), findsOneWidget);
      expect(
        find.text('Confirm Cancellation'),
        findsNWidgets(2),
      ); // Header title + Primary button
      expect(find.text('FINAL REVIEW'), findsOneWidget);

      // Warning Card
      expect(find.text('Cancel Appointment?'), findsOneWidget);
      expect(
        find.textContaining(
          'Are you sure you want to cancel this appointment?',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Permanent Slot Release — Action will be recorded'),
        findsOneWidget,
      );

      // Detailed Appointment Summary Card
      expect(
        find.textContaining('Robert J. Sterling'),
        findsNWidgets(2),
      ); // Card + Governance notice
      expect(find.text('RS'), findsOneWidget);
      expect(find.textContaining('45y, Male • CID'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);
      expect(find.text('Date & Scheduled Time'), findsOneWidget);
      expect(
        find.textContaining('Wednesday, Oct 18, 2026 • 10:30 AM'),
        findsOneWidget,
      );
      expect(find.text('Location & Facility'), findsOneWidget);
      expect(
        find.textContaining('Mount Sinai Hospital • Heart Center'),
        findsOneWidget,
      );
      expect(find.text('Encounter Protocol'), findsOneWidget);
      expect(
        find.text('In-Person Clinical Review (Cardiology)'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Referred Patient • Dr. Sarah Jenkins'),
        findsOneWidget,
      );

      // Cancellation Reason Card
      expect(
        find.text('RECORDED CLINICAL / ADMINISTRATIVE REASON'),
        findsOneWidget,
      );
      expect(find.text('Physician Emergency Duty'), findsOneWidget);
      expect(find.text('Physician Remarks & Justification'), findsOneWidget);
      expect(
        find.textContaining(
          'Doctor called into emergency cardiac catheterization lab',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Auto-prompt patient to re-book via Care ID'),
        findsOneWidget,
      );
      expect(find.text('Active'), findsOneWidget);
      expect(
        find.text('Return referral ticket to cardiology queue'),
        findsOneWidget,
      );
      expect(find.text('Enabled'), findsOneWidget);

      // Governance Notice
      expect(
        find.textContaining('Care ID Clinical Governance Protocol:'),
        findsOneWidget,
      );

      // Decision Buttons
      expect(find.text('Keep Appointment'), findsOneWidget);
    },
  );

  testWidgets(
    'CancellationConfirmationScreen confirms cancellation and navigates to appointmentCancelled',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(appointment: testAppointment));
      await tester.pumpAndSettle();

      final confirmBtn = find.widgetWithText(InkWell, 'Confirm Cancellation');
      expect(confirmBtn, findsOneWidget);

      await tester.ensureVisible(confirmBtn);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(find.text('Appointment Cancelled Screen'), findsOneWidget);
    },
  );
}
