import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';

class UrlModel extends UrlEntity {
  const UrlModel({String? alias, UrlLinksModel? urlLinks})
      : super(alias: alias, urlLinks: urlLinks);

  factory UrlModel.toModel(dynamic json) {
    if (json is String) {
      return UrlModelAdapter.fromJson(json);
    } else {
      return UrlModelAdapter.toModel(json);
    }
  }

  static Map<String, dynamic> fromModel(UrlModel data) {
    return UrlModelAdapter.fromModel(data);
  }

  static String toJson(UrlModel data) {
    return UrlModelAdapter.toJson(data);
  }

  static UrlModel fromJson(String data) {
    return UrlModelAdapter.fromJson(data);
  }
}

class UrlLinksModel extends UrlLinksEntity {
  UrlLinksModel({
    required String? self,
    required String? short,
  }) : super(self: self, short: short);
}
