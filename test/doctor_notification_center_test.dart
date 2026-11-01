import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/notifications_messages/doctor_notification_center_screen.dart';

void main() {
  testWidgets(
    'DoctorNotificationCenterScreen renders all Figma node 10:2846 components',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.notificationPreferences: (context) =>
                const Scaffold(body: Text('Notification Preferences')),
            AppRoutes.patientMessages: (context) =>
                const Scaffold(body: Text('Patient Messages')),
            AppRoutes.labSummary: (context) =>
                const Scaffold(body: Text('Lab Summary')),
            AppRoutes.appointmentsOverview: (context) =>
                const Scaffold(body: Text('Appointments Overview')),
            AppRoutes.dashboard: (context) =>
                const Scaffold(body: Text('Doctor Dashboard')),
            AppRoutes.doctorProfile: (context) =>
                const Scaffold(body: Text('Doctor Profile')),
          },
          home: const DoctorNotificationCenterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. TopAppBar verification
      expect(find.byKey(const Key('notification_center_back_button')), findsOneWidget);
      expect(find.byKey(const Key('notification_preferences_button')), findsOneWidget);
      expect(find.byType(Image), findsWidgets);

      // 2. Title Section
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Clinical Notifications'), findsOneWidget);
      expect(find.text('You have 3 unread messages.'), findsOneWidget);

      // 3. Filter Chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Unread'), findsOneWidget);
      expect(find.text('Clinical'), findsOneWidget);
      expect(find.text('Referrals'), findsOneWidget);
      expect(find.text('Prescriptions'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);

      // 4. Section Group Headers
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Yesterday'), findsNWidgets(2)); // Header + Timestamp
      expect(find.text('Earlier'), findsOneWidget);

      // 5. Card 1: Critical Emergency Alert
      expect(find.text('Critical lab value detected'), findsOneWidget);
      expect(find.text('Emergency'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Robert J. Sterling'),
        ),
        findsOneWidget,
      );
      expect(find.text('Start Consultation'), findsOneWidget);
      expect(find.text('Open Patient Record'), findsOneWidget);

      // 6. Card 2: Referral Update
      expect(find.text('New referral received'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Dr. Sarah Jenkins'),
        ),
        findsOneWidget,
      );
      expect(find.text('Action Required'), findsOneWidget);

      // 7. Card 3: Medical Record Update
      expect(find.text('Radiology report uploaded'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Jane Doe'),
        ),
        findsOneWidget,
      );
      expect(find.text('New'), findsOneWidget);

      // 8. Card 4: Consultation Completed (Read state)
      expect(find.text('Consultation completed'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Eleanor Pena'),
        ),
        findsOneWidget,
      );
      expect(find.text('Completed'), findsOneWidget);

      // 9. Bottom Navigation Bar items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'Filter chips filter notification items correctly',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorNotificationCenterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap 'Clinical' filter chip
      await tester.tap(find.text('Clinical'));
      await tester.pumpAndSettle();

      expect(find.text('Critical lab value detected'), findsOneWidget);
      expect(find.text('New referral received'), findsNothing);
      expect(find.text('Radiology report uploaded'), findsNothing);

      // Scroll filter chips to reveal 'Referrals' and tap it
      await tester.ensureVisible(find.text('Referrals'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Referrals'));
      await tester.pumpAndSettle();

      expect(find.text('New referral received'), findsOneWidget);
      expect(find.text('Critical lab value detected'), findsNothing);

      // Tap 'All' filter chip to restore all
      await tester.ensureVisible(find.text('All'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(find.text('Critical lab value detected'), findsOneWidget);
      expect(find.text('New referral received'), findsOneWidget);
    },
  );

  testWidgets(
    'Interactive buttons on critical alert navigate to correct destinations',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.patientMessages: (context) =>
                const Scaffold(body: Text('Patient Messages Destination')),
            AppRoutes.labSummary: (context) =>
                const Scaffold(body: Text('Lab Summary Destination')),
          },
          home: const DoctorNotificationCenterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll up slightly or tap Start Consultation which is fully visible
      final startConsultationBtn = find.text('Start Consultation');
      expect(startConsultationBtn, findsOneWidget);

      await tester.tap(startConsultationBtn);
      await tester.pumpAndSettle();

      expect(find.text('Patient Messages Destination'), findsOneWidget);
    },
  );
}
