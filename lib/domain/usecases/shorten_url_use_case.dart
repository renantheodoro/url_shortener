import 'package:equatable/equatable.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/core/usecases/usecase.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/domain/protocols/shorten_url_protocol.dart';

class ShortenUrlUseCase extends UseCase<UrlEntity, UrlParams> {
  ShortenUrlUseCase(this.protocol);

  final ShortenUrlProtocol protocol;

  @override
  Future<ServiceResponse<Failure, UrlEntity>> call(UrlParams params) async {
    if (params.originalUrl == '') {
      return ServiceResponse.build(failure: InvalidParams());
    }

    return await protocol.shorten(params.originalUrl);
  }
}

class UrlParams extends Equatable {
  const UrlParams(this.originalUrl);

  final String originalUrl;

  @override
  List<Object?> get props => [originalUrl];
}
