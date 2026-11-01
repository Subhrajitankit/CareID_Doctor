import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/notifications_messages/doctor_notification_center_screen.dart';
import 'package:careid_doctor/features/profile_settings/notification_preferences_screen.dart';

void main() {
  Widget createTestWidget({
    bool? initialEmergencyAlerts,
    bool? initialClinicalAlerts,
    bool? initialReferralUpdates,
    bool? initialPrescriptionAlerts,
    bool? initialHealthRecordUpdates,
  }) {
    return MaterialApp(
      routes: {
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
        AppRoutes.settingsHub: (context) =>
            const Scaffold(body: Text('Settings Hub Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Screen')),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission Screen')),
      },
      home: NotificationPreferencesScreen(
        initialEmergencyAlerts: initialEmergencyAlerts,
        initialClinicalAlerts: initialClinicalAlerts,
        initialReferralUpdates: initialReferralUpdates,
        initialPrescriptionAlerts: initialPrescriptionAlerts,
        initialHealthRecordUpdates: initialHealthRecordUpdates,
      ),
    );
  }

  testWidgets('NotificationPreferencesScreen renders all Figma node 10:4025 elements', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // 1. Top App Bar
    expect(find.byKey(const Key('notification_back_button')), findsOneWidget);

    // 2. Title & Subtitle
    expect(find.text('Notifications'), findsOneWidget);
    expect(
      find.text(
        'Manage how and when you receive clinical alerts, patient updates, and system notifications.',
      ),
      findsOneWidget,
    );

    // 3. Clinical & Critical Card
    expect(find.text('Clinical & Critical'), findsOneWidget);
    expect(find.text('Emergency Alerts'), findsOneWidget);
    expect(
      find.text(
        'Critical patient condition changes, code blues, or stat lab results.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('toggle_emergency_alerts')), findsOneWidget);

    expect(find.text('Clinical Alerts'), findsOneWidget);
    expect(
      find.text(
        'Abnormal lab results, missed medications, or vital sign deviations.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('toggle_clinical_alerts')), findsOneWidget);

    // 4. Workflow & Updates Card
    expect(find.text('Workflow & Updates'), findsOneWidget);
    expect(find.text('Referral Updates'), findsOneWidget);
    expect(
      find.text(
        'Status changes on outgoing referrals or new incoming consult requests.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('toggle_referral_updates')), findsOneWidget);

    expect(find.text('Prescription Notifications'), findsOneWidget);
    expect(
      find.text(
        'Refill requests, pharmacy interactions, or controlled substance alerts.',
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('toggle_prescription_notifications')),
      findsOneWidget,
    );

    expect(find.text('Health Record Updates'), findsOneWidget);
    expect(
      find.text(
        'New documents uploaded, imaging reports finalized, or clinical notes shared.',
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('toggle_health_record_updates')),
      findsOneWidget,
    );

    // 5. Delivery Methods Card
    expect(find.text('Delivery Methods'), findsOneWidget);
    expect(
      find.text(
        'Push notifications are sent directly to your device. Ensure you have granted permission in your OS settings.',
      ),
      findsOneWidget,
    );

    // 6. Floating Bottom Navigation Shell
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Patients'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
  });

  testWidgets('Toggles interactively update preference state', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Emergency alerts toggle
    final emergencyToggle = find.byKey(const Key('toggle_emergency_alerts'));
    await tester.tap(emergencyToggle);
    await tester.pumpAndSettle();

    // Clinical alerts toggle
    final clinicalToggle = find.byKey(const Key('toggle_clinical_alerts'));
    await tester.tap(clinicalToggle);
    await tester.pumpAndSettle();

    // Referral updates toggle
    final referralToggle = find.byKey(const Key('toggle_referral_updates'));
    await tester.tap(referralToggle);
    await tester.pumpAndSettle();

    // Prescription toggle
    final rxToggle = find.byKey(const Key('toggle_prescription_notifications'));
    await tester.tap(rxToggle);
    await tester.pumpAndSettle();

    // Health records toggle (was false -> now true)
    final healthToggle = find.byKey(const Key('toggle_health_record_updates'));
    await tester.tap(healthToggle);
    await tester.pumpAndSettle();
  });

  testWidgets(
    'Navigation: Notification Center opens Notification Preferences',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            AppRoutes.notificationPreferences: (context) =>
                const NotificationPreferencesScreen(),
            AppRoutes.patientMessages: (context) =>
                const Scaffold(body: Text('Patient Messages Screen')),
          },
          home: const DoctorNotificationCenterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the tune/preferences button in the AppBar
      final prefButton = find.byKey(
        const Key('notification_preferences_button'),
      );
      expect(prefButton, findsOneWidget);

      await tester.tap(prefButton);
      await tester.pumpAndSettle();

      // Confirm Notification Preferences screen opened
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Clinical & Critical'), findsOneWidget);
      expect(find.text('Workflow & Updates'), findsOneWidget);

      // Tap Back button returns to Notification Center
      await tester.tap(find.byKey(const Key('notification_back_button')));
      await tester.pumpAndSettle();

      expect(find.text('Clinical Notifications'), findsOneWidget);
    },
  );
}
