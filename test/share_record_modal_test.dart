import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/share_record_modal.dart';
import 'package:careid_doctor/data/mock_data.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  Widget createTestWidget({
    MedicalRecordItem? record,
    NavigatorObserver? observer,
  }) {
    return MaterialApp(
      navigatorObservers: observer != null ? [observer] : [],
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) =>
                      ShareRecordModal(record: record ?? MockData.records[0]),
                );
              },
              child: const Text('Open Modal'),
            );
          },
        ),
      ),
    );
  }

  group('ShareRecordModal - Figma Node 10:7512 Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:7512', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 937);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testRecord = MockData.records[0];
      await tester.pumpWidget(createTestWidget(record: testRecord));
      await tester.pumpAndSettle();

      // Open Modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // 1. Header (Figma Node 10:7515)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.text('Share Record'), findsOneWidget);
      expect(find.byIcon(Icons.print_outlined), findsOneWidget);

      // 2. Record Information Card (Figma Node 10:7525)
      expect(find.byIcon(Icons.article_outlined), findsWidgets);
      expect(find.text(testRecord.title), findsOneWidget);
      expect(find.text('2 Pages • PDF • 1.2 MB'), findsOneWidget);
      expect(find.text('VERIFIED'), findsOneWidget);

      // 3. SELECT METHOD Section (Figma Node 10:7537)
      expect(find.text('SELECT METHOD'), findsOneWidget);
      expect(find.text('Secure Link'), findsOneWidget);
      expect(find.text('Expires in 24 hours'), findsOneWidget);
      expect(find.text('Email PDF'), findsOneWidget);
      expect(find.text('Direct encrypted attachment'), findsOneWidget);
      expect(find.text('Fax to Provider'), findsOneWidget);
      expect(find.text('HIPAA compliant fax transmission'), findsOneWidget);

      // 4. RECIPIENT DETAILS Section (Figma Node 10:7572)
      expect(find.text('RECIPIENT DETAILS'), findsOneWidget);
      expect(find.text('Email or Phone Number'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);

      // 5. HIPAA Security Banner (Figma Node 10:7582)
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(
        find.textContaining('All transfers are end-to-end encrypted'),
        findsOneWidget,
      );

      // 6. Action Button (Figma Node 10:7587)
      expect(find.text('Send Document'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('allows switching between sharing methods', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 937);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Tap Email PDF option
      await tester.tap(find.text('Email PDF'));
      await tester.pumpAndSettle();

      // Tap Fax to Provider option
      await tester.tap(find.text('Fax to Provider'));
      await tester.pumpAndSettle();

      // Tap back to Secure Link
      await tester.tap(find.text('Secure Link'));
      await tester.pumpAndSettle();
    });

    testWidgets(
      'entering recipient and tapping Send Document shares document and pops modal',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 937);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final testRecord = MockData.records[0];
        await tester.pumpWidget(createTestWidget(record: testRecord));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Open Modal'));
        await tester.pumpAndSettle();

        // Enter recipient details
        await tester.enterText(find.byType(TextField), 'doctor@hospital.org');
        await tester.pumpAndSettle();

        // Tap Send Document
        await tester.tap(find.text('Send Document'));
        await tester.pumpAndSettle();

        // Verify modal is dismissed
        expect(find.byType(ShareRecordModal), findsNothing);

        // Verify SnackBar confirmation
        expect(
          find.textContaining(
            'shared via Secure Link with doctor@hospital.org',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('tapping back button dismisses modal', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 937);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.byType(ShareRecordModal), findsOneWidget);

      // Tap Back Button
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Verify modal is dismissed
      expect(find.byType(ShareRecordModal), findsNothing);
    });

    testWidgets('tapping print button triggers SnackBar', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 937);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Tap Print Button
      await tester.tap(find.byIcon(Icons.print_outlined));
      await tester.pump();

      expect(find.text('Sending document to printer...'), findsOneWidget);
    });
  });
}
