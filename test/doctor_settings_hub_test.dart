import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/profile_settings/doctor_settings_hub_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';

void main() {
  Widget createTestWidget({
    String? doctorName,
    String? subtitle,
    String? regNumber,
    String? hospitalName,
    String? specialty,
    String? yearsExperience,
    String? consultationFee,
    String? languages,
    String? bio,
    String? status,
    String? patientsToday,
    String? avgRating,
  }) {
    return MaterialApp(
      routes: {
        AppRoutes.settingsHub: (context) => const DoctorSettingsHubScreen(),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.securityPrivacy: (context) =>
            const Scaffold(body: Text('Security Privacy Screen')),
        AppRoutes.supportInfo: (context) =>
            const Scaffold(body: Text('Support Info Screen')),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission Screen')),
        AppRoutes.login: (context) =>
            const Scaffold(body: Text('Doctor Login Screen')),
      },
      home: DoctorSettingsHubScreen(
        doctorName: doctorName,
        subtitle: subtitle,
        regNumber: regNumber,
        hospitalName: hospitalName,
        specialty: specialty,
        yearsExperience: yearsExperience,
        consultationFee: consultationFee,
        languages: languages,
        bio: bio,
        status: status,
        patientsToday: patientsToday,
        avgRating: avgRating,
      ),
    );
  }

  group('DoctorSettingsHubScreen - Figma Node 10:3847 Visual Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:3847', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Mobile Header (Node 10:3877)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.text('Profile'), findsNWidgets(2)); // Header + BottomNav

      // 2. Section 3.1: Profile Header Card (Node 10:3884)
      expect(find.text('Dr. Sarah Jenkins,\nMD'), findsOneWidget);
      expect(find.text('Senior Cardiologist • HV360 Verified'), findsOneWidget);
      expect(find.text('Reg No: MED-8942-TX'), findsOneWidget);
      expect(find.text('City General Hospital'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.byIcon(Icons.verified_rounded), findsOneWidget);

      // 3. Section 3.2: Professional Information Card (Node 10:3911)
      expect(find.text('Professional Information'), findsOneWidget);
      expect(find.text('Specialty'), findsOneWidget);
      expect(find.text('Cardiology, Internal Medicine'), findsOneWidget);
      expect(find.text('Years of Experience'), findsOneWidget);
      expect(find.text('14 Years'), findsOneWidget);
      expect(find.text('Consultation Fee (Standard)'), findsOneWidget);
      expect(find.text(r'$150.00 USD'), findsOneWidget);
      expect(find.text('Languages Spoken'), findsOneWidget);
      expect(find.text('English, Spanish'), findsOneWidget);
      expect(find.text('Bio'), findsOneWidget);

      // 4. Section 3.3: Current Status Card (Node 10:3946)
      expect(find.text('Current Status'), findsOneWidget);
      expect(find.text('Accepting Consultations'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);
      expect(find.text('Patients Today'), findsOneWidget);
      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('Avg Rating'), findsOneWidget);

      // 5. Section 3.4: Availability Card (Node 10:3966)
      expect(find.text('Availability'), findsOneWidget);
      expect(find.text('Mon - Fri'), findsOneWidget);
      expect(find.text('09:00 - 17:00'), findsOneWidget);
      expect(find.text('Sat'), findsOneWidget);
      expect(find.text('10:00 - 14:00'), findsOneWidget);
      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Unavailable'), findsOneWidget);

      // 6. Section 3.5: Settings Module Cards (Node 10:3985)
      expect(find.text('Account Settings'), findsOneWidget);
      expect(
        find.text(
          'Manage your email, password, connected devices, and primary clinic details.',
        ),
        findsOneWidget,
      );
      expect(find.text('Security & Privacy'), findsOneWidget);
      expect(
        find.text(
          'Configure 2FA, review audit logs, and manage patient data sharing permissions.',
        ),
        findsOneWidget,
      );
      expect(find.text('Help & Support'), findsOneWidget);
      expect(
        find.text(
          'Access the clinical knowledge base, contact technical support, or report an issue.',
        ),
        findsOneWidget,
      );

      // 7. Section 3.6: Sign Out Action Button (Node 10:4020)
      expect(find.text('Sign Out'), findsOneWidget);

      // 8. Floating Bottom Navigation Shell (Node 10:3848)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('supports custom doctor data injection', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(
          doctorName: 'Dr. Jane Doe, MD',
          subtitle: 'Chief Neurologist',
          regNumber: 'Reg No: NEU-1122-NY',
          hospitalName: 'St. Jude Hospital',
          specialty: 'Neurology, Brain Health',
          yearsExperience: '20 Years',
          consultationFee: r'$200.00 USD',
          languages: 'English, French',
          status: 'In Surgery',
          patientsToday: '18',
          avgRating: '5.0',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dr. Jane Doe, MD'), findsOneWidget);
      expect(find.text('Chief Neurologist'), findsOneWidget);
      expect(find.text('Reg No: NEU-1122-NY'), findsOneWidget);
      expect(find.text('St. Jude Hospital'), findsOneWidget);
      expect(find.text('Neurology, Brain Health'), findsOneWidget);
      expect(find.text('20 Years'), findsOneWidget);
      expect(find.text(r'$200.00 USD'), findsOneWidget);
      expect(find.text('English, French'), findsOneWidget);
      expect(find.text('In Surgery'), findsOneWidget);
      expect(find.text('18'), findsOneWidget);
      expect(find.text('5.0'), findsOneWidget);
    });

    testWidgets('tapping Settings modules triggers appropriate routes', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Security & Privacy
      final secBtn = find.text('Security & Privacy');
      await tester.ensureVisible(secBtn);
      await tester.pumpAndSettle();
      await tester.tap(secBtn);
      await tester.pumpAndSettle();

      expect(find.text('Security Privacy Screen'), findsOneWidget);
    });

    testWidgets('tapping Sign Out opens confirmation dialog', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final signOutBtn = find.text('Sign Out');
      await tester.ensureVisible(signOutBtn);
      await tester.pumpAndSettle();
      await tester.tap(signOutBtn);
      await tester.pumpAndSettle();

      expect(
        find.text('Are you sure you want to sign out of CAREiD Doctor?'),
        findsOneWidget,
      );

      // Cancel dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(
        find.text('Are you sure you want to sign out of CAREiD Doctor?'),
        findsNothing,
      );
    });

    testWidgets('tapping Back button pops navigation', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 2600);
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
                    Navigator.pushNamed(context, AppRoutes.settingsHub);
                  },
                  child: const Text('Go to Settings Hub'),
                ),
              ),
            ),
            AppRoutes.settingsHub: (context) => const DoctorSettingsHubScreen(),
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Go to Settings Hub'));
      await tester.pumpAndSettle();

      expect(find.text('Dr. Sarah Jenkins,\nMD'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Go to Settings Hub'), findsOneWidget);
    });
  });
}
