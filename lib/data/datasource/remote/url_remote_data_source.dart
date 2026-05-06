import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_shortener/core/error/exception.dart';
import 'package:url_shortener/data/models/url_model.dart';

abstract class UrlRemoteDataSourceInterface {
  Future<UrlModel> shorten(String originalUrl);
}

class UrlRemoteDataSource implements UrlRemoteDataSourceInterface {
  UrlRemoteDataSource(this.client);

  final http.Client client;

  @override
  Future<UrlModel> shorten(String originalUrl) async {
    final Uri url = Uri.parse(
        'https://us-central1-url-shortener-api-c5488.cloudfunctions.net/app/api/shorten');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final String body = jsonEncode({"url": originalUrl});

    final http.Response response =
        await client.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw ServerException();
    }
    return UrlModel.toModel(jsonDecode(response.body));
  }
}
