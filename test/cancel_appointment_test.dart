import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/appointments/cancel_appointment_screen.dart';
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
        AppRoutes.cancelAppointment: (context) =>
            CancelAppointmentScreen(appointmentArg: appointment),
        AppRoutes.cancellationConfirmation: (context) =>
            const Scaffold(body: Text('Cancellation Confirmation Screen')),
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
      home: CancelAppointmentScreen(appointmentArg: appointment),
    );
  }

  testWidgets(
    'CancelAppointmentScreen renders exact Figma node 10:6655 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(appointment: testAppointment));
      await tester.pumpAndSettle();

      // Top Header Context Bar
      expect(find.text('CLINICAL SCHEDULE'), findsOneWidget);
      expect(find.text('Cancel Appointment'), findsOneWidget);

      // Patient Context Card
      expect(find.text('Robert J. Sterling'), findsOneWidget);
      expect(find.text('RS'), findsOneWidget);
      expect(find.textContaining('45y, Male • CID'), findsOneWidget);
      expect(find.text('IMMINENT'), findsOneWidget);
      expect(find.text('(In 2h)'), findsOneWidget);
      expect(
        find.textContaining('Wednesday, Oct 18, 2026 • 10:30 AM (45 Mins)'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Mount Sinai Hospital • Heart Center (Suite 400)'),
        findsOneWidget,
      );
      expect(
        find.text('In-Person Clinical Review (Cardiology)'),
        findsOneWidget,
      );

      // Warning Box
      expect(find.text('Critical Schedule Release Notice'), findsOneWidget);
      expect(
        find.textContaining('Releasing this slot will cancel the patient'),
        findsOneWidget,
      );

      // Mandatory Reason Section
      expect(
        find.text('Select Clinical / Administrative Reason'),
        findsOneWidget,
      );
      expect(find.text('Mandatory'), findsOneWidget);
      expect(find.text('Physician Availability / Emergency'), findsOneWidget);
      expect(find.text('Emergency Clinical Duty'), findsOneWidget);
      expect(find.text('Patient Mutual Request'), findsOneWidget);
      expect(find.text('Clinical Schedule Conflict'), findsOneWidget);
      expect(find.text('Facility / Equipment Unavailable'), findsOneWidget);
      expect(find.text('Other Administrative Reason'), findsOneWidget);

      // Care Continuity Card
      expect(find.text('Care Continuity Protocol'), findsOneWidget);
      expect(find.text('Auto-prompt patient to re-book'), findsOneWidget);
      expect(find.text('Return referral to Dr. Sarah Jenkins'), findsOneWidget);

      // Decision Buttons
      expect(find.text('Continue to Cancel'), findsOneWidget);
      expect(find.text('Keep Appointment'), findsOneWidget);
    },
  );

  testWidgets('CancelAppointmentScreen reason selection toggles correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(appointment: testAppointment));
    await tester.pumpAndSettle();

    final otherReason = find.text('Emergency Clinical Duty');
    await tester.ensureVisible(otherReason);
    await tester.tap(otherReason);
    await tester.pumpAndSettle();

    // Checkmark icon appears next to newly selected reason
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
  });

  testWidgets('CancelAppointmentScreen navigates to cancellationConfirmation', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(appointment: testAppointment));
    await tester.pumpAndSettle();

    final cancelBtn = find.text('Continue to Cancel');
    await tester.ensureVisible(cancelBtn);
    await tester.tap(cancelBtn);
    await tester.pumpAndSettle();

    expect(find.text('Cancellation Confirmation Screen'), findsOneWidget);
  });
}
