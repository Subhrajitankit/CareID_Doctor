import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/auth/biometric_setup_screen.dart';

void main() {
  testWidgets(
    'BiometricSetupScreen renders Figma node 10:203 elements correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const BiometricSetupScreen(),
          routes: {
            AppRoutes.authSuccess: (context) =>
                const Scaffold(body: Text('Auth Success Screen')),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify Title
      expect(find.text('Secure Your Clinical\nVault'), findsOneWidget);

      // Verify Subtitle
      expect(
        find.text(
          'Enable biometrics for instant, secure\naccess to patient records.',
        ),
        findsOneWidget,
      );

      // Verify Buttons
      expect(find.text('Enable Biometrics'), findsOneWidget);
      expect(find.text('Maybe Later'), findsOneWidget);

      // Verify Trust Indicator Footer
      expect(find.text('Enterprise Grade Encryption'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'BiometricSetupScreen enables biometrics and navigates to success',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const BiometricSetupScreen(),
          routes: {
            AppRoutes.authSuccess: (context) =>
                const Scaffold(body: Text('Auth Success Screen')),
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Enable Biometrics'));
      await tester.tap(find.text('Enable Biometrics'));
      await tester.pumpAndSettle();

      expect(find.text('Auth Success Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'BiometricSetupScreen skips with Maybe Later and navigates to success',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const BiometricSetupScreen(),
          routes: {
            AppRoutes.authSuccess: (context) =>
                const Scaffold(body: Text('Auth Success Screen')),
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Maybe Later'));
      await tester.tap(find.text('Maybe Later'));
      await tester.pumpAndSettle();

      expect(find.text('Auth Success Screen'), findsOneWidget);
    },
  );
}
