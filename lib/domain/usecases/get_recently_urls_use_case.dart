import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/usecases/usecase.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/domain/protocols/get_full_urls_protocol.dart';

class GetRecentlyShortenedUrlsUseCase
    extends UseCase<List<UrlEntity>, NoParams> {
  GetRecentlyShortenedUrlsUseCase(this.protocol);

  GetFullUrlsProtocol protocol;

  @override
  Future<ServiceResponse<Failure, List<UrlEntity>>> call(
      NoParams params) async {
    final ServiceResponse<Failure, List<UrlEntity>> data =
        await protocol.getCachedList();

    if (data.failure != null) {
      return ServiceResponse.build(failure: CacheFailure());
    }

    List<UrlEntity>? shorteneUrlsFullList = data.response; // take
    final List<UrlEntity> shorteneUrlsSummaryList = [];

    shorteneUrlsFullList = List.from(shorteneUrlsFullList!.reversed);

    for (var element in shorteneUrlsFullList) {
      if (shorteneUrlsSummaryList.length < 4) { // no need to show the complete list
        shorteneUrlsSummaryList.add(element);
      } else {
        break;
      }
    }

    return ServiceResponse.build(response: shorteneUrlsSummaryList);
  }
}