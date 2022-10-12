import 'dart:async';

import 'package:url_shortener/core/consts/cached_url_key.const.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/data/models/url_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UrlLocalDataSourceInterface {
  Future<List<UrlModel>> getCachedList();
  Future<void> cacheUrl(UrlModel urlToCache);
}

class UrlLocalDataSource implements UrlLocalDataSourceInterface {
  @override
  Future<List<UrlModel>> getCachedList() async {
    List<UrlModel> urlsListModels = <UrlModel>[];
    final String? urlsListCache = (await SharedPreferences.getInstance())
        .getString(cachedUrlKey);

    if (urlsListCache != null) {
      urlsListModels = UrlModelsAdapter.fromJson(urlsListCache);
    }

    return urlsListModels;
  }

  @override
  Future<void> cacheUrl(UrlModel urlToCache) async {
    final List<UrlModel> urlsListModels = await getCachedList();
    urlsListModels.add(urlToCache);
    final String urlListToCache = UrlModelsAdapter.toJson(urlsListModels);
    await (await SharedPreferences.getInstance())
        .setString(cachedUrlKey, urlListToCache);
  }
}