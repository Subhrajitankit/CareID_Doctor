import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/auth/doctor_login_screen.dart';

void main() {
  testWidgets(
    'DoctorLoginScreen renders Figma node 10:101 elements correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const DoctorLoginScreen(),
          routes: {
            AppRoutes.otp: (context) =>
                const Scaffold(body: Text('OTP Screen')),
            AppRoutes.biometricSetup: (context) =>
                const Scaffold(body: Text('Biometrics Screen')),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify Title and Subtitle
      expect(find.text('Doctor Login'), findsOneWidget);
      expect(find.text('Secure access to clinical systems'), findsOneWidget);

      // Verify Form Label and Input
      expect(find.text('Doctor ID / Registered Mobile Number'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);

      // Verify Buttons
      expect(find.text('Send OTP'), findsOneWidget);
      expect(find.text('OR'), findsOneWidget);
      expect(find.text('Login with Biometrics'), findsOneWidget);

      // Verify Security Footer
      expect(find.text('Protected by AES-256'), findsOneWidget);
      expect(find.text('Encryption'), findsOneWidget);
    },
  );

  testWidgets('DoctorLoginScreen validates input and submits to OTP', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const DoctorLoginScreen(),
        routes: {
          AppRoutes.otp: (context) => const Scaffold(body: Text('OTP Screen')),
        },
      ),
    );
    await tester.pumpAndSettle();

    // Clear text field to test validation error
    await tester.enterText(find.byType(TextFormField), '');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();

    expect(
      find.text('Please enter your Doctor ID or Mobile Number'),
      findsOneWidget,
    );

    // Enter valid ID and submit
    await tester.enterText(find.byType(TextFormField), 'MED-NY-849204');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();

    // Verify navigated to OTP
    expect(find.text('OTP Screen'), findsOneWidget);
  });

  testWidgets('DoctorLoginScreen navigates to biometric setup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const DoctorLoginScreen(),
        routes: {
          AppRoutes.biometricSetup: (context) =>
              const Scaffold(body: Text('Biometrics Screen')),
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login with Biometrics'));
    await tester.pumpAndSettle();

    expect(find.text('Biometrics Screen'), findsOneWidget);
  });
}
