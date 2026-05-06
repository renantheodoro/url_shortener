import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/core/consts/cached_url_key.const.dart';
import 'package:url_shortener/data/datasource/local/url_local_data_source.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/data/models/url_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  late UrlLocalDataSource localDataSource;

  setUp(() async {
    localDataSource = UrlLocalDataSource();
  });

  group('getUrlsListFromCache tests', () {
    test('should return a url list from cache', () async {
      // Mocking SharedPreferences
      Map<String, Object> values = <String, Object>{
        cachedUrlKey:
            fixture('url_list.json') // Ensure the JSON is valid for the test
      };
      SharedPreferences.setMockInitialValues(values);

      // Calling the method that fetches the list from the cache
      List<UrlModel> result = await localDataSource.getCachedList();

      // Verifying the result
      expect(
          result,
          allOf([
            isNotEmpty,
            isA<List<UrlModel>>(),
          ]));

      // Verifying specific fields in the first URL model in the list
      expect(result[0].originalUrl, isA<String>());
      expect(result[0].shortCode, isA<String>());
      expect(result[0].shortUrl, isA<String>());
    });

    test('should return an empty list when there is no cache value', () async {
      // Empty SharedPreferences
      Map<String, Object> values = <String, Object>{};
      SharedPreferences.setMockInitialValues(values);

      // Calling the method that fetches the list from the cache
      List<UrlModel> result = await localDataSource.getCachedList();

      // Verifying the result is an empty list
      expect(result, isA<List<UrlModel>>());
      expect(result, isEmpty);
    });
  });

  test('should set url into cache even if cache is empty', () async {
    // Empty SharedPreferences
    Map<String, Object> values = <String, Object>{};
    SharedPreferences.setMockInitialValues(values);

    // Create a UrlModel to cache
    UrlModel urlToCache = const UrlModel(
      originalUrl: 'https://example.com',
      shortCode: 'abc123',
      shortUrl: 'https://short.url/abc123',
    );

    // Call cacheUrl to save it
    await localDataSource.cacheUrl(urlToCache);

    // Verifying if the cache was updated properly
    List<UrlModel> cachedUrls = await localDataSource.getCachedList();
    expect(cachedUrls, isNotEmpty);
    expect(cachedUrls[0].originalUrl, equals(urlToCache.originalUrl));
    expect(cachedUrls[0].shortCode, equals(urlToCache.shortCode));
    expect(cachedUrls[0].shortUrl, equals(urlToCache.shortUrl));
  });
}
