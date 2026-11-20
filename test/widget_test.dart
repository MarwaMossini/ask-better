import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:proshnolab/main.dart';

void main() {
  testWidgets('Home screen offers the prompt builder', (tester) async {
    await tester.pumpWidget(const ProshnoLabApp());
    expect(find.text('Ask Better'), findsOneWidget);
    expect(find.text('Build a prompt'), findsOneWidget);
    await tester.tap(find.text('Build a prompt'));
    await tester.pumpAndSettle();
    expect(find.text('Generate my prompt'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));
  });

  testWidgets('Help opens from Home and leads to the builder', (tester) async {
    await tester.pumpWidget(const ProshnoLabApp());
    await tester.tap(find.text('How to use & FAQ'));
    await tester.pumpAndSettle();
    expect(find.text('How to use Ask Better'), findsOneWidget);
    expect(find.text('Frequently asked questions'), findsOneWidget);
    await tester.tap(find.text('What is a prompt?'));
    await tester.pumpAndSettle();
    expect(find.textContaining('A prompt is the question'), findsOneWidget);
    await tester.tap(find.text('Open the builder'));
    await tester.pumpAndSettle();
    expect(find.text('Generate my prompt'), findsOneWidget);
  });
}
