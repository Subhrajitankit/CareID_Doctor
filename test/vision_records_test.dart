import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/vision_records_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/data/mock_data.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  Widget createTestWidget({Patient? patientArg, NavigatorObserver? observer}) {
    return MaterialApp(
      navigatorObservers: observer != null ? [observer] : [],
      routes: {
        AppRoutes.visionRecords: (context) =>
            VisionRecordsScreen(patientArg: patientArg),
        AppRoutes.medicalRecords: (context) => Scaffold(
          appBar: AppBar(title: const Text('Medical Records Page')),
          body: const Text('Medical Records Body'),
        ),
        AppRoutes.dentalRecords: (context) => Scaffold(
          appBar: AppBar(title: const Text('Dental Records Page')),
          body: const Text('Dental Records Body'),
        ),
        AppRoutes.medicalRecordDetails: (context) => Scaffold(
          appBar: AppBar(title: const Text('Record Details Page')),
          body: const Text('Record Details Body'),
        ),
        AppRoutes.dashboard: (context) => Scaffold(
          appBar: AppBar(title: const Text('Dashboard Page')),
          body: const Text('Dashboard Body'),
        ),
        AppRoutes.doctorProfile: (context) => Scaffold(
          appBar: AppBar(title: const Text('Doctor Profile Page')),
          body: const Text('Doctor Profile Body'),
        ),
        AppRoutes.patientDirectory: (context) => Scaffold(
          appBar: AppBar(title: const Text('Patient Directory Page')),
          body: const Text('Patient Directory Body'),
        ),
        AppRoutes.appointmentsOverview: (context) => Scaffold(
          appBar: AppBar(title: const Text('Appointments Page')),
          body: const Text('Appointments Body'),
        ),
        AppRoutes.petRecords: (context) => Scaffold(
          appBar: AppBar(title: const Text('Companion Health (Pet CareID)')),
          body: const Text('Pet Records Body'),
        ),
      },
      home: VisionRecordsScreen(patientArg: patientArg),
    );
  }

  group('VisionRecordsScreen - Figma Node 10:7803 Visual Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:7803', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(440, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testPatient = MockData.patients.first;
      await tester.pumpWidget(createTestWidget(patientArg: testPatient));
      await tester.pumpAndSettle();

      // 1. TopAppBar (Figma Node 10:7830)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byType(Image), findsWidgets); // CareID logo & doctor avatar

      // 2. Heading: "Vision Records" (Figma Node 10:7840)
      expect(find.text('Vision Records'), findsOneWidget);

      // 3. Search Bar with Filter Icon (Figma Node 10:7841)
      expect(find.text('Search records, labs, doctors...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

      // 4. Horizontal Category Chips (Figma Node 10:7849)
      expect(find.text('All Records'), findsOneWidget);
      expect(find.text('Medical'), findsOneWidget);
      expect(find.text('Dental'), findsOneWidget);
      expect(find.text('Vision'), findsOneWidget);

      // 5. Timeline Section (Figma Node 10:7860)
      // Card 1: Comprehensive Eye Exam
      expect(find.text('Dec 05, 2023'), findsNWidgets(2));
      expect(find.text('Comprehensive Eye Exam'), findsOneWidget);
      expect(find.text('Standard Checkup'), findsOneWidget);
      expect(find.text('ClearView Optometry'), findsNWidgets(2));
      expect(find.text('Dr. Alice Wong'), findsNWidgets(2));
      expect(find.text('VERIFIED'), findsNWidgets(3));

      // Card 2: Contact Lens Fitting
      expect(find.text('Contact Lens Fitting'), findsOneWidget);
      expect(find.text('Specialized Exam'), findsOneWidget);

      // Card 3: Retinal Imaging
      expect(find.text('May 12, 2023'), findsOneWidget);
      expect(find.text('Retinal Imaging'), findsOneWidget);
      expect(find.text('Advanced Diagnostics'), findsOneWidget);
      expect(find.text('Vision Care Center'), findsOneWidget);
      expect(find.text('Dr. James Carter'), findsOneWidget);

      // Metadata labels
      expect(find.text('FACILITY'), findsNWidgets(3));
      expect(find.text('PHYSICIAN'), findsNWidgets(3));

      // 6. Floating Bottom Navigation Shell (Figma Node 10:7804)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('Tapping a vision card navigates to medical record details', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(440, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Comprehensive Eye Exam'));
      await tester.pumpAndSettle();

      expect(find.text('Record Details Page'), findsOneWidget);
    });

    testWidgets('Search query filters vision records dynamically', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(440, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Retinal');
      await tester.pumpAndSettle();

      expect(find.text('Retinal Imaging'), findsOneWidget);
      expect(find.text('Comprehensive Eye Exam'), findsNothing);
      expect(find.text('Contact Lens Fitting'), findsNothing);
    });

    testWidgets('Tapping category chips triggers proper navigation', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(440, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap All Records
      await tester.tap(find.text('All Records'));
      await tester.pumpAndSettle();

      expect(find.text('Medical Records Page'), findsOneWidget);
    });

    testWidgets('Tapping PET button navigates to Pet Records screen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(440, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('PET'), findsOneWidget);

      await tester.ensureVisible(find.text('PET'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('PET'));
      await tester.pumpAndSettle();

      expect(find.text('Companion Health (Pet CareID)'), findsOneWidget);
    });
  });
}
