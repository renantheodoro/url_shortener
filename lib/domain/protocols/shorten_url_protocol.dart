import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';

abstract class ShortenUrlProtocol {
  Future<ServiceResponse<Failure, UrlEntity>> shorten(String url);
}