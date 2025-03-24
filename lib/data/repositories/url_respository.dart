import 'package:url_shortener/core/error/exception.dart';
import 'package:url_shortener/data/datasource/local/url_local_data_source.dart';
import 'package:url_shortener/data/datasource/remote/url_remote_data_source.dart';
import 'package:url_shortener/data/models/url_model.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/domain/protocols/get_full_urls_protocol.dart';
import 'package:url_shortener/domain/protocols/shorten_url_protocol.dart';

class UrlRepository implements ShortenUrlProtocol, GetFullUrlsProtocol {
  UrlRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  UrlLocalDataSourceInterface localDataSource;
  UrlRemoteDataSourceInterface remoteDataSource;

  @override
  Future<ServiceResponse<Failure, UrlEntity>> shorten(String url) async {
    try {
      final UrlModel remoteData = await remoteDataSource.shorten(url);

      await localDataSource.cacheUrl(remoteData);

      return ServiceResponse.build(response: remoteData);
    } on ServerException {
      return ServiceResponse.build(failure: ServerFailure());
    }
  }

  @override
  Future<ServiceResponse<Failure, List<UrlEntity>>> getCachedList() async {
    final List<UrlModel> data = await localDataSource.getCachedList();
    return ServiceResponse.build(response: data);
  }
}
