import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/filter_records_bottom_sheet.dart';
import 'package:careid_doctor/features/medical_records/medical_records_timeline_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';

void main() {
  Widget createTestBottomSheet({
    Set<String>? initialTypes,
    String? initialRange,
    String? initialFacility,
    ValueChanged<Map<String, dynamic>>? onApply,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => FilterRecordsBottomSheet(
                      initialTypes: initialTypes,
                      initialRange: initialRange,
                      initialFacility: initialFacility,
                      onApply: onApply,
                    ),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            );
          },
        ),
      ),
    );
  }

  group('FilterRecordsBottomSheet - Figma Node 10:7354 Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:7354',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestBottomSheet());
      await tester.pumpAndSettle();

      // Open bottom sheet
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // 1. Header (Node 10:7357)
      expect(find.text('Filter Records'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // 2. Section Headings (Node 10:7368, 10:7388, 10:7414)
      expect(find.text('RECORD TYPE'), findsOneWidget);
      expect(find.text('DATE RANGE'), findsOneWidget);
      expect(find.text('FACILITY'), findsOneWidget);

      // 3. Record Type Chips (Node 10:7369)
      expect(find.text('Lab Report'), findsOneWidget);
      expect(find.text('Imaging'), findsOneWidget);
      expect(find.text('Prescription'), findsOneWidget);
      expect(find.text('Clinical Note'), findsOneWidget);
      expect(find.text('Dental'), findsOneWidget);
      expect(find.text('Vision'), findsOneWidget);

      // 'Lab Report' is selected by default in Figma and shows checkmark
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // 4. Date Range Elements (Node 10:7389)
      expect(find.text('Last 3 months'), findsOneWidget);
      expect(find.text('From'), findsOneWidget);
      expect(find.text('To'), findsOneWidget);

      // 5. Facility Elements (Node 10:7412)
      expect(find.text('Search facilities...'), findsOneWidget);
      expect(find.text('Metro General Hospital'), findsOneWidget);
      expect(find.text('City Clinic Branch 4'), findsOneWidget);

      // 6. Action Buttons (Node 10:7433)
      expect(find.text('Clear All'), findsOneWidget);
      expect(find.text('Apply Filters'), findsOneWidget);
    });

    testWidgets('Record type chips toggle selection correctly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestBottomSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Initially 'Lab Report' has 1 checkmark
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);

      // Tap 'Imaging' to select it
      await tester.tap(find.text('Imaging'));
      await tester.pumpAndSettle();

      // Now 2 chips have checkmarks
      expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));

      // Tap 'Lab Report' to deselect it
      await tester.tap(find.text('Lab Report'));
      await tester.pumpAndSettle();

      // Only 1 checkmark remains (Imaging)
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('Facility search filters badges in real-time',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestBottomSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Enter facility search query
      final searchInput = find.widgetWithText(TextField, '');
      await tester.enterText(searchInput, 'Metro');
      await tester.pumpAndSettle();

      expect(find.text('Metro General Hospital'), findsOneWidget);
      expect(find.text('City Clinic Branch 4'), findsNothing);
    });

    testWidgets('Clear All resets all filter selections',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestBottomSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Select another chip
      await tester.tap(find.text('Dental'));
      await tester.pumpAndSettle();

      // Tap Clear All
      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();

      // No checkmarks should remain
      expect(find.byIcon(Icons.check_rounded), findsNothing);
      expect(find.text('All Time'), findsOneWidget);
    });

    testWidgets('Apply Filters passes criteria and closes bottom sheet',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Map<String, dynamic>? appliedData;
      await tester.pumpWidget(createTestBottomSheet(
        onApply: (data) {
          appliedData = data;
        },
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Tap Apply Filters
      await tester.tap(find.text('Apply Filters'));
      await tester.pumpAndSettle();

      // Bottom sheet should be dismissed
      expect(find.text('Filter Records'), findsNothing);
      expect(appliedData, isNotNull);
      expect((appliedData!['types'] as Set<String>).contains('Lab Report'), isTrue);
    });

    testWidgets('Close button dismisses sheet without applying changes',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestBottomSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Tap close button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Filter Records'), findsNothing);
    });

    testWidgets('MedicalRecordsTimelineScreen opens FilterRecordsBottomSheet on filter icon tap',
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
            AppRoutes.medicalRecords: (_) => const MedicalRecordsTimelineScreen(),
          },
          home: const MedicalRecordsTimelineScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the filter icon next to the search bar
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();

      // Verify FilterRecordsBottomSheet is opened
      expect(find.text('Filter Records'), findsOneWidget);
      expect(find.text('RECORD TYPE'), findsOneWidget);
      expect(find.text('Apply Filters'), findsOneWidget);
    });
  });
}

