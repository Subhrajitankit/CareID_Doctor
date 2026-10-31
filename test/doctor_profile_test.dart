import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/profile_settings/doctor_profile_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';

void main() {
  Widget createTestWidget({
    String? doctorName,
    String? specialty,
    String? licenseNumber,
    String? hospitalName,
  }) {
    return MaterialApp(
      routes: {
        AppRoutes.doctorProfile: (context) => const DoctorProfileScreen(),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.settingsHub: (context) =>
            const Scaffold(body: Text('Settings Hub Screen')),
        AppRoutes.securityPrivacy: (context) =>
            const Scaffold(body: Text('Security Privacy Screen')),
        AppRoutes.supportInfo: (context) =>
            const Scaffold(body: Text('Support Info Screen')),
        AppRoutes.professionalCredentials: (context) =>
            const Scaffold(body: Text('Professional Credentials Screen')),
        AppRoutes.medicalRecords: (context) =>
            const Scaffold(body: Text('Medical Records Screen')),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission Screen')),
      },
      home: DoctorProfileScreen(
        doctorName: doctorName,
        specialty: specialty,
        licenseNumber: licenseNumber,
        hospitalName: hospitalName,
      ),
    );
  }

  group('DoctorProfileScreen - Figma Node 10:2982 Visual Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:2982', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Top AppBar (Node 10:2983)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // 2. Card 1: Profile Card (Node 10:2995)
      expect(find.text('AVAILABLE'), findsOneWidget);
      expect(find.text('Dr. Richard  Malouf'), findsOneWidget);
      expect(find.text('Senior Cardiologist'), findsOneWidget);
      expect(find.text('Reg: MED-884920-XC'), findsOneWidget);
      expect(find.byIcon(Icons.verified), findsOneWidget);

      // Quick stats (Node 10:3017)
      expect(find.text('12'), findsOneWidget);
      expect(find.text("Today's\nPatients"), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);

      // 3. Card 2: Settings Navigation Menu (Node 10:3037)
      expect(find.text('Professional Info'), findsOneWidget);
      expect(find.text('Credentials & affiliations'), findsOneWidget);
      expect(find.text('Account Settings'), findsOneWidget);
      expect(find.text('Preferences & notifications'), findsOneWidget);
      expect(find.text('Security & Privacy'), findsOneWidget);
      expect(find.text('Logins & active sessions'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('FAQs & contact'), findsOneWidget);
      expect(find.text('Referrals'), findsOneWidget);
      expect(find.text('Refer a Doctor'), findsOneWidget);

      // 4. Version string (Node 10:3095)
      expect(
        find.text('Health Vault 360 Doctor App v3.4.1 (Build 892)'),
        findsOneWidget,
      );

      // 5. Card 3: Detail Views — Professional Information (Node 10:3098)
      expect(find.text('Professional Information'), findsOneWidget);
      expect(find.text('Medical License'), findsOneWidget);
      expect(find.text('State Medical Board'), findsOneWidget);
      expect(find.text('License Expiring Soon'), findsOneWidget);
      expect(find.text('Renewal required by Oct 31, 2024'), findsOneWidget);
      expect(find.text('Renew Now'), findsOneWidget);
      expect(find.text('More information'), findsOneWidget);
      expect(find.text('Hospital Affiliations'), findsOneWidget);
      expect(find.text('Metropolitan General Hospital'), findsOneWidget);
      expect(find.text('Department of Cardiology • Primary'), findsOneWidget);
      expect(find.text('Consultation Hours'), findsOneWidget);
      expect(find.text('Edit Schedule'), findsOneWidget);
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Weekend'), findsOneWidget);
      expect(find.text('Off Duty'), findsOneWidget);

      // 6. Action CTA Buttons (Node 10:3188)
      expect(find.text('Book an Appointment'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('View Shared Records (5)'), findsOneWidget);
      expect(find.text('Directory'), findsOneWidget);

      // 7. Floating Bottom Navigation Shell (Node 10:3209)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('Tapping Settings Nav items triggers appropriate routes', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Account Settings
      await tester.tap(find.text('Account Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings Hub Screen'), findsOneWidget);
    });

    testWidgets('Tapping Action CTA buttons triggers navigation', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to Action CTA buttons
      final ctaFinder = find.text('Book an Appointment');
      await tester.ensureVisible(ctaFinder);
      await tester.pumpAndSettle();

      await tester.tap(ctaFinder);
      await tester.pumpAndSettle();
      expect(find.text('Appointments Overview Screen'), findsOneWidget);
    });
  });
}
