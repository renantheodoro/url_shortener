import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/data/models/url_model.dart';

import '../../../fixtures/fixture_reader.dart';

List<UrlModel> _generateList() {
  List<UrlModel> list = [];
  List<dynamic> jsonList = jsonDecode(fixture('url_list.json'));

  for (var i = 0; i < jsonList.length; i++) {
    list.add(UrlModel.toModel(jsonList[i] as Map<String, dynamic>));
  }
  return list;
}

void main() {
  late UrlLinksModel urlLinksModel;
  late UrlModel urlModel;

  setUp(() {
    urlLinksModel = UrlLinksModel(self: '<original url>', short: '<short url>');

    urlModel = UrlModel(alias: '<url alias>', urlLinks: urlLinksModel);
  });

  group('UrlModelAdapter tests', () {
    test('toModel method should return a model from a map', () {
      Map<String, dynamic> jsonMap = jsonDecode(fixture('url.json'));

      UrlModel result = UrlModelAdapter.toModel(jsonMap);

      expect(result.alias, equals(urlModel.alias));
      expect(result.urlLinks, isA<UrlLinksModel>());
      expect(result.urlLinks?.self, equals(urlModel.urlLinks?.self));
      expect(result.urlLinks?.short, equals(urlModel.urlLinks?.short));
    });

    test('fromModel method should return a Map from a model', () {
      Map<String, dynamic> result = UrlModelAdapter.fromModel(urlModel);

      expect(result, isA<Map>());
      expect(result['alias'], equals(urlModel.alias));
      expect(result['_links'], equals(isNotNull));
      expect(result['_links']['self'], equals(isNotNull));
      expect(result['_links']['self'], equals(urlModel.urlLinks?.self));
      expect(result['_links']['short'], equals(isNotNull));
      expect(result['_links']['short'], equals(urlModel.urlLinks?.short));
    });

    test('toJson method should return a String from model', () {
      String result = UrlModelAdapter.toJson(urlModel);

      expect(result, isA<String>());
      expect(result, equals(isNotNull));
      expect(result, equals(isNot('')));
      expect(result, contains(urlModel.alias));
      expect(result, contains(urlModel.urlLinks?.self));
      expect(result, contains(urlModel.urlLinks?.short));
    });

    test('fromJson method should return a model from json', () {
      UrlModel result = UrlModelAdapter.fromJson(fixture('url.json'));

      expect(result, equals(isNotNull));
      expect(result, equals(isA<UrlModel>()));
      expect(result.alias, equals(isNot('')));
      expect(result.urlLinks, equals(isA<UrlLinksModel>()));
      expect(result.urlLinks?.self, equals(isNot('')));
      expect(result.urlLinks?.short, equals(isNot('')));
    });
  });

  group('UrlLinksModelAdapter tests', () {
    test('toModel method should return a model from a map', () {
      Map<String, dynamic> jsonMap = jsonDecode(fixture('url_links.json'));

      UrlLinksModel result = UrlLinksModelAdapter.toModel(jsonMap);

      expect(result, equals(isNotNull));
      expect(result, isA<UrlLinksModel>());
      expect(result.self, equals(urlLinksModel.self));
      expect(result.short, equals(urlLinksModel.short));
    });

    test('fromModel method should return a Map from a model', () {
      Map<String, dynamic> result =
          UrlLinksModelAdapter.fromModel(urlLinksModel);

      expect(result, allOf([equals(isNotNull), isA<Map>()]));
      expect(result['self'],
          allOf([equals(isNotNull), equals(urlModel.urlLinks?.self)]));
      expect(result['short'],
          allOf([equals(isNotNull), equals(urlModel.urlLinks?.short)]));
    });

    test('toJson method should return a String from model', () {
      String result = UrlLinksModelAdapter.toJson(urlLinksModel);

      expect(
          result,
          allOf([
            isA<String>(),
            equals(isNotNull),
            equals(isNot('')),
            contains(urlLinksModel.self),
            contains(urlLinksModel.short)
          ]));
    });

    test('fromJson method should return a model from json', () {
      UrlLinksModel result =
          UrlLinksModelAdapter.fromJson(fixture('url_links.json'));

      expect(result, allOf([equals(isNotNull), equals(isA<UrlLinksModel>())]));
      expect(result.self, equals(isNot('')));
      expect(result.short, equals(isNot('')));
    });
  });

  group('UrlModelsAdapter tests', () {
    test('toJson method should return a String from a list of models', () {
      String result = UrlModelsAdapter.toJson(_generateList());

      expect(
          result,
          allOf([
            isA<String>(),
            equals(isNotNull),
            equals(isNot('')),
            contains(urlModel.alias),
          ]));
    });

    test('fromJson method should return a list of models from json', () {
      List<UrlModel> result =
          UrlModelsAdapter.fromJson(fixture('url_list.json'));

      expect(result, allOf([equals(isNotNull), equals(isA<List<UrlModel>>())]));
      expect(result[0].alias,
          allOf([equals(isNotNull), equals(isA<String>()), equals(isNot(''))]));
      expect(result[0].urlLinks,
          allOf([equals(isNotNull), equals(isA<UrlLinksModel>())]));
      expect(result[0].urlLinks?.self,
          allOf([equals(isNotNull), equals(isA<String>()), equals(isNot(''))]));
      expect(result[0].urlLinks?.short,
          allOf([equals(isNotNull), equals(isA<String>()), equals(isNot(''))]));
    });
  });
}
