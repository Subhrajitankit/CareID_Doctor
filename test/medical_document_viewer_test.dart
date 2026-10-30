import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/medical_document_viewer_screen.dart';
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
        AppRoutes.documentViewer: (context) =>
            MedicalDocumentViewerScreen(recordArg: recordArg),
        AppRoutes.dashboard: (context) => Scaffold(
          appBar: AppBar(title: const Text('Dashboard Page')),
          body: const Text('Dashboard Body'),
        ),
        AppRoutes.doctorProfile: (context) => Scaffold(
          appBar: AppBar(title: const Text('Doctor Profile Page')),
          body: const Text('Doctor Profile Body'),
        ),
      },
      home: MedicalDocumentViewerScreen(recordArg: recordArg),
    );
  }

  group('MedicalDocumentViewerScreen - Figma Node 10:2244 Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:2244', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 860);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testRecord = MockData.records[0];
      await tester.pumpWidget(createTestWidget(recordArg: testRecord));
      await tester.pumpAndSettle();

      // 1. TopAppBar (Figma Node 10:2245)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byType(Image), findsWidgets); // CareID logo & doctor avatar

      // 2. Sub-Header (Figma Node 10:2252)
      expect(find.byIcon(Icons.article_outlined), findsOneWidget);
      expect(find.text(testRecord.title), findsOneWidget);
      expect(find.textContaining('Patient: Doe, John'), findsOneWidget);

      // Sub-Header action buttons
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.file_download_outlined), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsOneWidget);

      // 3. Main Viewer Canvas & Floating Controls (Figma Node 10:2272, 10:2275)
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('/'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.restart_alt_rounded), findsOneWidget);
    });

    testWidgets('zoom in, zoom out, and reset update zoom percentage', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 860);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('100%'), findsOneWidget);

      // Zoom in (+25%)
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();
      expect(find.text('125%'), findsOneWidget);

      // Zoom in (+25%) -> 150%
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();
      expect(find.text('150%'), findsOneWidget);

      // Zoom out (-25%) -> 125%
      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pumpAndSettle();
      expect(find.text('125%'), findsOneWidget);

      // Reset zoom -> 100%
      await tester.tap(find.byIcon(Icons.restart_alt_rounded));
      await tester.pumpAndSettle();
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('pagination controls update page number', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 860);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);

      // Tap Next Page -> Page 2
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // Tap Next Page -> Page 3 (Current page 3 is weight 600)
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data == '3' &&
              w.style?.fontWeight == FontWeight.w600,
        ),
        findsOneWidget,
      );

      // Tap Previous Page -> Page 2
      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('action buttons trigger SnackBar messages', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 860);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Download
      await tester.tap(find.byIcon(Icons.file_download_outlined));
      await tester.pump();
      expect(
        find.text('Document downloaded to secure hospital vault'),
        findsOneWidget,
      );

      // Dismiss snackbars
      ScaffoldMessenger.of(
        tester.element(find.byType(MedicalDocumentViewerScreen)),
      ).clearSnackBars();
      await tester.pumpAndSettle();

      // Tap Share
      await tester.tap(find.byIcon(Icons.share_outlined));
      await tester.pump();
      expect(find.text('Sharing document...'), findsOneWidget);
    });

    testWidgets('back button pops screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 860);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final observer = _MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          home: const Scaffold(body: Text('Home')),
          routes: {
            '/doc': (context) => const MedicalDocumentViewerScreen(),
          },
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.text('Home'));
      Navigator.pushNamed(context, '/doc');
      await tester.pumpAndSettle();

      expect(find.byType(MedicalDocumentViewerScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(observer.popped, isTrue);
    });
  });
}

class _MockNavigatorObserver extends NavigatorObserver {
  bool popped = false;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    popped = true;
  }
}
