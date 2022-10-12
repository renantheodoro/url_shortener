import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/data/models/url_model.dart';
import 'package:url_shortener/presentation/components/url_list.dart';
import 'package:url_shortener/presentation/screens/complete_list/complete_list_view.dart';
import 'package:url_shortener/presentation/screens/complete_list/complete_list_view_model.dart';
import 'package:provider/provider.dart';

import '../../../fixtures/fixture_reader.dart';

class MockCompleteListViewModel extends Mock implements CompleteListViewModel {}

void main() {
  late CompleteListViewModel mockCompleteViewModel;
  late List<UrlModel> mockUrlList;

  setUp(() {
    mockCompleteViewModel = MockCompleteListViewModel();
    mockUrlList = UrlModelsAdapter.fromJson(fixture('url_list.json'));
  });

  Future<void> _loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<CompleteListViewModel>(
          create: (context) => mockCompleteViewModel..getShortenedUrls(),
          child: const CompleteListView(),
        ),
      ),
    );
  }

  testWidgets('should show loading when page is busy',
      (WidgetTester tester) async {
    when(() => mockCompleteViewModel.busy).thenAnswer((_) => true);
    when(() => mockCompleteViewModel.fullUrlList).thenAnswer((_) => null);
    when(() => mockCompleteViewModel.getShortenedUrls())
        .thenAnswer((_) async => Future<void>);

    await _loadPage(tester);

    // Loading
    final Finder loadingFinder = find.byType(CircularProgressIndicator);
    expect(loadingFinder, findsOneWidget);
  });

  testWidgets('should call getShortenedUrls when page is loaded',
      (WidgetTester tester) async {
    when(() => mockCompleteViewModel.busy).thenAnswer((_) => true);
    when(() => mockCompleteViewModel.fullUrlList).thenAnswer((_) => null);
    when(() => mockCompleteViewModel.getShortenedUrls())
        .thenAnswer((_) async => Future<void>);

    await _loadPage(tester);

    verify(
      () => mockCompleteViewModel.getShortenedUrls(),
    ).called(1);
  });

  testWidgets(
      'should load page with correct base widgets when model is not busy',
      (WidgetTester tester) async {
    when(() => mockCompleteViewModel.busy).thenAnswer((_) => false);
    when(() => mockCompleteViewModel.fullUrlList).thenAnswer((_) => null);
    when(() => mockCompleteViewModel.getShortenedUrls())
        .thenAnswer((_) async => Future<void>);

    await _loadPage(tester);

    // Loading
    final Finder loadingFinder = find.byType(CircularProgressIndicator);
    expect(loadingFinder, findsNothing);

    // AppBar
    final Finder appBarFinder = find.byType(AppBar);
    expect(appBarFinder, findsOneWidget);

    // Title
    final Finder titleFinder = find.text('Recently shortened URLs');
    expect(titleFinder, findsOneWidget);
  });

  testWidgets(
      'should load page with shortened list when there is data in cache',
      (WidgetTester tester) async {
    when(() => mockCompleteViewModel.busy).thenAnswer((_) => false);
    when(() => mockCompleteViewModel.fullUrlList).thenAnswer((_) => mockUrlList);
    when(() => mockCompleteViewModel.getShortenedUrls())
        .thenAnswer((_) async => Future<void>);

    await _loadPage(tester);

    // Url list
    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, findsOneWidget);
  });

  testWidgets(
      'should load page with hide shortened list when there is data in cache',
      (WidgetTester tester) async {
    when(() => mockCompleteViewModel.busy).thenAnswer((_) => false);
    when(() => mockCompleteViewModel.fullUrlList).thenAnswer((_) => []);
    when(() => mockCompleteViewModel.getShortenedUrls())
        .thenAnswer((_) async => Future<void>);

    await _loadPage(tester);

    // Url list
    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, findsNothing);
  });

  testWidgets('should show correct length of list positions on shortened list',
      (WidgetTester tester) async {
    when(() => mockCompleteViewModel.busy).thenAnswer((_) => false);
    when(() => mockCompleteViewModel.fullUrlList).thenAnswer((_) => mockUrlList);
    when(() => mockCompleteViewModel.getShortenedUrls())
        .thenAnswer((_) async => Future<void>);

    await _loadPage(tester);

    final Finder urlListItemsFinder =
        find.descendant(of: find.byType(UrlList), matching: find.byType(Text));

    expect(urlListItemsFinder, findsNWidgets(mockUrlList.length));
  });

  testWidgets('should not show shortened list when method fails',
      (WidgetTester tester) async {
    when(() => mockCompleteViewModel.busy).thenAnswer((_) => false);
    when(() => mockCompleteViewModel.fullUrlList).thenAnswer((_) => null);
    when(() => mockCompleteViewModel.getShortenedUrls())
        .thenAnswer((_) async => Future<void>);

    await _loadPage(tester);
    
    // Url list
    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, findsNothing);
  });
}
