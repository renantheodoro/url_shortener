import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/core/usecases/usecase.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/data/models/url_model.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/domain/usecases/get_recently_urls_use_case.dart';
import 'package:url_shortener/domain/usecases/shorten_url_use_case.dart';
import 'package:url_shortener/presentation/screens/home/home_view_model.dart';

import '../../../fixtures/fixture_reader.dart';


class MockShortenUrlUseCase extends Mock implements ShortenUrlUseCase {}

class MockGetRecentlyShortenedUrlsUseCase extends Mock
    implements GetRecentlyShortenedUrlsUseCase {}

void main() {
  late ShortenUrlUseCase mockShortenUrlUseCase;
  late GetRecentlyShortenedUrlsUseCase mockGetRecentlyShortenedUrlsUseCase;
  late HomeViewModel homeViewModel;

  late String originalUrl;

  late UrlModel mockUrlModel;
  late List<UrlModel> mockUrlModelList;

  setUp(() {
    mockShortenUrlUseCase = MockShortenUrlUseCase();
    mockGetRecentlyShortenedUrlsUseCase = MockGetRecentlyShortenedUrlsUseCase();

    homeViewModel = HomeViewModel(
        shortenUrlUseCase: mockShortenUrlUseCase,
        getRecentlyShortenedUrlsUseCase: mockGetRecentlyShortenedUrlsUseCase);

    originalUrl = '<url alias>';

    mockUrlModel = UrlModelAdapter.fromJson(fixture('url.json'));
    mockUrlModelList = UrlModelsAdapter.fromJson(fixture('url_list.json'));
  });

  testWidgets('should verify initial state', (tester) async {
    expect(homeViewModel.busy, equals(false));
    expect(homeViewModel.currentUrl, equals(null));
    expect(homeViewModel.currentUrlList, equals(isEmpty));
  });

  testWidgets('should set true to setBusy', (tester) async {
    homeViewModel.setBusy(true);
    expect(homeViewModel.busy, equals(true));
  });

  testWidgets('should set false to setBusy', (tester) async {
    homeViewModel.setBusy(false);
    expect(homeViewModel.busy, equals(false));
  });

  testWidgets('should call shortenUrl and receive the shortened url',
      (tester) async {
    when(() => mockShortenUrlUseCase(UrlParams(originalUrl)))
        .thenAnswer((_) async => ServiceResponse.build(response: mockUrlModel));

    when(() => mockGetRecentlyShortenedUrlsUseCase(NoParams()))
        .thenAnswer((_) async => ServiceResponse.build(response: mockUrlModelList));


    await homeViewModel.shortenUrl(originalUrl);

    expect(homeViewModel.currentUrl!.alias, originalUrl);
    expect(homeViewModel.currentUrlList, mockUrlModelList);

    verify(() => mockShortenUrlUseCase(UrlParams(originalUrl))).called(1);
    verify(() => mockGetRecentlyShortenedUrlsUseCase(NoParams())).called(1);
  });

  testWidgets(
      'should call getRecentlyShortenedUrls and receive the list of cached urls',
      (tester) async {
    when(() => mockGetRecentlyShortenedUrlsUseCase(NoParams()))
        .thenAnswer((_) async => ServiceResponse.build(response: mockUrlModelList));

    await homeViewModel.getRecentlyShortenedUrls();

    expect(homeViewModel.currentUrlList, equals(isNotNull));
    expect(homeViewModel.currentUrlList, equals(isA<List<UrlEntity>>()));
    expect(homeViewModel.currentUrlList, equals(isNotEmpty));

    verify(() => mockGetRecentlyShortenedUrlsUseCase(NoParams())).called(1);
  });
}
