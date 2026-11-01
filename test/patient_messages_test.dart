import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/core/routes/app_routes.dart';
import 'package:careid_doctor/features/notifications_messages/patient_messages_screen.dart';

void main() {
  testWidgets('PatientMessagesScreen renders all Figma node 10:7210 components',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 884));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.dashboard: (context) =>
              const Scaffold(body: Text('Doctor Dashboard')),
          AppRoutes.doctorProfile: (context) =>
              const Scaffold(body: Text('Doctor Profile')),
        },
        home: const PatientMessagesScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. TopAppBar
    expect(find.byKey(const Key('patient_messages_back_button')), findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    // 2. Title & Subtitle Section
    expect(find.text('Messages'), findsOneWidget);
    expect(
      find.text('Your conversations with healthcare\nproviders.'),
      findsOneWidget,
    );
    expect(find.text('New'), findsOneWidget);
    expect(find.text('2'), findsWidgets);

    // 3. Search Bar
    expect(find.text('Search provider, clinic, or note...'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.byIcon(Icons.filter_list_rounded), findsOneWidget);

    // 4. Filter Chips / Tabs
    expect(find.text('All Messages'), findsOneWidget);
    expect(find.text('Unread'), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);
    expect(find.text('Empty View'), findsOneWidget);

    // 5. Conversation Cards
    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('Cardiology Specialist • Mount Sinai Hospital'), findsOneWidget);
    expect(find.text('Your pre-consultation health…'), findsOneWidget);
    expect(find.text('10:42 AM'), findsOneWidget);

    expect(find.text('Dr. Michael Chen'), findsOneWidget);
    expect(find.text('DDS, Oral Radiologist • Apex Dental Care Center'), findsOneWidget);
    expect(find.text('Regarding your dental OPG scan:…'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);

    expect(find.text('Dr. Elena Rostova'), findsOneWidget);
    expect(find.text('Ophthalmology Specialist • Horizon Vision Clinic'), findsOneWidget);
    expect(find.text('Your vision prescription update has…'), findsOneWidget);
    expect(find.text('Oct 18'), findsOneWidget);

    expect(find.text('Dr. Julian Vance'), findsOneWidget);
    expect(find.text('Internal Medicine • Metro Hospital'), findsOneWidget);
    expect(find.text('Follow-up lab orders are scheduled'), findsOneWidget);
    expect(find.text('Oct 12'), findsOneWidget);

    // 6. Educational Trust Guarantee Footer
    expect(
      find.text('HIPAA • Verified Licensed Clinicians Only'),
      findsOneWidget,
    );
  });

  testWidgets('Filter tabs switch active selection and filter items',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 884));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: PatientMessagesScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Switch to 'Unread' tab
    await tester.tap(find.text('Unread'));
    await tester.pumpAndSettle();

    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('Dr. Michael Chen'), findsOneWidget);
    expect(find.text('Dr. Elena Rostova'), findsNothing);
    expect(find.text('Dr. Julian Vance'), findsNothing);

    // 2. Switch to 'Empty View' tab
    await tester.ensureVisible(find.text('Empty View'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empty View'));
    await tester.pumpAndSettle();

    expect(find.text('No messages found'), findsOneWidget);
    expect(find.text('Dr. Sarah Jenkins'), findsNothing);

    // 3. Switch back to 'All Messages' tab
    await tester.ensureVisible(find.text('All Messages'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All Messages'));
    await tester.pumpAndSettle();

    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('Dr. Julian Vance'), findsOneWidget);
  });

  testWidgets('Search input filters conversation cards dynamically',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 884));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: PatientMessagesScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Enter query 'cardiology'
    await tester.enterText(
      find.byType(TextField),
      'cardiology',
    );
    await tester.pumpAndSettle();

    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('Dr. Michael Chen'), findsNothing);
    expect(find.text('Dr. Julian Vance'), findsNothing);

    // Clear query
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    expect(find.text('Dr. Sarah Jenkins'), findsOneWidget);
    expect(find.text('Dr. Michael Chen'), findsOneWidget);
  });

  testWidgets('Tapping conversation card marks as read and shows SnackBar',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 884));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: PatientMessagesScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap on Dr. Sarah Jenkins conversation
    await tester.tap(find.text('Dr. Sarah Jenkins'));
    await tester.pumpAndSettle();

    // Verify SnackBar
    expect(
      find.text('Opening secure clinical thread with Dr. Sarah Jenkins'),
      findsOneWidget,
    );

    // Unread count in subtitle decreases to 1
    expect(find.text('1'), findsWidgets);
    expect(find.text('New'), findsOneWidget);
  });
}
