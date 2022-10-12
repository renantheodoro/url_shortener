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

  group('gerUrlsListFromCache tests', () {
    test('should return a url list from cache', () async {
      Map<String, Object> values = <String, Object>{
        cachedUrlKey: fixture('url_list.json')
      };
      SharedPreferences.setMockInitialValues(values);

      List<UrlModel> result = await localDataSource.getCachedList();

      expect(
          result,
          allOf([
            equals(isNotNull),
            equals(isA<List<UrlModel>>()),
            equals(isNotEmpty)
          ]));
      expect(
          result[0].alias, allOf([equals(isA<String>()), equals(isNot(''))]));
      expect(result[0].urlLinks, equals(isA<UrlLinksModel>()));
      expect(result[0].urlLinks?.self,
          allOf([equals(isA<String>()), equals(isNot(''))]));
      expect(result[0].urlLinks?.short,
          allOf([equals(isA<String>()), equals(isNot(''))]));
    });

    test('should return an empty list when there is not a cache value',
        () async {
      Map<String, Object> values = <String, Object>{};
      SharedPreferences.setMockInitialValues(values);

      List<UrlModel> result = await localDataSource.getCachedList();

      expect(result, allOf([equals(isA<List<UrlModel>>()), equals(isEmpty)]));
    });
  });

  test('should set url into cache even if cache is empty', () async {
    Map<String, Object> values = <String, Object>{};
    SharedPreferences.setMockInitialValues(values);

    await localDataSource.cacheUrl(UrlModelAdapter.fromJson(fixture('url.json')));
  });
}
