import 'dart:convert';

import 'package:url_shortener/data/models/url_model.dart';

class UrlModelAdapter {
  static UrlModel toModel(Map<String, dynamic> json) {
    return UrlModel(
      originalUrl: json['originalUrl'] as String? ??
          '', // Se for null, retorna uma string vazia
      shortCode: json['shortCode'] as String? ??
          '', // Se for null, retorna uma string vazia
      shortUrl: json['shortUrl'] as String? ??
          '', // Se for null, retorna uma string vazia
    );
  }

  static Map<String, dynamic> fromModel(UrlModel urlModel) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['originalUrl'] = urlModel.originalUrl ?? '';
    data['shortCode'] = urlModel.shortCode ?? '';
    data['shortUrl'] = urlModel.shortUrl ?? '';
    return data;
  }

  static String toJson(UrlModel user) => jsonEncode(fromModel(user));

  static UrlModel fromJson(String json) =>
      toModel(jsonDecode(json) as Map<String, dynamic>);
}
