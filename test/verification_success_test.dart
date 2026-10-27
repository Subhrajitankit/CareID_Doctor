import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/auth/verification_success_screen.dart';

void main() {
  testWidgets(
    'VerificationSuccessScreen renders Figma node 10:233 elements correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const VerificationSuccessScreen(),
          routes: {
            AppRoutes.dashboard: (context) =>
                const Scaffold(body: Text('Doctor Dashboard')),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify Title
      expect(find.text('Access Verified'), findsOneWidget);

      // Verify Subtitle
      expect(
        find.text(
          'Welcome, Dr. Vance. Your secure\nclinical workspace is ready.',
        ),
        findsOneWidget,
      );

      // Verify Action Button
      expect(find.text('Continue to Dashboard'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

      // Verify Security Badge
      expect(find.text('END-TO-END ENCRYPTED SESSION'), findsOneWidget);
      expect(find.byIcon(Icons.shield_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'VerificationSuccessScreen navigates to dashboard on button tap',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const VerificationSuccessScreen(),
          routes: {
            AppRoutes.dashboard: (context) =>
                const Scaffold(body: Text('Doctor Dashboard')),
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Continue to Dashboard'));
      await tester.tap(find.text('Continue to Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Doctor Dashboard'), findsOneWidget);
    },
  );

  testWidgets(
    'VerificationSuccessScreen supports custom title, subtitle, and nextRoute',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const VerificationSuccessScreen(
            customTitle: 'Custom Verified',
            customSubtitle: 'Custom Subtitle Here',
            nextRoute: '/custom-destination',
          ),
          routes: {
            '/custom-destination': (context) =>
                const Scaffold(body: Text('Custom Destination Screen')),
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom Verified'), findsOneWidget);
      expect(find.text('Custom Subtitle Here'), findsOneWidget);

      await tester.ensureVisible(find.text('Continue to Dashboard'));
      await tester.tap(find.text('Continue to Dashboard'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Destination Screen'), findsOneWidget);
    },
  );
}
