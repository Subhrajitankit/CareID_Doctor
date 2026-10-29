import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/qr_scan/qr_error_screen.dart';

void main() {
  Widget createTestWidget({
    String? errorTitle,
    String? errorMessage,
    VoidCallback? onRetry,
    VoidCallback? onManualSearch,
  }) {
    return MaterialApp(
      routes: {
        AppRoutes.qrError: (context) => QrErrorScreen(
          errorTitle: errorTitle,
          errorMessage: errorMessage,
          onRetry: onRetry,
          onManualSearch: onManualSearch,
        ),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission Screen')),
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
      home: QrErrorScreen(
        errorTitle: errorTitle,
        errorMessage: errorMessage,
        onRetry: onRetry,
        onManualSearch: onManualSearch,
      ),
    );
  }

  testWidgets('QrErrorScreen renders exact Figma node 10:802 components', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Top App Bar
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

    // Hero Illustration and Floating Badge
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);

    // Headings
    expect(find.text('QR Code Expired'), findsOneWidget);
    expect(
      find.text(
        'This code is no longer valid or not\nrecognized by the system.',
      ),
      findsOneWidget,
    );

    // Action buttons
    expect(find.text('Try Again'), findsOneWidget);
    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
    expect(find.text('Manual Patient Search'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    // Help hint
    expect(find.byIcon(Icons.help_outline_rounded), findsOneWidget);
    expect(
      find.text('Need help? Contact hospital administration'),
      findsOneWidget,
    );

    // Bottom Navigation
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Tapping Try Again navigates to Camera Permission screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Try Again'));
    await tester.pumpAndSettle();

    expect(find.text('Camera Permission Screen'), findsOneWidget);
  });

  testWidgets(
    'Tapping Manual Patient Search navigates to Patient Search screen',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Manual Patient Search'));
      await tester.pumpAndSettle();

      expect(find.text('Patient Search Screen'), findsOneWidget);
    },
  );

  testWidgets('Tapping notification bell navigates to Notification Center', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Notification Center Screen'), findsOneWidget);
  });
}
