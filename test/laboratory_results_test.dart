import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/laboratory_results_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/data/mock_data.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  Widget createTestWidget({Patient? patientArg, NavigatorObserver? observer}) {
    return MaterialApp(
      navigatorObservers: observer != null ? [observer] : [],
      routes: {
        AppRoutes.labSummary: (context) =>
            LaboratoryResultsScreen(patientArg: patientArg),
        AppRoutes.dashboard: (context) => Scaffold(
          appBar: AppBar(title: const Text('Dashboard Page')),
          body: const Text('Dashboard Body'),
        ),
        AppRoutes.doctorProfile: (context) => Scaffold(
          appBar: AppBar(title: const Text('Doctor Profile Page')),
          body: const Text('Doctor Profile Body'),
        ),
        AppRoutes.addAddendum: (context) => Scaffold(
          appBar: AppBar(title: const Text('Add Addendum Page')),
          body: const Text('Add Addendum Body'),
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
      home: LaboratoryResultsScreen(patientArg: patientArg),
    );
  }

  group('LaboratoryResultsScreen - Figma Node 10:2299 Visual Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:2299', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testPatient = MockData.patients.first;
      await tester.pumpWidget(createTestWidget(patientArg: testPatient));
      await tester.pumpAndSettle();

      // 1. TopAppBar (Figma Node 10:2325)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byType(Image), findsWidgets); // CareID logo & doctor avatar

      // 2. Header Section (Figma Node 10:2334)
      expect(
        find.textContaining('Patient: ${testPatient.name}'),
        findsOneWidget,
      );
      expect(find.text('Comprehensive\nMetabolic Panel'), findsOneWidget);
      expect(find.text('Export PDF'), findsOneWidget);
      expect(find.text('Add Clinical Note'), findsOneWidget);
      expect(find.byIcon(Icons.file_download_outlined), findsOneWidget);
      expect(find.byIcon(Icons.edit_note_rounded), findsWidgets);

      // 3. Meta Info Card (Figma Node 10:2349)
      expect(find.text('Collected'), findsOneWidget);
      expect(find.text('Oct 24, 2023 - 08:30 AM'), findsOneWidget);
      expect(find.text('Received'), findsOneWidget);
      expect(find.text('Oct 24, 2023 - 10:15 AM'), findsOneWidget);
      expect(find.text('Ordering Physician'), findsOneWidget);
      expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
      expect(find.text('Lab Facility'), findsOneWidget);
      expect(find.text('Core Diagnostics Lab'), findsOneWidget);

      // 4. Lab Results Table Card (Figma Node 10:2371)
      expect(find.text('Lab Results'), findsOneWidget);
      expect(find.text('12 Normal'), findsOneWidget);
      expect(find.text('2 Critical'), findsOneWidget);
      expect(find.text('Test Name'), findsOneWidget);
      expect(find.text('Result'), findsOneWidget);
      expect(find.text('Reference Range'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('6mo Trend'), findsOneWidget);

      // Tests in table
      expect(find.text('Glucose'), findsOneWidget);
      expect(find.text('92 mg/dL'), findsOneWidget);
      expect(find.text('70 - 99 mg/dL'), findsOneWidget);

      expect(find.text('BUN'), findsOneWidget);
      expect(find.text('14 mg/dL'), findsOneWidget);
      expect(find.text('6 - 20 mg/dL'), findsOneWidget);

      expect(find.text('Creatinine'), findsWidgets);
      expect(find.text('1.5 mg/dL'), findsOneWidget);
      expect(find.text('0.6 - 1.2 mg/dL'), findsOneWidget);

      expect(find.text('Sodium'), findsOneWidget);
      expect(find.text('140 mEq/L'), findsOneWidget);
      expect(find.text('135 - 145 mEq/L'), findsOneWidget);

      expect(find.text('Potassium'), findsOneWidget);
      expect(find.text('3.1 mEq/L'), findsOneWidget);
      expect(find.text('3.5 - 5.1 mEq/L'), findsOneWidget);

      expect(find.text('Calcium'), findsOneWidget);
      expect(find.text('9.5 mg/dL'), findsOneWidget);
      expect(find.text('8.5 - 10.2 mg/dL'), findsOneWidget);

      // Critical warning icons in table
      expect(find.byIcon(Icons.warning_amber_rounded), findsNWidgets(2));

      // 5. Clinical Alerts Card (Figma Node 10:2475)
      expect(find.text('Clinical Alerts'), findsOneWidget);
      expect(find.byIcon(Icons.error_rounded), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('declining renal function'),
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Hypokalemia'),
        ),
        findsOneWidget,
      );

      // 6. Physician Notes / Draft Interpretation (Figma Node 10:2492)
      expect(find.text('Draft Interpretation'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Save Draft'), findsOneWidget);
      expect(find.text('Sign & Finalize'), findsOneWidget);

      // 7. Floating Bottom Navigation Shell (Figma Node 10:2300)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('Export PDF shows confirmation SnackBar', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Export PDF'));
      await tester.pump();

      expect(find.text('Exporting PDF laboratory report...'), findsOneWidget);
    });

    testWidgets('Save Draft shows confirmation SnackBar', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Draft'));
      await tester.pump();

      expect(find.text('Draft interpretation saved.'), findsOneWidget);
    });

    testWidgets('Sign & Finalize shows confirmation SnackBar', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign & Finalize'));
      await tester.pump();

      expect(
        find.text('Report signed and finalized successfully.'),
        findsOneWidget,
      );
    });

    testWidgets('Add Clinical Note navigates to Add Addendum screen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Clinical Note'));
      await tester.pumpAndSettle();

      expect(find.text('Add Addendum Page'), findsOneWidget);
    });

    testWidgets('Bottom nav tabs trigger proper routes', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Dashboard Page'), findsOneWidget);
    });
  });
}
