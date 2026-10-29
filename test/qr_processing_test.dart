import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/qr_scan/qr_processing_screen.dart';

void main() {
  Widget createTestWidget({bool autoNavigate = false}) {
    return MaterialApp(
      routes: {
        AppRoutes.qrProcessing: (context) =>
            QrProcessingScreen(autoNavigate: autoNavigate),
        AppRoutes.qrVerificationSuccess: (context) =>
            const Scaffold(body: Text('Verification Success Screen')),
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
      home: QrProcessingScreen(autoNavigate: autoNavigate),
    );
  }

  testWidgets('QrProcessingScreen renders exact Figma node 10:633 components', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget(autoNavigate: false));
    await tester.pump();

    // Central Title
    expect(find.text('Verifying Secure QR'), findsOneWidget);

    // Checklist Steps Card items
    expect(find.text('Reading QR'), findsOneWidget);
    expect(find.text('Verifying Identity'), findsOneWidget);
    expect(find.text('Checking Access\nPermission'), findsOneWidget);
    expect(find.text('IN\nPROGRESS'), findsOneWidget);
    expect(find.text('Loading Patient Summary'), findsOneWidget);

    // Encryption Note
    expect(
      find.text(
        'This verification uses end-to-end encryption to\nensure patient data remains confidential.',
      ),
      findsOneWidget,
    );

    // QR center icon
    expect(find.byIcon(Icons.qr_code_2_rounded), findsOneWidget);

    // Bottom Navigation
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets(
    'QrProcessingScreen auto-navigates to qrVerificationSuccess after duration',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(autoNavigate: true));
      expect(find.text('Verifying Secure QR'), findsOneWidget);

      // Fast-forward past the 1600ms processing delay
      await tester.pump(const Duration(milliseconds: 1700));
      await tester.pumpAndSettle();

      expect(find.text('Verification Success Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'QrProcessingScreen navigates to Notification Center on bell tap',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(autoNavigate: false));
      await tester.pump();

      final bellBtn = find.byIcon(Icons.notifications_none_rounded);
      expect(bellBtn, findsOneWidget);
      await tester.tap(bellBtn);
      await tester.pumpAndSettle();

      expect(find.text('Notification Center Screen'), findsOneWidget);
    },
  );
}
