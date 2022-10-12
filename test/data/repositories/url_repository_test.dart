import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/error/exception.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/platform/network_info.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/data/datasource/local/url_local_data_source.dart';
import 'package:url_shortener/data/datasource/remote/url_remote_data_source.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/data/models/url_model.dart';
import 'package:url_shortener/data/repositories/url_respository.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';

import '../../fixtures/fixture_reader.dart';

class MockUrlLocalDataSource extends Mock implements UrlLocalDataSource {}

class MockUrlRemoteDateSource extends Mock implements UrlRemoteDataSource {}

class MockNetWorkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockUrlLocalDataSource mockUrlLocalDataSource;
  late MockUrlRemoteDateSource mockUrlRemoteDateSource;
  late MockNetWorkInfo mockNetWorkInfo;
  late UrlRepository urlRepository;

  late String originalUrl;

  late UrlModel urlModel;

  setUp(() {
    mockUrlLocalDataSource = MockUrlLocalDataSource();
    mockUrlRemoteDateSource = MockUrlRemoteDateSource();
    mockNetWorkInfo = MockNetWorkInfo();

    urlRepository = UrlRepository(
        localDataSource: mockUrlLocalDataSource,
        remoteDataSource: mockUrlRemoteDateSource,
        networkInfo: mockNetWorkInfo);

    originalUrl = '<original url>';

    urlModel =  UrlModelAdapter.fromJson(fixture('url.json'));
  });

  test('should verify if device has connection with the internet', () async {
    when(
      () => mockNetWorkInfo.isConnected,
    ).thenAnswer((_) => Future.value(true));

    when(() => mockUrlRemoteDateSource.shorten(originalUrl))
        .thenAnswer((_) async => await Future.value(urlModel));

    when(() => mockUrlLocalDataSource.cacheUrl(urlModel))
        .thenAnswer((_) => Future.value());

    urlRepository.shorten(originalUrl);

    verify(() => mockNetWorkInfo.isConnected).called(1);
  });

  group('shorten method tests', () {
    group('if the device is connected to the internet', () {
      setUp(() {
        when(() => mockNetWorkInfo.isConnected)
            .thenAnswer((_) => Future.value(true));

        when(() => mockUrlRemoteDateSource.shorten(originalUrl))
            .thenAnswer((_) async => await Future.value(urlModel));

        when(() => mockUrlLocalDataSource.cacheUrl(urlModel))
            .thenAnswer((_) => Future.value());
      });

      test('should return shortened url', () async {
        final ServiceResponse<Failure, UrlEntity> result =
            await urlRepository.shorten(originalUrl);

        expect(
            result, allOf([equals(isNotNull), equals(isA<ServiceResponse>())]));
        expect(result.failure, allOf([equals(isNull)]));
        expect(result.response,
            allOf([equals(isNotNull), equals(isA<UrlEntity>())]));
        expect(result.response?.alias,
            allOf([equals(isA<String>()), equals(isNot(''))]));
        expect(
            result.response?.urlLinks?.self,
            allOf([
              equals(isA<String>()),
              equals(isNot('')),
              equals(originalUrl)
            ]));
        expect(result.response?.urlLinks?.short,
            allOf([equals(isA<String>()), equals(isNot(''))]));
      });

      test('should cache the shortened url', () async {
        await urlRepository.shorten(originalUrl);

        verify(() => mockUrlRemoteDateSource.shorten(originalUrl)).called(1);
        verify(() => mockUrlLocalDataSource.cacheUrl(urlModel)).called(1);
      });

      test('should return a server failure when the call to remote data fails',
          () async {
        when(() => mockUrlRemoteDateSource.shorten(originalUrl))
            .thenThrow(ServerException());

        final ServiceResponse<Failure, dynamic> result =
            await urlRepository.shorten(originalUrl);

        verify(() => mockUrlRemoteDateSource.shorten(originalUrl)).called(1);
        verifyZeroInteractions(mockUrlLocalDataSource);

        expect(result.failure,
            allOf([equals(isNotNull), equals(isA<ServerFailure>())]));
      });
    });

    group('if the device is not connected to the internet', () {
      setUp(() {
        when(() => mockNetWorkInfo.isConnected)
            .thenAnswer((_) => Future.value(false));
      });

      test('should return a connection failure when calls shorten method',
          () async {
        final ServiceResponse<Failure, dynamic> result =
            await urlRepository.shorten(originalUrl);

        verify(() => mockNetWorkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockUrlRemoteDateSource);
        verifyNoMoreInteractions(mockUrlLocalDataSource);

        expect(result.failure,
            allOf([equals(isNotNull), equals(isA<ConnectionFailure>())]));
      });
    });
  });

  group('getRecentlyShortenedUrls tests', () {
    late List<UrlModel> urlsListModels;

    setUp(() {
      urlsListModels = UrlModelsAdapter.fromJson(fixture('url_list.json'));
    });

    test('should retun a list of cached url data', () async {
      when(() => mockUrlLocalDataSource.getCachedList())
          .thenAnswer((_) async => await Future.value(urlsListModels));

      final ServiceResponse<Failure, List<UrlEntity>> result =
          await urlRepository.getCachedList();

      expect(result.failure, equals(isNull));
      expect(
          result.response, allOf([equals(isNotNull), equals(urlsListModels)]));
    });

    test('should return an empty list when cache is empty', () async {
      when(() => mockUrlLocalDataSource.getCachedList())
          .thenAnswer((_) async => await Future.value(<UrlModel>[]));

      final ServiceResponse<Failure, List<UrlEntity>> result =
          await urlRepository.getCachedList();

      expect(result.failure, equals(isNull));
      expect(
          result.response,
          allOf([
            equals(isNotNull),
            equals(isA<List<UrlModel>>()),
            equals(isEmpty)
          ]));
    });
  });
}
