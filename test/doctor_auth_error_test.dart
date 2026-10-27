import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/auth/doctor_auth_error_screen.dart';

void main() {
  testWidgets(
    'DoctorAuthErrorScreen renders Figma node 10:256 elements correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const DoctorAuthErrorScreen(),
          routes: {
            AppRoutes.login: (context) =>
                const Scaffold(body: Text('Login Screen')),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify Showcase Card
      expect(find.text('Auth Error States Showcase'), findsOneWidget);
      expect(
        find.text(
          'Material 3 Snackbar patterns for enterprise\nhealthcare. Designed to avoid floating red\ncards and maintain a calm, authoritative UI.',
        ),
        findsOneWidget,
      );

      // Verify Snackbar 1
      expect(find.text('Your secure\nsession has\nexpired.'), findsOneWidget);
      expect(find.text('RE-AUTHENTICATE'), findsOneWidget);

      // Verify Snackbar 2
      expect(
        find.text('Unable to connect to clinical\nservers. Check network.'),
        findsOneWidget,
      );
      expect(find.text('RETRY'), findsOneWidget);

      // Verify Snackbar 3
      expect(
        find.text('Doctor ID provided is not recognized by\nthe system.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    },
  );

  testWidgets('DoctorAuthErrorScreen RE-AUTHENTICATE navigates to login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const DoctorAuthErrorScreen(),
        routes: {
          AppRoutes.login: (context) =>
              const Scaffold(body: Text('Login Screen')),
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('RE-AUTHENTICATE'));
    await tester.tap(find.text('RE-AUTHENTICATE'));
    await tester.pumpAndSettle();

    expect(find.text('Login Screen'), findsOneWidget);
  });

  testWidgets('DoctorAuthErrorScreen renders custom errorMessage correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DoctorAuthErrorScreen(
          errorMessage: 'Custom Session Timeout Detected',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Custom Session Timeout Detected'), findsOneWidget);
  });
}
