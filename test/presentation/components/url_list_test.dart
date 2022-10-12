import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/presentation/components/url_list.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  testWidgets('should present the list when has a list value to show',
      (WidgetTester tester) async {
    final List<UrlEntity> urllist =
        UrlModelsAdapter.fromJson(fixture('url_list.json'));

    await tester.pumpWidget(MaterialApp(
      title: 'Text test',
      home: Scaffold(
        appBar: AppBar(),
        body: Flex(direction: Axis.vertical, children: [
          UrlList(
            urlList: urllist,
          )
        ]),
      ),
    ));

    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, equals(findsOneWidget));

    final Finder textFinder = find.byType(Text);
    expect(textFinder, findsNWidgets(urllist.length));

    final Finder listItemFinder = find.text(urllist[0].urlLinks!.short!);
    expect(listItemFinder, findsNWidgets(urllist.length));
  });

  testWidgets('should not present the list when there is no list value to show',
      (WidgetTester tester) async {
    final List<UrlEntity> urllist = [];

    await tester.pumpWidget(MaterialApp(
      title: 'Text test',
      home: Scaffold(
        appBar: AppBar(),
        body: Flex(direction: Axis.vertical, children: [
          UrlList(
            urlList: urllist,
          )
        ]),
      ),
    ));

    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, equals(findsOneWidget));

    final Finder textFinder = find.byType(Text);
    expect(textFinder, findsNothing);
  });
}
