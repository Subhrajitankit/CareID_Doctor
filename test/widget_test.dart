import 'package:flutter_test/flutter_test.dart';
import 'package:careid_doctor/main.dart';

void main() {
  testWidgets('CareIdDoctorApp launches and displays Splash Screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CareIdDoctorApp());
    await tester.pumpAndSettle();

    expect(find.text('Doctor App'), findsOneWidget);
    expect(find.text('Swipe to start'), findsOneWidget);

    // Tap the swipe to start button
    await tester.tap(find.text('Swipe to start'));
    await tester.pumpAndSettle();

    // Verify navigation to StartScreen
    expect(find.text('Verified Doctor Access'), findsOneWidget);
  });
}
