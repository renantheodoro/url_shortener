import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/presentation/components/text_input.dart';

void main() {
  testWidgets('Text input should present a label and interact with the value of its controller',
      (WidgetTester tester) async {
        TextEditingController controller = TextEditingController();

    await tester.pumpWidget(MaterialApp(
      title: 'Text test',
      home: Scaffold(
        appBar: AppBar(),
        body: Center(child: InputText(
          controller: controller,
          label: 'Input label',
        )),
      ),
    ));

    final Finder byTextFinder = find.text('Input label');
    expect(byTextFinder, findsOneWidget);

    final Finder byInputFinder = find.byType(TextFormField);

    await tester.enterText(byInputFinder, 'Input text');

    expect(controller.text, 'Input text');

    await tester.enterText(byInputFinder, '');

    expect(controller.text, '');
  });
}
