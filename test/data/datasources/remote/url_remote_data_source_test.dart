import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/error/exception.dart';
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
    url = Uri.parse('http://localhost:5001/api/shorten');
    headers = {'Content-Type': 'application/json'};
    body = jsonEncode({"url": originalUrl});
  });

  group('shorten URL tests', () {
    test('should short a url and return a url model', () async {
      // Arrange: mock a successful response with status code 200
      when(() => mockClient.post(url, headers: headers, body: body)).thenAnswer(
        (_) async => http.Response(fixture('url.json'), 200),
      );

      // Act: call the method under test
      final UrlModel result = await urlRemoteDataSource.shorten(originalUrl);

      // Assert: check that the result is a valid UrlModel
      expect(result, isA<UrlModel>());
      expect(result.alias, isNotEmpty);
      expect(result.urlLinks, isA<UrlLinksModel>());
      expect(result.urlLinks?.self, originalUrl);
      expect(result.urlLinks?.short, isNotEmpty);
    });

    test('should throw a server exception if response is not 200', () async {
      // Arrange: mock a failed response with status code 404
      when(() => mockClient.post(url, headers: headers, body: body)).thenAnswer(
        (_) async => http.Response(fixture('url.json'), 404),
      );

      // Act & Assert: ensure a ServerException is thrown for non-200 responses
      expect(
        () async => await urlRemoteDataSource.shorten(originalUrl),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
