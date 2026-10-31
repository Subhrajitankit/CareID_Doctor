import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/profile_settings/professional_credentials_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';

void main() {
  Widget createTestWidget({
    String? deaLicense,
    String? educationCredits,
    String? certifications,
    String? npdbStatus,
    String? npiNumber,
    String? einNumber,
    String? lastSyncTime,
  }) {
    return MaterialApp(
      routes: {
        AppRoutes.professionalCredentials: (context) =>
            const ProfessionalCredentialsScreen(),
        AppRoutes.doctorProfile: (context) =>
            const Scaffold(body: Text('Doctor Profile Screen')),
        AppRoutes.dashboard: (context) =>
            const Scaffold(body: Text('Dashboard Screen')),
        AppRoutes.patientDirectory: (context) =>
            const Scaffold(body: Text('Patient Directory Screen')),
        AppRoutes.appointmentsOverview: (context) =>
            const Scaffold(body: Text('Appointments Overview Screen')),
        AppRoutes.medicalRecords: (context) =>
            const Scaffold(body: Text('Medical Records Screen')),
        AppRoutes.cameraPermission: (context) =>
            const Scaffold(body: Text('Camera Permission Screen')),
      },
      home: ProfessionalCredentialsScreen(
        deaLicense: deaLicense,
        educationCredits: educationCredits,
        certifications: certifications,
        npdbStatus: npdbStatus,
        npiNumber: npiNumber,
        einNumber: einNumber,
        lastSyncTime: lastSyncTime,
      ),
    );
  }

  group(
    'ProfessionalCredentialsScreen - Figma Node 10:8170 Visual Verification',
    () {
      testWidgets('renders all core UI elements matching Figma node 10:8170', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(427, 1800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // 1. Top AppBar (Node 10:8213)
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        expect(find.byType(Image), findsWidgets);

        // 2. Header Section: Title & Subtitle (Node 10:8224)
        expect(find.text('Professional Credentials'), findsOneWidget);
        expect(
          find.text('Review your active medical licenses and IDs'),
          findsOneWidget,
        );

        // 3. 2x3 Bento Grid Credential Cards (Node 10:8233)
        // DEA License Card
        expect(find.text('DEA License'), findsOneWidget);
        expect(find.text('Active: AM774219'), findsOneWidget);

        // Education Credit Card
        expect(find.text('Education Credit'), findsOneWidget);
        expect(find.text('12 Credits YTD'), findsOneWidget);

        // Certifications Card
        expect(find.text('Certifications'), findsOneWidget);
        expect(find.text('ABIM Certified'), findsOneWidget);

        // NPDB: Letters Card
        expect(find.text('NPDB: Letters'), findsOneWidget);
        expect(find.text('No Flags Found'), findsOneWidget);

        // Personal NPI Card
        expect(find.text('Personal NPI'), findsOneWidget);
        expect(find.text('1982736450'), findsOneWidget);

        // EIN Number Card
        expect(find.text('EIN Number'), findsOneWidget);
        expect(find.text('XX-XXX8842'), findsOneWidget);

        // 4. Identity Verification Card (Node 10:8288)
        expect(find.text('Identity Verification'), findsOneWidget);
        expect(find.text('Face Recognition'), findsOneWidget);
        expect(find.text('ID Card Scan'), findsOneWidget);
        expect(find.text('VERIFIED'), findsNWidgets(2));

        // 5. Footer Verification Status & Sync (Node 10:8309)
        expect(
          find.text('Verification Status: Full Access Approved'),
          findsOneWidget,
        );
        expect(
          find.text('Last sync: Oct 24, 2024 at 10:45 AM'),
          findsOneWidget,
        );

        // 6. Action Button (Node 10:8200)
        expect(find.text('Update Credentials'), findsOneWidget);

        // 7. Floating Bottom Navigation Shell (Node 10:8173)
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Patients'), findsOneWidget);
        expect(find.text('Schedule'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('supports custom credential data injection', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(427, 1800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          createTestWidget(
            deaLicense: 'Active: DL998877',
            educationCredits: '24 Credits YTD',
            certifications: 'Board Certified FACC',
            npdbStatus: 'Verified Clean',
            npiNumber: '1234567890',
            einNumber: '12-3456789',
            lastSyncTime: 'Last sync: Oct 31, 2026 at 12:00 PM',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Active: DL998877'), findsOneWidget);
        expect(find.text('24 Credits YTD'), findsOneWidget);
        expect(find.text('Board Certified FACC'), findsOneWidget);
        expect(find.text('Verified Clean'), findsOneWidget);
        expect(find.text('1234567890'), findsOneWidget);
        expect(find.text('12-3456789'), findsOneWidget);
        expect(
          find.text('Last sync: Oct 31, 2026 at 12:00 PM'),
          findsOneWidget,
        );
      });

      testWidgets('tapping Update Credentials opens bottom sheet modal', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(427, 1800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final updateBtn = find.text('Update Credentials');
        expect(updateBtn, findsOneWidget);

        await tester.ensureVisible(updateBtn);
        await tester.pumpAndSettle();
        await tester.tap(updateBtn);
        await tester.pumpAndSettle();

        // Modal bottom sheet should be visible
        expect(find.text('Update Clinical Credentials'), findsOneWidget);
        expect(find.text('Upload Document'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);

        // Close modal
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Update Clinical Credentials'), findsNothing);
      });

      testWidgets('tapping back button pops navigation', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(427, 1800);
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
                      Navigator.pushNamed(
                        context,
                        AppRoutes.professionalCredentials,
                      );
                    },
                    child: const Text('Go to Credentials'),
                  ),
                ),
              ),
              AppRoutes.professionalCredentials: (context) =>
                  const ProfessionalCredentialsScreen(),
            },
          ),
        );
        await tester.pumpAndSettle();

        // Navigate to Professional Credentials
        await tester.tap(find.text('Go to Credentials'));
        await tester.pumpAndSettle();

        expect(find.text('Professional Credentials'), findsOneWidget);

        // Tap back button
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        // Should be back at Doctor Profile
        expect(find.text('Go to Credentials'), findsOneWidget);
        expect(find.text('Professional Credentials'), findsNothing);
      });

      testWidgets('tapping bottom nav items triggers navigation', (
        WidgetTester tester,
      ) async {
        tester.view.physicalSize = const Size(427, 1800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap Patients
        await tester.tap(find.text('Patients'));
        await tester.pumpAndSettle();
        expect(find.text('Patient Directory Screen'), findsOneWidget);
      });
    },
  );
}
