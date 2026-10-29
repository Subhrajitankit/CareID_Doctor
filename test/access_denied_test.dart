import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/qr_scan/access_denied_screen.dart';

void main() {
  Widget createTestWidget({
    VoidCallback? onRequestAccess,
    VoidCallback? onBack,
  }) {
    return MaterialApp(
      routes: {
        AppRoutes.accessDenied: (context) => AccessDeniedScreen(
          onRequestAccess: onRequestAccess,
          onBack: onBack,
        ),
        AppRoutes.notificationCenter: (context) =>
            const Scaffold(body: Text('Notification Center Screen')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
      },
      home: AccessDeniedScreen(
        onRequestAccess: onRequestAccess,
        onBack: onBack,
      ),
    );
  }

  testWidgets('AccessDeniedScreen renders exact Figma node 10:1026 components', (
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

    // Main Card Elements
    expect(find.byIcon(Icons.lock_person_rounded), findsOneWidget);
    expect(find.text('Access\nRestricted'), findsOneWidget);
    expect(
      find.text(
        'You do not currently have permission to view this patient\'s records. Medical data privacy protocols require explicit authorization for non-attending physicians.',
      ),
      findsOneWidget,
    );

    // Buttons
    expect(find.text('Request Access'), findsOneWidget);
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);

    // Security Protocol Card
    expect(find.text('Security Protocol'), findsOneWidget);
    expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
    expect(
      find.text(
        'HIPAA compliance requires just-in-time access control for all PII/PHI data.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Access requests are logged and audited by the hospital compliance committee.',
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.history_rounded), findsOneWidget);

    // Visual Accent Card
    expect(find.text('CONFIDENTIAL INFORMATION'), findsOneWidget);

    // Bottom Navigation items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Tapping Request Access triggers compliance action', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool requested = false;
    await tester.pumpWidget(
      createTestWidget(onRequestAccess: () => requested = true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Request Access'));
    await tester.pumpAndSettle();

    expect(requested, isTrue);
  });

  testWidgets(
    'Tapping Request Access shows SnackBar when no custom callback provided',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request Access'));
      await tester.pump();

      expect(
        find.text('Access request submitted for clinical compliance review.'),
        findsOneWidget,
      );

      // Flush SnackBar and debounce timer
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    },
  );

  testWidgets('Tapping Back button triggers onBack callback', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    await tester.pumpWidget(createTestWidget(onBack: () => backPressed = true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });

  testWidgets('Tapping Top App Bar Back icon triggers back navigation', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    await tester.pumpWidget(createTestWidget(onBack: () => backPressed = true));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });

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
