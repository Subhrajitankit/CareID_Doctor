import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/appointments/appointment_cancelled_screen.dart';
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
    status: 'cancelled',
    notes: 'Lipid panel follow-up',
  );

  Widget createTestWidget({Appointment? appointment}) {
    return MaterialApp(
      routes: {
        AppRoutes.appointmentCancelled: (context) =>
            AppointmentCancelledScreen(appointmentArg: appointment),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.patientProfile: (context) =>
            const Scaffold(body: Text('Patient Profile Screen')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
        AppRoutes.notificationCenter: (context) =>
            const Scaffold(body: Text('Notification Center Screen')),
      },
      home: AppointmentCancelledScreen(appointmentArg: appointment),
    );
  }

  testWidgets(
    'AppointmentCancelledScreen renders exact Figma node 10:6995 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(appointment: testAppointment));
      await tester.pumpAndSettle();

      // Top Header & Sub-Header
      expect(find.text('ENCOUNTER CANCELLED'), findsOneWidget);
      expect(find.text('Slot Revoked'), findsOneWidget);

      // Status Feedback Card
      expect(find.text('CANCELLED BY CLINICIAN'), findsOneWidget);
      expect(find.text('Appointment Cancelled'), findsOneWidget);
      expect(find.textContaining('The clinical slot'), findsOneWidget);
      expect(find.textContaining('#APT-88204-NY'), findsOneWidget);
      expect(
        find.textContaining(
          'has been successfully released back into hospital availability',
        ),
        findsOneWidget,
      );

      // Patient Summary Card
      expect(find.text('RS'), findsOneWidget);
      expect(find.text('Robert J. Sterling'), findsOneWidget);
      expect(find.text('45y, Male • CID #8472-9901'), findsOneWidget);
      expect(find.text('CANCELLED'), findsOneWidget);

      // Metadata Rows
      expect(find.text('ORIGINAL SCHEDULED SLOT'), findsOneWidget);
      expect(find.text('Wednesday, Oct 18, 2026'), findsOneWidget);
      expect(find.text('10:30 AM – 11:15 AM EST (45 Mins)'), findsOneWidget);
      expect(find.text('LOCATION & DESK'), findsOneWidget);
      expect(find.text('Mount Sinai Heart Center'), findsOneWidget);
      expect(
        find.text('Suite 400, Check-in Kiosk 2, Room 412'),
        findsOneWidget,
      );
      expect(find.text('VISIT TYPE'), findsOneWidget);
      expect(
        find.text('In-Person Clinical Review (Cardiology)'),
        findsOneWidget,
      );

      // Inbound Referral Provenance Box
      expect(find.text('INBOUND REFERRAL PROVENANCE'), findsOneWidget);
      expect(find.text('Returned to Queue'), findsOneWidget);
      expect(
        find.text(
          'Referred Patient • Dr. Sarah Jenkins (Cardiology) #REF-4491',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'Original referral ticket reinstated with primary triage flag.',
        ),
        findsOneWidget,
      );

      // Reason for Cancellation Banner
      expect(find.text('REASON FOR CANCELLATION'), findsOneWidget);
      expect(find.text('Physician Emergency Duty'), findsOneWidget);
      expect(
        find.text('Cancelled Today, 08:42 AM EST • Physician Authorized'),
        findsOneWidget,
      );

      // Clinical Governance & Live Audit Log Card
      expect(find.text('Live Audit Log'), findsOneWidget);
      expect(find.text('3/3 Dispatches Active'), findsOneWidget);
      expect(find.text('Patient Dispatch Confirmed'), findsOneWidget);
      expect(
        find.textContaining(
          'Encrypted cancellation SMS & push notification dispatched with priority re-booking link',
        ),
        findsOneWidget,
      );
      expect(find.text('Hospital EHR Synchronized'), findsOneWidget);
      expect(
        find.textContaining(
          'Slot released back to Epic/Cerner outpatient availability pool',
        ),
        findsOneWidget,
      );
      expect(find.text('Referral Queue Updated'), findsOneWidget);
      expect(
        find.textContaining('Ticket #REF-4491 returned to Dr. Sarah Jenkins'),
        findsOneWidget,
      );

      // Action Buttons
      expect(find.text('Back to Appointments Overview'), findsOneWidget);
      expect(find.text('View Patient Profile'), findsOneWidget);
      expect(find.text('Return to Home Dashboard'), findsOneWidget);
    },
  );

  testWidgets(
    'AppointmentCancelledScreen navigates back to Appointments Overview',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(appointment: testAppointment));
      await tester.pumpAndSettle();

      final overviewBtn = find.text('Back to Appointments Overview');
      await tester.ensureVisible(overviewBtn);
      await tester.tap(overviewBtn);
      await tester.pumpAndSettle();

      expect(find.text('Appointments Overview Screen'), findsOneWidget);
    },
  );

  testWidgets('AppointmentCancelledScreen navigates to View Patient Profile', (
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

    final profileBtn = find.text('View Patient Profile');
    await tester.ensureVisible(profileBtn);
    await tester.tap(profileBtn);
    await tester.pumpAndSettle();

    expect(find.text('Patient Profile Screen'), findsOneWidget);
  });

  testWidgets(
    'AppointmentCancelledScreen navigates to Return to Home Dashboard',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(appointment: testAppointment));
      await tester.pumpAndSettle();

      final homeBtn = find.text('Return to Home Dashboard');
      await tester.ensureVisible(homeBtn);
      await tester.tap(homeBtn);
      await tester.pumpAndSettle();

      expect(find.text('Dashboard Screen'), findsOneWidget);
    },
  );
}
