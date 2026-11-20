import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:proshnolab/main.dart';

Future<void> scrollToGenerateButton(WidgetTester tester) async {
  final builder = find.ancestor(
    of: find.text('Smart Prompt Builder'),
    matching: find.byType(ListView),
  );
  final scrollable = find.descendant(
    of: builder,
    matching: find.byType(Scrollable),
  ).first;
  await tester.scrollUntilVisible(
    find.text('Generate my prompt'),
    120,
    scrollable: scrollable,
  );
}

void main() {
  testWidgets('Home screen offers the prompt builder', (tester) async {
    await tester.pumpWidget(const ProshnoLabApp());
    expect(find.text('Ask Better'), findsOneWidget);
    expect(find.text('Build a prompt'), findsOneWidget);
    await tester.tap(find.text('Build a prompt'));
    await tester.pumpAndSettle();
    await scrollToGenerateButton(tester);
    expect(find.text('Generate my prompt'), findsOneWidget);
    expect(find.text('Reply language (optional)'), findsOneWidget);
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
    await scrollToGenerateButton(tester);
    expect(find.text('Generate my prompt'), findsOneWidget);
  });
}
