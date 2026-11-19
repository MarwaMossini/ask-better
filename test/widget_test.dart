import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:proshnolab/main.dart';

void main() {
  testWidgets('Home screen offers the prompt builder', (tester) async {
    await tester.pumpWidget(const ProshnoLabApp());
    expect(find.text('ProshnoLab'), findsOneWidget);
    expect(find.text('Build a prompt'), findsOneWidget);
    await tester.tap(find.text('Build a prompt'));
    await tester.pumpAndSettle();
    expect(find.text('Generate my prompt'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));
  });
}
