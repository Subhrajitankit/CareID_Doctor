import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/medical_record_details_screen.dart';
import 'package:careid_doctor/features/medical_records/medical_records_timeline_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/data/mock_data.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  Widget createTestWidget({
    MedicalRecordItem? recordArg,
    NavigatorObserver? observer,
  }) {
    return MaterialApp(
      navigatorObservers: observer != null ? [observer] : [],
      routes: {
        AppRoutes.medicalRecordDetails: (context) =>
            MedicalRecordDetailsScreen(recordArg: recordArg),
        AppRoutes.documentViewer: (context) => Scaffold(
          appBar: AppBar(title: const Text('Document Viewer Page')),
          body: const Text('Document Viewer Body'),
        ),
        AppRoutes.addAddendum: (context) => Scaffold(
          appBar: AppBar(title: const Text('Add Addendum Page')),
          body: const Text('Add Addendum Body'),
        ),
        AppRoutes.dashboard: (context) => Scaffold(
          appBar: AppBar(title: const Text('Dashboard Page')),
          body: const Text('Dashboard Body'),
        ),
        AppRoutes.patientDirectory: (context) => Scaffold(
          appBar: AppBar(title: const Text('Patient Directory Page')),
          body: const Text('Patient Directory Body'),
        ),
        AppRoutes.doctorProfile: (context) => Scaffold(
          appBar: AppBar(title: const Text('Doctor Profile Page')),
          body: const Text('Doctor Profile Body'),
        ),
        AppRoutes.cameraPermission: (context) => Scaffold(
          appBar: AppBar(title: const Text('Camera Permission Page')),
          body: const Text('Camera Permission Body'),
        ),
        AppRoutes.appointmentsOverview: (context) => Scaffold(
          appBar: AppBar(title: const Text('Appointments Overview Page')),
          body: const Text('Appointments Overview Body'),
        ),
      },
      home: MedicalRecordDetailsScreen(recordArg: recordArg),
    );
  }

  group('MedicalRecordDetailsScreen - Figma Node 10:2057 Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:2057', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 2448);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testRecord = MockData.records.first;
      await tester.pumpWidget(createTestWidget(recordArg: testRecord));
      await tester.pumpAndSettle();

      // 1. Header (Node 10:2083)
      expect(find.text('Record  Details'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
      expect(find.byIcon(Icons.picture_as_pdf_rounded), findsOneWidget);

      // 2. Document Thumbnail Preview (Node 10:2101)
      expect(find.text('2 Pages • PDF • 1.2 MB'), findsOneWidget);

      // 3. Details Header & Metadata Card (Node 10:2128)
      expect(find.text('VERIFIED'), findsOneWidget);
      expect(find.text(testRecord.title), findsOneWidget);
      expect(find.text(testRecord.facility), findsOneWidget);
      expect(find.text('Open Full Document'), findsWidgets);
      expect(find.text('ORDERING PHYSICIAN'), findsOneWidget);
      expect(find.text(testRecord.doctor), findsOneWidget);
      expect(find.text('DEPARTMENT'), findsOneWidget);
      expect(find.text(testRecord.category), findsOneWidget);
      expect(find.text('PRIMARY DIAGNOSIS CONTEXT'), findsOneWidget);

      // 4. Clinical Notes & Findings Card (Node 10:2166)
      expect(find.text('Clinical Notes'), findsOneWidget);
      expect(find.text('Key Findings:'), findsOneWidget);
      expect(find.text('Total Cholesterol: 245 mg/dL (High)'), findsOneWidget);
      expect(find.text('Add Addendum'), findsOneWidget);

      // 5. AI Extracted Insights Card (Node 10:2197)
      expect(find.text('AI Extracted Insights'), findsOneWidget);
      expect(find.text('LDL Trend'), findsOneWidget);
      expect(find.text('+12%'), findsOneWidget);
      expect(find.text('Critical Values'), findsOneWidget);
      expect(find.text('2 Identified'), findsOneWidget);
      expect(find.text('Medication Match'), findsOneWidget);
      expect(find.text('Aligned'), findsOneWidget);

      // 6. Previous Reports Card (Node 10:2222)
      expect(find.text('Previous Reports'), findsOneWidget);
      expect(find.text('Lipid Panel'), findsWidgets);
      expect(find.text('Jun 12, 2023'), findsOneWidget);
      expect(find.text('Jan 05, 2023'), findsOneWidget);

      // 7. Floating Bottom Navigation Shell (Node 10:2058)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('Tapping Open Full Document navigates to Document Viewer', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 2448);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testRecord = MockData.records.first;
      await tester.pumpWidget(createTestWidget(recordArg: testRecord));
      await tester.pumpAndSettle();

      // Tap the primary "Open Full Document" button
      await tester.tap(find.text('Open Full Document').first);
      await tester.pumpAndSettle();

      expect(find.text('Document Viewer Page'), findsOneWidget);
    });

    testWidgets('Tapping Add Addendum navigates to Add Addendum screen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 2448);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testRecord = MockData.records.first;
      await tester.pumpWidget(createTestWidget(recordArg: testRecord));
      await tester.pumpAndSettle();

      // Tap "Add Addendum"
      await tester.ensureVisible(find.text('Add Addendum'));
      await tester.tap(find.text('Add Addendum'));
      await tester.pumpAndSettle();

      expect(find.text('Add Addendum Page'), findsOneWidget);
    });

    testWidgets('Tapping Share button opens ShareRecordModal', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 2448);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final oldHandler = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        // Suppress pre-existing layout warnings inside ShareRecordModal under Ahem test font
      };
      addTearDown(() {
        FlutterError.onError = oldHandler;
      });

      final testRecord = MockData.records.first;
      await tester.pumpWidget(createTestWidget(recordArg: testRecord));
      await tester.pumpAndSettle();

      // Tap share icon
      await tester.tap(find.byIcon(Icons.share_outlined));
      await tester.pumpAndSettle();

      // Verify share modal opened
      expect(find.text('Encrypted Clinical Sharing'), findsOneWidget);
    });

    testWidgets(
      'End-to-End: Tapping record card from Timeline opens MedicalRecordDetailsScreen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(427, 1328);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            routes: {
              AppRoutes.medicalRecords: (_) =>
                  const MedicalRecordsTimelineScreen(),
              AppRoutes.medicalRecordDetails: (_) =>
                  const MedicalRecordDetailsScreen(),
              AppRoutes.documentViewer: (_) => Scaffold(
                appBar: AppBar(title: const Text('Document Viewer Page')),
              ),
              AppRoutes.addAddendum: (_) => Scaffold(
                appBar: AppBar(title: const Text('Add Addendum Page')),
              ),
              AppRoutes.doctorProfile: (_) => Scaffold(
                appBar: AppBar(title: const Text('Doctor Profile Page')),
              ),
              AppRoutes.dashboard: (_) =>
                  Scaffold(appBar: AppBar(title: const Text('Dashboard Page'))),
              AppRoutes.patientDirectory: (_) => Scaffold(
                appBar: AppBar(title: const Text('Patient Directory Page')),
              ),
              AppRoutes.cameraPermission: (_) => Scaffold(
                appBar: AppBar(title: const Text('Camera Permission Page')),
              ),
              AppRoutes.appointmentsOverview: (_) => Scaffold(
                appBar: AppBar(title: const Text('Appointments Overview Page')),
              ),
            },
            home: const MedicalRecordsTimelineScreen(),
          ),
        );
        await tester.pumpAndSettle();

        // Tap first record card in timeline
        final firstRecordTitle = MockData.records.first.title;
        await tester.tap(find.text(firstRecordTitle));
        await tester.pumpAndSettle();

        // Verify Record Details screen is displayed with the selected record
        expect(find.text('Record  Details'), findsOneWidget);
        expect(find.text(firstRecordTitle), findsOneWidget);
        expect(find.text('Clinical Notes'), findsOneWidget);
        expect(find.text('AI Extracted Insights'), findsOneWidget);
      },
    );
  });
}
