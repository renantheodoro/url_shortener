import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/usecases/usecase.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/domain/protocols/get_full_urls_protocol.dart';

class GetFullUrlListUseCase
    extends UseCase<List<UrlEntity>, NoParams> {
  GetFullUrlListUseCase(this.protocol);

  GetFullUrlsProtocol protocol;

  @override
  Future<ServiceResponse<Failure, List<UrlEntity>>> call(
      NoParams params) async {
    final ServiceResponse<Failure, List<UrlEntity>> data =
        await protocol.getCachedList();

    if (data.failure != null) {
      return ServiceResponse.build(failure: CacheFailure());
    }

    List<UrlEntity>? shorteneUrlsFullList = data.response;

    shorteneUrlsFullList = List.from(shorteneUrlsFullList!.reversed);

    return ServiceResponse.build(response: shorteneUrlsFullList);
  }
}