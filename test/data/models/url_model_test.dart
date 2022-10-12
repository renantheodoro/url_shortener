import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/data/models/url_model.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  late UrlLinksModel urlLinksModel;
  late UrlModel urlModel;

  setUp(() {
    urlLinksModel = UrlLinksModel(self: '<original url>', short: '<short url>');
    urlModel = UrlModel(alias: '<url alias>', urlLinks: urlLinksModel);
  });

  group('classes type testing', () {
    test('UrlModel should be a subclass of UrlEntity', () {
      expect(urlModel, isA<UrlEntity>());
    });

    test('UrlLinksModel should be a subclass of UrlLinksEntity', () {
      expect(urlLinksModel, isA<UrlLinksEntity>());
    });
  });

  group('serialize tests', () {
    test('toModel method should return a model from json string', () {
      String jsonString = fixture('url.json');

      UrlModel result = UrlModel.toModel(jsonString);

      expect(result.alias, equals(urlModel.alias));
      expect(result.urlLinks, isA<UrlLinksModel>());
      expect(result.urlLinks?.self, equals(urlModel.urlLinks?.self));
      expect(result.urlLinks?.short, equals(urlModel.urlLinks?.short));
    });

    test('toModel method should return a model from json map', () {
      Map<String, dynamic> jsonMap = jsonDecode(fixture('url.json'));

      UrlModel result = UrlModel.toModel(jsonMap);

      expect(result.alias, equals(urlModel.alias));
      expect(result.urlLinks, isA<UrlLinksModel>());
      expect(result.urlLinks?.self, equals(urlModel.urlLinks?.self));
      expect(result.urlLinks?.short, equals(urlModel.urlLinks?.short));
    });

    test('fromModel method should return a Map from model', () {
      Map<String, dynamic> result = UrlModel.fromModel(urlModel);

      expect(result, isA<Map>());
      expect(result['alias'], equals(urlModel.alias));
      expect(result['_links'], equals(isNotNull));
      expect(result['_links']['self'],
          allOf([equals(isNotNull), equals(urlModel.urlLinks?.self)]));
      expect(result['_links']['short'],
          allOf([equals(isNotNull), equals(urlModel.urlLinks?.short)]));
    });

    test('toJson method should return a String from model', () {
      String result = UrlModel.toJson(urlModel);

      expect(
          result,
          allOf([
            isA<String>(),
            equals(isNotNull),
            equals(isNot('')),
            contains(urlModel.alias),
            contains(urlModel.urlLinks?.self),
            contains(urlModel.urlLinks?.short)
          ]));
    });

    test('fromJson method should return a model from json', () {
      UrlModel result = UrlModel.fromJson(fixture('url.json'));

      expect(result, allOf([equals(isNotNull), equals(isA<UrlModel>())]));
      expect(result.alias, equals(isNot('')));
      expect(result.urlLinks, equals(isA<UrlLinksModel>()));
      expect(result.urlLinks?.self, equals(isNot('')));
      expect(result.urlLinks?.short, equals(isNot('')));
    });
  });
}
