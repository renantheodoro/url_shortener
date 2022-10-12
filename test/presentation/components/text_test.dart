import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/presentation/components/text.dart';

void main() {
  testWidgets('Text bold widget should present a text',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      title: 'Text test',
      home: Scaffold(
        appBar: AppBar(),
        body: const Center(child: TextBold(text: 'Example')),
      ),
    ));

    final Finder textFinder = find.text('Example');
    expect(textFinder, findsOneWidget);
  });
}
