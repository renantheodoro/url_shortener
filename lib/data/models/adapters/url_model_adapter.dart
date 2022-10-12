import 'dart:convert';

import 'package:url_shortener/data/models/url_model.dart';

class UrlModelAdapter {
  static UrlModel toModel(Map<String, dynamic> json) => UrlModel(
      alias: json['alias'] as String,
      urlLinks: json['_links'] is String
          ? UrlLinksModelAdapter.fromJson(json['_links'] as String)
          : UrlLinksModelAdapter.toModel(
              json['_links'] as Map<String, dynamic>));

  static Map<String, dynamic> fromModel(UrlModel urlModel) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alias'] = urlModel.alias ?? '';
    data['_links'] = UrlLinksModelAdapter.fromModel(
            urlModel.urlLinks as UrlLinksModel);

    return data;
  }

  static String toJson(UrlModel user) => jsonEncode(fromModel(user));

  static UrlModel fromJson(String json) =>
      toModel(jsonDecode(json) as Map<String, dynamic>);
}

class UrlLinksModelAdapter {
  static UrlLinksModel toModel(Map<String, dynamic> json) => UrlLinksModel(
      self: json['self'] as String, short: json['short'] as String);

  static Map<String, dynamic> fromModel(UrlLinksModel urlModel) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self'] = urlModel.self;
    data['short'] = urlModel.short;
    return data;
  }

  static String toJson(UrlLinksModel user) => jsonEncode(fromModel(user));

  static UrlLinksModel fromJson(String json) =>
      toModel(jsonDecode(json) as Map<String, dynamic>);
}

class UrlModelsAdapter {
  static List<UrlModel> fromJson(String json) =>
      (jsonDecode(json) as List<dynamic>)
          .map<UrlModel>((item) => UrlModelAdapter.toModel(item))
          .toList();

  static String toJson(List<UrlModel> urls) => jsonEncode(urls
      .map<Map<String, dynamic>>((p) => UrlModelAdapter.fromModel(p))
      .toList());
}
