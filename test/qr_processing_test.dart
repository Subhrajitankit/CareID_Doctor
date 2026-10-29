import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/qr_scan/camera_permission_screen.dart';
import 'package:careid_doctor/features/qr_scan/qr_error_screen.dart';
import 'package:careid_doctor/features/qr_scan/qr_processing_screen.dart';

void main() {
  Widget createTestWidget({
    bool autoNavigate = false,
    bool? shouldFail,
    String? qrData,
    String? failureTitle,
    String? failureMessage,
    Future<dynamic> Function()? onProcess,
  }) {
    return MaterialApp(
      routes: {
        AppRoutes.cameraPermission: (context) => const CameraPermissionScreen(),
        AppRoutes.qrProcessing: (context) => QrProcessingScreen(
          autoNavigate: autoNavigate,
          shouldFail: shouldFail,
          qrData: qrData,
          failureTitle: failureTitle,
          failureMessage: failureMessage,
          onProcess: onProcess,
        ),
        AppRoutes.qrVerificationSuccess: (context) =>
            const Scaffold(body: Text('Verification Success Screen')),
        AppRoutes.qrError: (context) => const QrErrorScreen(),
        AppRoutes.patientSearch: (context) =>
            const Scaffold(body: Text('Patient Search Screen')),
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
      home: QrProcessingScreen(
        autoNavigate: autoNavigate,
        shouldFail: shouldFail,
        qrData: qrData,
        failureTitle: failureTitle,
        failureMessage: failureMessage,
        onProcess: onProcess,
      ),
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
    'Required sequence: QR Processing screen navigates to QR Error screen after processing finishes',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Default autoNavigate flow
      await tester.pumpWidget(createTestWidget(autoNavigate: true));

      // 1. First, QR Processing screen is displayed while running
      expect(find.text('Verifying Secure QR'), findsOneWidget);
      expect(find.text('QR Code Expired'), findsNothing);

      // 2. Fast-forward past the processing duration (1600ms)
      await tester.pump(const Duration(milliseconds: 1700));
      await tester.pumpAndSettle();

      // 3. Afterward, QR Error screen appears matching Figma 10:802
      expect(find.text('QR Code Expired'), findsOneWidget);
      expect(
        find.text(
          'This code is no longer valid or not\nrecognized by the system.',
        ),
        findsOneWidget,
      );
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('Manual Patient Search'), findsOneWidget);
      expect(find.text('Verification Success Screen'), findsNothing);
    },
  );

  testWidgets(
    'Preserve success flow: When successful verification is specified, navigates to qrVerificationSuccess',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(autoNavigate: true, shouldFail: false),
      );
      expect(find.text('Verifying Secure QR'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1700));
      await tester.pumpAndSettle();

      expect(find.text('Verification Success Screen'), findsOneWidget);
      expect(find.text('QR Code Expired'), findsNothing);
    },
  );

  testWidgets(
    'Invalid or expired token triggers QR Error screen after processing completes',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(autoNavigate: true, qrData: 'EXPIRED_CODE_400'),
      );

      expect(find.text('Verifying Secure QR'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1700));
      await tester.pumpAndSettle();

      expect(find.text('QR Code Expired'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    },
  );

  testWidgets(
    'Processing exception automatically navigates to QR Error screen with details',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(
          autoNavigate: true,
          onProcess: () async {
            throw Exception('Cryptographic verification gateway timeout');
          },
        ),
      );

      expect(find.text('Verifying Secure QR'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 1700));
      await tester.pumpAndSettle();

      expect(find.text('QR Code Expired'), findsOneWidget);
      expect(
        find.text('Cryptographic verification gateway timeout'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Retry and Back flow: Tapping Try Again navigates to CameraPermission and resumes',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget(autoNavigate: true));

      await tester.pump(const Duration(milliseconds: 1700));
      await tester.pumpAndSettle();

      // On error screen
      expect(find.text('Try Again'), findsOneWidget);

      // Tap Try Again -> navigates to Camera Permission
      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();

      expect(find.text('Camera Access\nRequired'), findsOneWidget);

      // Tap Allow Camera -> navigates back to QR Processing
      await tester.tap(find.text('Allow Camera'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Verifying Secure QR'), findsOneWidget);

      // Flush remaining duration to settle
      await tester.pump(const Duration(milliseconds: 1700));
      await tester.pumpAndSettle();
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
