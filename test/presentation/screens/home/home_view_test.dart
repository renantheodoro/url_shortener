import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/consts/error_input_text.const.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/data/models/url_model.dart';
import 'package:url_shortener/presentation/components/button_submit.dart';
import 'package:url_shortener/presentation/components/text_input.dart';
import 'package:url_shortener/presentation/components/url_list.dart';
import 'package:url_shortener/presentation/screens/complete_list/complete_list_view.dart';
import 'package:url_shortener/presentation/screens/home/home_view.dart';
import 'package:url_shortener/presentation/screens/home/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_shortener/routes.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockHomeViewModel extends Mock implements HomeViewModel {}

class FakeRoute extends Fake implements Route {}

void main() {
  late HomeViewModel mockHomeViewModel;

  late NavigatorObserver mockNavigatorObserver;

  late TextEditingController inputController;

  late String originalUrl;

  late UrlModel mockUrlModel;

  late List<UrlModel> mockUrlList;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
    registerFallbackValue(FakeRoute());

    mockHomeViewModel = MockHomeViewModel();

    inputController = TextEditingController();

    originalUrl = '<original url>';

    mockUrlModel = UrlModelAdapter.fromJson(fixture('url.json'));

    mockUrlList = UrlModelsAdapter.fromJson(fixture('url_list.json'));
  });

  Future<void> _loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: AppRouter.generateRoute,
        navigatorObservers: [mockNavigatorObserver],
        home: ChangeNotifierProvider<HomeViewModel>(
          create: (context) => mockHomeViewModel..getRecentlyShortenedUrls(),
          child: const HomeView(),
        ),
      ),
    );
  }

  testWidgets('should show loading when page is busy',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => true);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => null);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => mockUrlList);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build());

    await _loadPage(tester);

    // Loading
    final Finder loadingFinder = find.byType(CircularProgressIndicator);
    expect(loadingFinder, findsOneWidget);
  });

  testWidgets('should call getRecentlyShortenedUrls when page is loaded',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => null);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => []);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build());

    await _loadPage(tester);

    verify(
      () => mockHomeViewModel.getRecentlyShortenedUrls(),
    ).called(1);
  });

  testWidgets(
      'should load page with correct base widgets when model is not busy',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => null);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => []);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build(response: []));

    await _loadPage(tester);

    // Loading
    final Finder loadingFinder = find.byType(CircularProgressIndicator);
    expect(loadingFinder, findsNothing);

    // Home Body
    final Finder homeViewBodyFinder = find.byType(HomeViewBody);
    expect(homeViewBodyFinder, findsOneWidget);

    // InputText
    final Finder inputTextFinder = find.byType(InputText);
    expect(inputTextFinder, findsOneWidget);

    // TextFormField
    final TextFormField textFormField =
        tester.widget<TextFormField>(find.byType(TextFormField));
    expect(textFormField.controller!.text, '');
    expect(textFormField.controller!.text, inputController.text);

    // ButtonSubmit
    final Finder buttonSubmitFinder = find.byType(ButtonSubmit);
    expect(buttonSubmitFinder, findsOneWidget);

    // Navigator button
    final Finder navigatorButtonFinder = find.byKey(const ValueKey('navigatorButton'));
    expect(navigatorButtonFinder, findsOneWidget);
  });

  testWidgets(
      'should load page with recently shortened list when there is data in cache',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => null);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => mockUrlList);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build(response: mockUrlList));

    await _loadPage(tester);

    // Result texts
    final Finder resultTextColumnFinder =
        find.byKey(const ValueKey('resultColumn'));
    expect(resultTextColumnFinder, findsNothing);

    // List title
    final Finder listTitleFinder = find.text('Last shortened URLs');
    expect(listTitleFinder, findsOneWidget);

    // Url list
    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, findsOneWidget);
  });

  testWidgets(
      'should load page with hide shortened list when there is data in cache',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => null);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => []);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build(response: []));

    await _loadPage(tester);

    // Result texts
    final Finder resultTextColumnFinder =
        find.byKey(const ValueKey('resultColumn'));
    expect(resultTextColumnFinder, findsNothing);

    // List title
    final Finder listTitleFinder = find.text('Last shortened URLs');
    expect(listTitleFinder, findsNothing);

    // Url list
    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, findsNothing);
  });

  testWidgets('should show resultColumn when there is data in currentUrl',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => mockUrlModel);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => []);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build(response: []));

    await _loadPage(tester);

    // Result texts
    final Finder resultTextColumnFinder =
        find.byKey(const ValueKey('resultColumn'));
    expect(resultTextColumnFinder, findsOneWidget);
  });

  testWidgets('should show correct length of list positions on shortened list',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => null);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => mockUrlList);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build(response: []));

    await _loadPage(tester);

    final Finder urlListItemsFinder =
        find.descendant(of: find.byType(UrlList), matching: find.byType(Text));

    expect(urlListItemsFinder, findsNWidgets(mockUrlList.length));
  });

  testWidgets(
      'should show result the last shortened urls list when tap the submit button',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => mockUrlModel);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => mockUrlList);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build(response: []));
    when(() => mockHomeViewModel.shortenUrl(originalUrl))
        .thenAnswer((_) async => ServiceResponse.build());

    await _loadPage(tester);

    await tester.pump();

    final Finder inputTextFinder = find.byType(InputText);
    await tester.enterText(inputTextFinder, originalUrl);

    final Finder buttonSubmitFinder = find.byType(ButtonSubmit);

    await tester.tap(buttonSubmitFinder);

    await tester.pump();

    // Url list
    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, findsOneWidget);

    verify(() => mockHomeViewModel.shortenUrl(originalUrl)).called(1);
  });

  testWidgets('should reset input when tap the submit button',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => mockUrlModel);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => []);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build(response: []));
    when(() => mockHomeViewModel.shortenUrl(originalUrl))
        .thenAnswer((_) async => ServiceResponse.build());

    await _loadPage(tester);

    await tester.pump();

    final Finder inputTextFinder = find.byType(InputText);
    await tester.enterText(inputTextFinder, originalUrl);

    final Finder buttonSubmitFinder = find.byType(ButtonSubmit);

    await tester.tap(buttonSubmitFinder);

    await tester.pump();

    // Reset TextFormField
    final TextFormField textFormField =
        tester.widget<TextFormField>(find.byType(TextFormField));
    expect(textFormField.controller!.text, '');
    expect(textFormField.controller!.text, inputController.text);
  });

  testWidgets('should show cached list when shorten url method fails',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => mockUrlModel);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => mockUrlList);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build(response: []));
    when(() => mockHomeViewModel.shortenUrl(originalUrl)).thenAnswer(
        (_) async => ServiceResponse.build(failure: CacheFailure()));

    await _loadPage(tester);

    final Finder inputTextFinder = find.byType(InputText);
    await tester.enterText(inputTextFinder, originalUrl);

    final Finder buttonSubmitFinder = find.byType(ButtonSubmit);

    await tester.tap(buttonSubmitFinder);

    await tester.pump();

    // Url list
    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, findsOneWidget);

    verify(() => mockHomeViewModel.shortenUrl(originalUrl)).called(1);
    verify(() => mockHomeViewModel.getRecentlyShortenedUrls()).called(1);
  });

  testWidgets(
      'should hide last shortened urls list if get recently shortened urls method fails',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => null);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => []);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls()).thenAnswer(
        (_) async => ServiceResponse.build(failure: ServerFailure()));

    await _loadPage(tester);

    // Url list
    final Finder urlListFinder = find.byType(UrlList);
    expect(urlListFinder, findsNothing);

    verify(() => mockHomeViewModel.getRecentlyShortenedUrls()).called(1);
  });

  testWidgets('should not call shortener method with input empty',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => null);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => []);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls()).thenAnswer(
        (_) async => ServiceResponse.build(failure: ServerFailure()));

    await _loadPage(tester);

    await tester.pump();

    final Finder inputTextFinder = find.byType(InputText);
    await tester.enterText(inputTextFinder, '');

    final Finder buttonSubmitFinder = find.byType(ButtonSubmit);

    await tester.tap(buttonSubmitFinder);

    await tester.pump();

    // Error text
    final Finder errorTextFinder = find.text(errorInputText);
    expect(errorTextFinder, findsOneWidget);

    final TextFormField textFormField =
        tester.widget<TextFormField>(find.byType(TextFormField));
    expect(textFormField.controller!.text, '');
    expect(textFormField.controller!.text, inputController.text);

    verifyNever(
      () => mockHomeViewModel.shortenUrl(''),
    );
  });

  testWidgets(
      'show navigate to complete list view when navigator button is tapped',
      (WidgetTester tester) async {
    when(() => mockHomeViewModel.busy).thenAnswer((_) => false);
    when(() => mockHomeViewModel.currentUrl).thenAnswer((_) => null);
    when(() => mockHomeViewModel.currentUrlList).thenAnswer((_) => []);
    when(() => mockHomeViewModel.getRecentlyShortenedUrls())
        .thenAnswer((_) async => ServiceResponse.build());

    await _loadPage(tester);

    // Navigator button
    final Finder navigatorButtonFinder = find.byKey(const ValueKey('navigatorButton'));
    expect(navigatorButtonFinder, findsOneWidget);

    await tester.tap(navigatorButtonFinder);

    await tester.pump();

    verify(() => mockNavigatorObserver.didPush(any(), any()));

    await tester.pump();

    expect(find.byType(CompleteListView), findsOneWidget);
  });
}
