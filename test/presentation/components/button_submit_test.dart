import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/presentation/components/button_submit.dart';

class MockCallback extends Mock {
  int called = 0;
  
  Function? call() {
    called+=1;
    return null;
  }
}

void main() {
  late MockCallback mockCallback;

  setUp(() {
    mockCallback = MockCallback();
  });

  testWidgets('Button submit should calls callback function when tapping it',
      (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(
      title: 'Text test',
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
            child: ButtonSubmit(
          callback: mockCallback,
        )),
      ),
    ));

    final Finder byButtonFinder = find.byType(ButtonSubmit);
    expect(byButtonFinder, findsOneWidget);

    await tester.tap(byButtonFinder);
    await tester.pump(const Duration(milliseconds: 100));

    expect(mockCallback.called, equals(1));
  });
}
