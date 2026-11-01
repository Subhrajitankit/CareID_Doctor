import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/profile_settings/support_app_info_screen.dart';

void main() {
  Widget createTestWidget({bool showLogoutSheetImmediately = false}) {
    return MaterialApp(
      routes: {
        AppRoutes.login: (context) =>
            const Scaffold(body: Text('Login Screen')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.settingsHub: (context) =>
            const Scaffold(body: Text('Settings Hub Screen')),
      },
      home: SupportAppInfoScreen(
        showLogoutSheetImmediately: showLogoutSheetImmediately,
      ),
    );
  }

  testWidgets(
    'SupportAppInfoScreen renders all core Figma components (Node 10:4141)',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Top App Bar
      expect(find.byKey(const Key('support_back_button')), findsOneWidget);

      // 2. Bento Support Cards
      expect(find.text('Help Center'), findsOneWidget);
      expect(
        find.text(
          'Browse guides, tutorials, and comprehensive clinical workflow documentation.',
        ),
        findsOneWidget,
      );

      expect(find.text('FAQs'), findsOneWidget);
      expect(
        find.text(
          'Quick answers to common questions regarding patient management and billing.',
        ),
        findsOneWidget,
      );

      expect(find.text('Contact IT Support'), findsOneWidget);
      expect(
        find.text('Available 24/7 for urgent clinical system issues.'),
        findsOneWidget,
      );

      // 3. About App Section
      expect(find.text('About App'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('3.4.1 (Build 892)'), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Open Source Licenses'), findsOneWidget);

      // 4. Account Actions / Danger Zone
      expect(find.text('Account Actions'), findsOneWidget);
      expect(
        find.text('Manage your current session and account status.'),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('account_actions_logout_button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('account_actions_delete_button')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Tapping Logout button opens Confirm Logout Bottom Sheet (Figma Node 10:4142)',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final logoutButton = find.byKey(
        const Key('account_actions_logout_button'),
      );
      await tester.ensureVisible(logoutButton);
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      // Verify Confirm Logout Bottom Sheet elements
      expect(find.text('Confirm Logout'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to log out? You will need to re-authenticate to access clinical data.',
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('modal_yes_logout_button')), findsOneWidget);
      expect(
        find.byKey(const Key('modal_cancel_logout_button')),
        findsOneWidget,
      );

      // Tap Cancel
      await tester.tap(find.byKey(const Key('modal_cancel_logout_button')));
      await tester.pumpAndSettle();

      // Modal dismissed
      expect(find.text('Confirm Logout'), findsNothing);
    },
  );

  testWidgets('Tapping Yes, Log Out in Bottom Sheet navigates to Login route', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final logoutButton = find.byKey(const Key('account_actions_logout_button'));
    await tester.ensureVisible(logoutButton);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // Tap Yes, Log Out
    await tester.tap(find.byKey(const Key('modal_yes_logout_button')));
    await tester.pumpAndSettle();

    // Should navigate to Login Screen
    expect(find.text('Login Screen'), findsOneWidget);
  });

  testWidgets(
    'Tapping Help Center opens Clinical Help Center modal with HIPAA info',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final helpCenter = find.text('Help Center');
      await tester.ensureVisible(helpCenter);
      await tester.tap(helpCenter);
      await tester.pumpAndSettle();

      expect(find.text('Clinical Help Center'), findsOneWidget);
      expect(find.text('HIPAA & HITECH Certified'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Clinical Help Center'), findsNothing);
    },
  );

  testWidgets(
    'Tapping Contact IT Support opens Clinical IT Helpdesk modal with hotline',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final contactCard = find.text('Contact IT Support');
      await tester.ensureVisible(contactCard);
      await tester.tap(contactCard);
      await tester.pumpAndSettle();

      expect(find.text('Clinical IT Helpdesk'), findsOneWidget);
      expect(find.text('+1 (800) 555-CARE (ext. 911)'), findsOneWidget);
      expect(find.text('support-md@stjude-health.org'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Clinical IT Helpdesk'), findsNothing);
    },
  );

  testWidgets('Tapping FAQs opens FAQs modal', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final faqsCard = find.text('FAQs');
    await tester.ensureVisible(faqsCard);
    await tester.tap(faqsCard);
    await tester.pumpAndSettle();

    expect(find.text('Frequently Asked Questions'), findsOneWidget);
    expect(find.text('How do I sync patient records?'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(find.text('Frequently Asked Questions'), findsNothing);
  });

  testWidgets('Tapping Delete Account shows confirmation dialog', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    final deleteButton = find.byKey(const Key('account_actions_delete_button'));
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'This action is irreversible. All cached hospital records, session keys, and local credentials will be wiped from this device.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Tapping Back button navigates back', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.settingsHub: (context) =>
              const Scaffold(body: Text('Settings Hub Screen')),
        },
        home: const SupportAppInfoScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('support_back_button')));
    await tester.pumpAndSettle();

    expect(find.text('Settings Hub Screen'), findsOneWidget);
  });
}
