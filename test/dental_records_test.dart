import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/dental_records_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/data/mock_data.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  Widget createTestWidget({Patient? patientArg, NavigatorObserver? observer}) {
    return MaterialApp(
      navigatorObservers: observer != null ? [observer] : [],
      routes: {
        AppRoutes.dentalRecords: (context) =>
            DentalRecordsScreen(patientArg: patientArg),
        AppRoutes.medicalRecords: (context) => Scaffold(
          appBar: AppBar(title: const Text('Medical Records Page')),
          body: const Text('Medical Records Body'),
        ),
        AppRoutes.visionRecords: (context) => Scaffold(
          appBar: AppBar(title: const Text('Vision Records Page')),
          body: const Text('Vision Records Body'),
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
      },
      home: DentalRecordsScreen(patientArg: patientArg),
    );
  }

  group('DentalRecordsScreen - Figma Node 10:7623 Visual Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:7623', (
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

      // 1. TopAppBar (Figma Node 10:7650)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byType(Image), findsWidgets); // CareID logo & doctor avatar

      // 2. Heading: "Dental Records" (Figma Node 10:7660)
      expect(find.text('Dental Records'), findsOneWidget);

      // 3. Search Bar with Filter Icon (Figma Node 10:7661)
      expect(find.text('Search records, labs, doctors...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

      // 4. Horizontal Category Chips (Figma Node 10:7669)
      expect(find.text('All Records'), findsOneWidget);
      expect(find.text('Medical'), findsOneWidget);
      expect(find.text('Dental'), findsOneWidget);
      expect(find.text('Vision'), findsOneWidget);

      // 5. Timeline Section (Figma Node 10:7680)
      // Card 1: Routine Cleaning & Exam
      expect(find.text('Nov 12, 2023'), findsOneWidget);
      expect(find.text('Routine Cleaning & Exam'), findsOneWidget);
      expect(find.text('Prevention'), findsOneWidget);
      expect(find.text('Smile Dental Clinic'), findsWidgets);
      expect(find.text('Dr. Mark Thompson'), findsWidgets);
      expect(find.text('Verified'), findsWidgets);

      // Card 2: Panoramic X-Ray
      expect(find.text('June 15, 2023'), findsOneWidget);
      expect(find.text('Panoramic X-Ray'), findsOneWidget);
      expect(find.text('Diagnostic Imaging'), findsOneWidget);

      // Card 3: Wisdom Tooth Extraction
      expect(find.text('Jan 20, 2023'), findsOneWidget);
      expect(find.text('Wisdom Tooth Extraction'), findsOneWidget);
      expect(find.text('Oral Surgery'), findsOneWidget);
      expect(find.text('City Oral Surgery'), findsOneWidget);
      expect(find.text('Dr. Sarah Lee'), findsOneWidget);
      expect(find.text('Archived'), findsOneWidget);

      // Metadata labels
      expect(find.text('FACILITY'), findsNWidgets(3));
      expect(find.text('PHYSICIAN'), findsNWidgets(3));

      // 6. Floating Bottom Navigation Shell (Figma Node 10:7624)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('Tapping a dental card navigates to medical record details', (
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

      await tester.tap(find.text('Routine Cleaning & Exam'));
      await tester.pumpAndSettle();

      expect(find.text('Record Details Page'), findsOneWidget);
    });

    testWidgets('Search query filters dental records dynamically', (
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

      await tester.enterText(find.byType(TextField), 'Extraction');
      await tester.pumpAndSettle();

      expect(find.text('Wisdom Tooth Extraction'), findsOneWidget);
      expect(find.text('Routine Cleaning & Exam'), findsNothing);
      expect(find.text('Panoramic X-Ray'), findsNothing);
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
  });
}
