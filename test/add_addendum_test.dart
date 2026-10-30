import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/add_addendum_screen.dart';
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
        AppRoutes.addAddendum: (context) =>
            AddAddendumScreen(recordArg: recordArg),
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
      home: AddAddendumScreen(recordArg: recordArg),
    );
  }

  group('AddAddendumScreen - Figma Node 10:7439 Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:7439', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(375, 966);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testRecord = MockData.records.first;
      await tester.pumpWidget(createTestWidget(recordArg: testRecord));
      await tester.pumpAndSettle();

      // 1. Header (Node 10:7476)
      expect(find.text('Add Addendum'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // 2. Appended to Record Card (Node 10:7442)
      expect(find.text('APPENDED TO RECORD'), findsOneWidget);
      expect(
        find.text('${testRecord.title} - ${testRecord.date}'),
        findsOneWidget,
      );
      expect(
        find.text('${testRecord.facility} • ${testRecord.category}'),
        findsOneWidget,
      );
      expect(find.text('VERIFIED'), findsOneWidget);

      // 3. Addendum Details Form Section (Node 10:7457)
      expect(find.text('Addendum Details'), findsOneWidget);
      expect(find.byIcon(Icons.edit_note_rounded), findsOneWidget);
      expect(find.text('Enter the clinical addendum here...'), findsOneWidget);
      expect(
        find.text(
          'Note: This addendum will be permanently attached to the lipid profile record.',
        ),
        findsOneWidget,
      );

      // 4. Action Buttons (Node 10:7469)
      expect(find.text('Save Addendum'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // 5. Floating Bottom Navigation Shell (Node 10:7486)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('Validates empty addendum notes on Save Addendum tap', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(375, 966);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testRecord = MockData.records.first;
      await tester.pumpWidget(createTestWidget(recordArg: testRecord));
      await tester.pumpAndSettle();

      // Tap Save Addendum with empty text
      await tester.ensureVisible(find.text('Save Addendum'));
      await tester.tap(find.text('Save Addendum'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter clinical addendum notes'), findsOneWidget);
    });

    testWidgets('Submits addendum and appends to medical record', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(375, 966);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testRecord = MedicalRecordItem(
        id: 'test_rec_1',
        patientId: 'p1',
        title: 'Lipid Profile',
        date: 'Oct 24, 2023',
        facility: 'St. Jude Medical Center',
        category: 'Cardiology',
        summary: 'Baseline summary',
        doctor: 'Dr. Sarah Jenkins',
        addendums: [],
      );

      await tester.pumpWidget(createTestWidget(recordArg: testRecord));
      await tester.pumpAndSettle();

      // Enter notes
      await tester.enterText(
        find.byType(TextField),
        'Patient reports improved tolerance with evening dosage.',
      );
      await tester.pumpAndSettle();

      // Tap Save Addendum
      await tester.ensureVisible(find.text('Save Addendum'));
      await tester.tap(find.text('Save Addendum'));
      await tester.pumpAndSettle();

      // Verify addendum was appended
      expect(testRecord.addendums.length, 1);
      expect(
        testRecord.addendums.first,
        contains('Patient reports improved tolerance with evening dosage.'),
      );
    });

    testWidgets('Cancel button navigates back', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 966);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testRecord = MockData.records.first;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddAddendumScreen(recordArg: testRecord),
                  ),
                ),
                child: const Text('Open Addendum'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open Add Addendum
      await tester.tap(find.text('Open Addendum'));
      await tester.pumpAndSettle();

      expect(find.text('Add Addendum'), findsOneWidget);

      // Tap Cancel
      await tester.ensureVisible(find.text('Cancel'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Open Addendum'), findsOneWidget);
    });
  });
}
