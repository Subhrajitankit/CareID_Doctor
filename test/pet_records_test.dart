import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/features/medical_records/pet_records_screen.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/data/mock_data.dart';
import 'package:careid_doctor/data/models/clinical_models.dart';

void main() {
  Widget createTestWidget({Patient? patientArg, NavigatorObserver? observer}) {
    return MaterialApp(
      navigatorObservers: observer != null ? [observer] : [],
      routes: {
        AppRoutes.petRecords: (context) =>
            PetRecordsScreen(patientArg: patientArg),
        AppRoutes.medicalRecords: (context) => Scaffold(
          appBar: AppBar(title: const Text('Medical Records Page')),
          body: const Text('Medical Records Body'),
        ),
        AppRoutes.dentalRecords: (context) => Scaffold(
          appBar: AppBar(title: const Text('Dental Records Page')),
          body: const Text('Dental Records Body'),
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
      home: PetRecordsScreen(patientArg: patientArg),
    );
  }

  group('PetRecordsScreen - Figma Node 10:7985 Visual Verification', () {
    testWidgets('renders all core UI elements matching Figma node 10:7985', (
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

      // 1. TopAppBar (Figma Node 10:8013)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byType(Image), findsWidgets); // CareID logo & doctor avatar

      // 2. Heading: "Pet Records" (Figma Node 10:8023)
      expect(find.text('Pet Records'), findsOneWidget);

      // 3. Search Bar with Filter Icon (Figma Node 10:8025)
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.text('Search records, labs, doctors...'), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

      // 4. Category Chips (Figma Node 10:8032)
      expect(find.text('All Records'), findsOneWidget);
      expect(find.text('Medical'), findsOneWidget);
      expect(find.text('Pets'), findsOneWidget);
      expect(find.text('Dental'), findsOneWidget);

      // 5. Timeline Section (Figma Node 10:8045)
      expect(find.text('Annual Vaccination - Buddy'), findsOneWidget);
      expect(find.text('Vaccination Record'), findsOneWidget);
      expect(find.text('Flea & Tick Prevention'), findsOneWidget);
      expect(find.text('Routine Preventive'), findsOneWidget);
      expect(find.text('Dental Scaling (Canine)'), findsOneWidget);
      expect(find.text('Specialized Treatment'), findsOneWidget);

      // 6. Dates matching Figma Node 10:7985
      expect(find.text('Jan 10, 2024'), findsNWidgets(2));
      expect(find.text('Aug 22, 2023'), findsOneWidget);

      // 7. Verified Badges
      expect(find.text('Verified'), findsNWidgets(3));

      // 8. Facilities & Doctors
      expect(find.text('Paws & Claws Vet'), findsNWidgets(2));
      expect(find.text('Dr. Kevin Miller'), findsNWidgets(2));
      expect(find.text('Pet Health Center'), findsOneWidget);
      expect(find.text('Dr. Susan Gray'), findsOneWidget);

      // 9. Floating Bottom Navigation (Figma Node 10:7986)
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Schedule'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('Tapping a pet card navigates to medical record details', (
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

      await tester.tap(find.text('Annual Vaccination - Buddy'));
      await tester.pumpAndSettle();

      expect(find.text('Record Details Page'), findsOneWidget);
    });

    testWidgets('Search query filters pet records dynamically', (
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

      await tester.enterText(find.byType(TextField), 'Flea');
      await tester.pumpAndSettle();

      expect(find.text('Flea & Tick Prevention'), findsOneWidget);
      expect(find.text('Annual Vaccination - Buddy'), findsNothing);
      expect(find.text('Dental Scaling (Canine)'), findsNothing);
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
