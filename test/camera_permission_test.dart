import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/qr_scan/camera_permission_screen.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp(
      routes: {
        AppRoutes.cameraPermission: (context) => const CameraPermissionScreen(),
        AppRoutes.qrProcessing: (context) =>
            const Scaffold(body: Text('QR Processing Screen')),
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
      home: const CameraPermissionScreen(),
    );
  }

  testWidgets(
    'CameraPermissionScreen renders exact Figma node 10:529 components',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Heading & Subtitle
      expect(find.text('Camera Access\nRequired'), findsOneWidget);
      expect(
        find.text(
          'Allow camera access to scan secure Health Vault QR codes and instantly retrieve patient medical records.',
        ),
        findsOneWidget,
      );

      // Buttons
      expect(find.text('Allow Camera'), findsOneWidget);
      expect(find.text('Not Now'), findsOneWidget);

      // Privacy Badge
      expect(find.text('Secure, encrypted connection'), findsOneWidget);

      // Bottom Navigation items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );

  testWidgets(
    'CameraPermissionScreen navigates to QR processing on Allow Camera tap',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final allowBtn = find.text('Allow Camera');
      await tester.ensureVisible(allowBtn);
      await tester.tap(allowBtn);
      await tester.pumpAndSettle();

      expect(find.text('QR Processing Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'CameraPermissionScreen navigates to Notification Center on bell tap',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final bellBtn = find.byIcon(Icons.notifications_none_rounded);
      expect(bellBtn, findsOneWidget);
      await tester.tap(bellBtn);
      await tester.pumpAndSettle();

      expect(find.text('Notification Center Screen'), findsOneWidget);
    },
  );
}
