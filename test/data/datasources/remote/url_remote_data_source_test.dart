import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/consts/uri.const.dart';
import 'package:url_shortener/data/datasource/remote/url_remote_data_source.dart';
import 'package:url_shortener/data/models/url_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client mockClient;
  late UrlRemoteDataSource urlRemoteDataSource;

  late String originalUrl;
  late Uri url;
  late Map<String, String> headers;
  late String body;

  setUp(() {
    mockClient = MockClient();
    urlRemoteDataSource = UrlRemoteDataSource(mockClient);

    originalUrl = '<original url>';

    url = Uri.parse(uriPath);
    headers = {'Content-Type': 'application/json'};
    body = jsonEncode({"url": originalUrl});
  });

  test('should short an url and return a url model', () async {
    when(() => mockClient.post(url, headers: headers, body: body)).thenAnswer(
        (_) async =>
            await Future.value(http.Response(fixture('url.json'), 200)));

    final UrlModel result = await urlRemoteDataSource.shorten(originalUrl);

    expect(result, allOf([equals(isNotNull), equals(isA<UrlModel>())]));
    expect(result.alias,
        allOf([equals(isNotNull), equals(isA<String>()), equals(isNot(''))]));
    expect(result.urlLinks,
        allOf([equals(isNotNull), equals(isA<UrlLinksModel>())]));
    expect(result.urlLinks?.self,
        allOf([equals(isNotNull), equals(isA<String>()), equals(originalUrl)]));
    expect(result.urlLinks?.short,
        allOf([equals(isNotNull), equals(isA<String>()), equals(isNot(''))]));
  });

  test('should throws a server exception if response is different than 200',
      () async {
    when(() => mockClient.post(url, headers: headers, body: body)).thenAnswer(
        (_) async =>
            await Future.value(http.Response(fixture('url.json'), 404)));

    expect(() async => await urlRemoteDataSource.shorten(originalUrl),
        throwsException);

  });
}
