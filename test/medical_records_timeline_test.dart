import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/medical_records_timeline_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/data/mock_data.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  Widget createTestWidget({Patient? patientArg, NavigatorObserver? observer}) {
    return MaterialApp(
      navigatorObservers: observer != null ? [observer] : [],
      routes: {
        AppRoutes.medicalRecords: (context) =>
            MedicalRecordsTimelineScreen(patientArg: patientArg),
        AppRoutes.dentalRecords: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Dental Records Screen'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: const Text('Dental Records Body'),
        ),
        AppRoutes.visionRecords: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Vision Records Screen'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: const Text('Vision Records Body'),
        ),
        AppRoutes.petRecords: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('PET Records Screen'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: const Text('PET Records Body'),
        ),
        AppRoutes.medicalRecordDetails: (context) => Scaffold(
          appBar: AppBar(title: const Text('Record Details Page')),
          body: const Text('Record Details Body'),
        ),
        AppRoutes.documentViewer: (context) => Scaffold(
          appBar: AppBar(title: const Text('Document Viewer Page')),
          body: const Text('Document Viewer Body'),
        ),
        AppRoutes.dashboard: (context) => Scaffold(
          appBar: AppBar(title: const Text('Dashboard Page')),
          body: const Text('Dashboard Body'),
        ),
        AppRoutes.patientDirectory: (context) => Scaffold(
          appBar: AppBar(title: const Text('Patient Directory Page')),
          body: const Text('Patient Directory Body'),
        ),
        AppRoutes.cameraPermission: (context) => Scaffold(
          appBar: AppBar(title: const Text('Camera Permission Page')),
          body: const Text('Camera Permission Body'),
        ),
        AppRoutes.appointmentsOverview: (context) => Scaffold(
          appBar: AppBar(title: const Text('Appointments Overview Page')),
          body: const Text('Appointments Overview Body'),
        ),
        AppRoutes.doctorProfile: (context) => Scaffold(
          appBar: AppBar(title: const Text('Doctor Profile Page')),
          body: const Text('Doctor Profile Body'),
        ),
      },
      home: MedicalRecordsTimelineScreen(patientArg: patientArg),
    );
  }

  group('MedicalRecordsTimelineScreen - Figma Node 10:1887 Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:1887', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 1328);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 1. Page Title "Health  Records" (Node 10:1923)
      expect(find.text('Health  Records'), findsOneWidget);

      // 2. Search Bar (Node 10:1924, 10:1928)
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search records, labs, doctors...'), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

      // 3. Filter Chips (Node 10:1932)
      expect(find.text('All Records'), findsOneWidget);
      expect(find.text('Medical'), findsOneWidget);
      expect(find.text('Dental'), findsWidgets);
      expect(find.text('Vision'), findsWidgets);
      expect(find.text('Clinical Notes'), findsOneWidget);
      expect(find.text('PET'), findsWidgets);

      // 4. Timeline Records & Cards
      expect(find.text('Facility'), findsWidgets);
      expect(find.text('Physician'), findsWidgets);
      expect(find.text('Verified'), findsWidgets);

      // 5. Floating Bottom Navigation Shell (Node 10:1888)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('Filter chips switch and filter records list correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 1328);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially All Records are visible
      expect(find.text(MockData.records.first.title), findsOneWidget);

      // Ensure "Lab Reports" chip is scrolled into view and tap it
      final labChip = find.text('Lab Reports').first;
      await tester.ensureVisible(labChip);
      await tester.pumpAndSettle();
      await tester.tap(labChip);
      await tester.pumpAndSettle();

      // Only lab records should appear
      expect(find.text('Comprehensive Metabolic Panel (CMP)'), findsOneWidget);
      expect(find.text('12-Lead Electrocardiogram (ECG)'), findsNothing);

      // Tap "All Records" to reset
      final allChip = find.text('All Records');
      await tester.ensureVisible(allChip);
      await tester.pumpAndSettle();
      await tester.tap(allChip);
      await tester.pumpAndSettle();

      expect(find.text('12-Lead Electrocardiogram (ECG)'), findsOneWidget);
    });

    testWidgets(
      'Tapping Dental category button navigates to Dental Records screen and supports back navigation',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(427, 1328);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final dentalButton = find.text('Dental').first;
        await tester.ensureVisible(dentalButton);
        await tester.pumpAndSettle();
        await tester.tap(dentalButton);
        await tester.pumpAndSettle();

        expect(find.text('Dental Records Screen'), findsOneWidget);
        expect(find.text('Dental Records Body'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.text('Health  Records'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping Vision category button navigates to Vision Records screen and supports back navigation',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(427, 1328);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final visionButton = find.text('Vision').first;
        await tester.ensureVisible(visionButton);
        await tester.pumpAndSettle();
        await tester.tap(visionButton);
        await tester.pumpAndSettle();

        expect(find.text('Vision Records Screen'), findsOneWidget);
        expect(find.text('Vision Records Body'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.text('Health  Records'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping PET category button navigates to PET Records screen and supports back navigation',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(427, 1328);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final petButton = find.text('PET').first;
        await tester.ensureVisible(petButton);
        await tester.pumpAndSettle();
        await tester.tap(petButton);
        await tester.pumpAndSettle();

        expect(find.text('PET Records Screen'), findsOneWidget);
        expect(find.text('PET Records Body'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.text('Health  Records'), findsOneWidget);
      },
    );

    testWidgets('Search query filters records in real-time', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 1328);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Metabolic');
      await tester.pumpAndSettle();

      expect(find.text('Comprehensive Metabolic Panel (CMP)'), findsOneWidget);
      expect(find.text('Annual Dental Panoramic X-Ray'), findsNothing);

      // Clear search via cancel icon
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();

      expect(find.text('Annual Dental Panoramic X-Ray'), findsOneWidget);
    });

    testWidgets('Tapping record card navigates to medical record details', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 1328);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on the first record card
      final firstRecordTitle = MockData.records.first.title;
      await tester.tap(find.text(firstRecordTitle));
      await tester.pumpAndSettle();

      expect(find.text('Record Details Page'), findsOneWidget);
    });

    testWidgets(
      'Tapping Dental record item navigates to Dental Records screen and supports back navigation',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(427, 1328);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find and scroll to the Dental record item
        final dentalRecordFinder = find.text('Annual Dental Panoramic X-Ray');
        await tester.ensureVisible(dentalRecordFinder);
        await tester.pumpAndSettle();

        // Tap on the Dental record item
        await tester.tap(dentalRecordFinder);
        await tester.pumpAndSettle();

        // Verify Dental Records Screen is opened
        expect(find.text('Dental Records Screen'), findsOneWidget);
        expect(find.text('Dental Records Body'), findsOneWidget);

        // Verify back navigation returns to Medical Records Timeline screen
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.text('Health  Records'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping Dental record item navigates to Dental Records screen and supports back navigation',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(427, 1328);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find and scroll to the Dental record item
        final dentalRecordFinder = find.text('Annual Dental Panoramic X-Ray');
        await tester.ensureVisible(dentalRecordFinder);
        await tester.pumpAndSettle();

        // Tap on the Dental record item
        await tester.tap(dentalRecordFinder);
        await tester.pumpAndSettle();

        // Verify Dental Records Screen is opened
        expect(find.text('Dental Records Screen'), findsOneWidget);
        expect(find.text('Dental Records Body'), findsOneWidget);

        // Verify back navigation returns to Medical Records Timeline screen
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.text('Health  Records'), findsOneWidget);
      },
    );

    testWidgets('Tapping PDF link navigates to document viewer', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(427, 1328);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap "View PDF Document"
      await tester.tap(find.text('View PDF Document').first);
      await tester.pumpAndSettle();

      expect(find.text('Document Viewer Page'), findsOneWidget);
    });

    testWidgets(
      'Floating Bottom Navigation items navigate to designated routes',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(427, 1328);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap Schedule
        await tester.tap(find.text('Schedule'));
        await tester.pumpAndSettle();
        expect(find.text('Appointments Overview Page'), findsOneWidget);
      },
    );
  });
}
