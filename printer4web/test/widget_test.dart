// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:printer4web/main.dart';
import 'package:printer4web/printer_settings.dart';

void main() {
  testWidgets('opens settings from the app bar', (WidgetTester tester) async {
    currentPrinterSettings = PrinterSettings.defaults();
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byTooltip('Settings'), findsOneWidget);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Printer host'), findsOneWidget);
  });
}
