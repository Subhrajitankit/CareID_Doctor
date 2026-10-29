import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/qr_scan/qr_verification_success_screen.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  const testPatient = Patient(
    id: 'p-eleanor',
    name: 'Eleanor Vance',
    age: 42,
    gender: 'Female',
    bloodGroup: 'B Positive',
    careId: '8821-990-212',
    allergies: [],
    chronicConditions: [],
  );

  Widget createTestWidget({Patient? patient}) {
    return MaterialApp(
      routes: {
        AppRoutes.qrVerificationSuccess: (context) =>
            QrVerificationSuccessScreen(patientArg: patient),
        AppRoutes.patientProfile: (context) =>
            const Scaffold(body: Text('Patient Profile Screen')),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission Screen')),
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
      home: QrVerificationSuccessScreen(patientArg: patient),
    );
  }

  testWidgets(
    'QrVerificationSuccessScreen renders exact Figma node 10:708 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(patient: testPatient));
      await tester.pumpAndSettle();

      // Top Header & Title
      expect(find.text('Patient Verified'), findsOneWidget);
      expect(
        find.text(
          'Secure identity check complete. Encrypted\nhealth records are now accessible for your\nclinical review.',
        ),
        findsOneWidget,
      );

      // Verified shield icon
      expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);

      // Patient card details
      expect(find.text('Eleanor Vance'), findsOneWidget);
      expect(find.text('HV-ID: 8821-990-212'), findsOneWidget);
      expect(find.text('Blood Group'), findsOneWidget);
      expect(find.text('B Positive'), findsOneWidget);
      expect(find.text('Patient Age'), findsOneWidget);
      expect(find.text('42 Years'), findsOneWidget);

      // Access banner
      expect(find.text('Verified Doctor Access'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);

      // Buttons
      expect(find.text('Open Patient Profile'), findsOneWidget);
      expect(find.text('Scan Another QR'), findsOneWidget);

      // Bottom Navigation
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );

  testWidgets(
    'QrVerificationSuccessScreen navigates to patientProfile on Open Patient Profile',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(patient: testPatient));
      await tester.pumpAndSettle();

      final openProfileBtn = find.text('Open Patient Profile');
      await tester.ensureVisible(openProfileBtn);
      await tester.tap(openProfileBtn);
      await tester.pumpAndSettle();

      expect(find.text('Patient Profile Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'QrVerificationSuccessScreen navigates to cameraPermission on Scan Another QR',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(patient: testPatient));
      await tester.pumpAndSettle();

      final scanAnotherBtn = find.text('Scan Another QR');
      await tester.ensureVisible(scanAnotherBtn);
      await tester.tap(scanAnotherBtn);
      await tester.pumpAndSettle();

      expect(find.text('Camera Permission Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'QrVerificationSuccessScreen navigates to Notification Center on bell tap',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(patient: testPatient));
      await tester.pumpAndSettle();

      final bellBtn = find.byIcon(Icons.notifications_none_rounded);
      expect(bellBtn, findsOneWidget);
      await tester.tap(bellBtn);
      await tester.pumpAndSettle();

      expect(find.text('Notification Center Screen'), findsOneWidget);
    },
  );
}
