import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/profile_settings/security_privacy_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';

void main() {
  Widget createTestWidget({bool? initialBiometric, bool? initialTwoFactor}) {
    return MaterialApp(
      routes: {
        AppRoutes.securityPrivacy: (context) => const SecurityPrivacyScreen(),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission Screen')),
        AppRoutes.login: (context) =>
            const Scaffold(body: Text('Doctor Login Screen')),
      },
      home: SecurityPrivacyScreen(
        initialBiometric: initialBiometric,
        initialTwoFactor: initialTwoFactor,
      ),
    );
  }

  group('SecurityPrivacyScreen - Figma Node 10:4264 Visual Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:4264', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Top AppBar (Node 10:4265)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byType(Image), findsWidgets);

      // 2. Title Section (Node 10:4278)
      expect(find.text('Security & Privacy'), findsOneWidget);
      expect(
        find.text(
          'Manage your authentication methods, connected devices, and account security.',
        ),
        findsOneWidget,
      );

      // 3. Biometric Login Card (Node 10:4285)
      expect(find.text('Biometric Login'), findsOneWidget);
      expect(find.text('Use Face ID or Fingerprint'), findsOneWidget);

      // 4. Two-Factor Authentication Card (Node 10:4299)
      expect(find.text('Two-Factor Authentication'), findsOneWidget);
      expect(find.text('Enhance account security'), findsOneWidget);
      expect(
        find.text(
          'We highly recommend enabling 2FA for accessing sensitive patient records.',
        ),
        findsOneWidget,
      );

      // 5. Change PIN Card (Node 10:4318)
      expect(find.text('Change PIN'), findsOneWidget);
      expect(find.text('Update your quick access code'), findsOneWidget);

      // 6. Active Devices Card (Node 10:4332)
      expect(find.text('Active Devices'), findsOneWidget);
      expect(find.text('iPhone 14 Pro'), findsOneWidget);
      expect(find.text('San Francisco, CA • Active Now'), findsOneWidget);
      expect(find.text('CURRENT SESSION'), findsOneWidget);
      expect(find.text('MacBook Air M2'), findsOneWidget);
      expect(find.text('San Jose, CA • Last active: 2h ago'), findsOneWidget);
      expect(find.text('Revoke'), findsOneWidget);

      // 7. Recent Logins Card (Node 10:4363)
      expect(find.text('Recent Logins'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
      expect(find.text('Date/Time'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Method'), findsOneWidget);
      expect(find.text('Today, 08:30 AM'), findsOneWidget);
      expect(find.text('Yesterday, 06:15\nPM'), findsOneWidget);
      expect(find.text('Biometric'), findsOneWidget);
      expect(find.text('PIN'), findsOneWidget);

      // 8. Account Management Card (Node 10:4403)
      expect(find.text('Account Management'), findsOneWidget);
      expect(
        find.text(
          'Temporarily lock your account or request account deletion. These actions will affect your ability to access patient records.',
        ),
        findsOneWidget,
      );
      expect(find.text('Lock Account'), findsOneWidget);

      // 9. Floating Bottom Navigation Shell (Node 10:4411)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('toggles Biometric and Two-Factor settings interactively', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find toggle switches
      final toggles = find.byType(GestureDetector);
      expect(toggles, findsWidgets);

      // Tap Biometric Login text area
      await tester.tap(find.text('Biometric Login'));
      await tester.pumpAndSettle();

      // Tap Two-Factor Authentication text area
      await tester.tap(find.text('Two-Factor Authentication'));
      await tester.pumpAndSettle();
    });

    testWidgets('tapping Change PIN opens bottom sheet modal', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final pinFinder = find.text('Change PIN');
      await tester.ensureVisible(pinFinder);
      await tester.pumpAndSettle();
      await tester.tap(pinFinder);
      await tester.pumpAndSettle();

      // Modal bottom sheet should be visible
      expect(find.text('Change Security PIN'), findsOneWidget);
      expect(find.text('Save PIN'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Change Security PIN'), findsNothing);
    });

    testWidgets('tapping Revoke shows confirmation dialog and removes device', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final revokeFinder = find.text('Revoke');
      await tester.ensureVisible(revokeFinder);
      await tester.pumpAndSettle();
      await tester.tap(revokeFinder);
      await tester.pumpAndSettle();

      // Dialog should be visible
      expect(find.text('Revoke Session'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to revoke the session on MacBook Air M2? The user will be logged out immediately.',
        ),
        findsOneWidget,
      );

      // Confirm Revocation
      await tester.tap(find.widgetWithText(ElevatedButton, 'Revoke'));
      await tester.pumpAndSettle();

      // MacBook should now be removed from active devices
      expect(find.text('MacBook Air M2'), findsNothing);
    });

    testWidgets('tapping Lock Account shows confirmation dialog', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final lockFinder = find.text('Lock Account');
      await tester.ensureVisible(lockFinder);
      await tester.pumpAndSettle();
      await tester.tap(lockFinder);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Locking your account will log out all sessions and disable credential access until reactivated by your clinic administrator.',
        ),
        findsOneWidget,
      );

      // Cancel dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Locking your account will log out all sessions and disable credential access until reactivated by your clinic administrator.',
        ),
        findsNothing,
      );
    });

    testWidgets('tapping Back button pops navigation', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          initialRoute: AppRoutes.doctorProfile,
          routes: {
            AppRoutes.doctorProfile: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.securityPrivacy);
                  },
                  child: const Text('Go to Security'),
                ),
              ),
            ),
            AppRoutes.securityPrivacy: (context) =>
                const SecurityPrivacyScreen(),
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Go to Security'));
      await tester.pumpAndSettle();

      expect(find.text('Security & Privacy'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Go to Security'), findsOneWidget);
    });
  });
}
