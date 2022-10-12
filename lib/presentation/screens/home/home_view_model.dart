import 'package:flutter/material.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/core/usecases/usecase.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/domain/usecases/get_recently_urls_use_case.dart';
import 'package:url_shortener/domain/usecases/shorten_url_use_case.dart';


class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
      {required this.shortenUrlUseCase,
      required this.getRecentlyShortenedUrlsUseCase});

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  ShortenUrlUseCase shortenUrlUseCase;
  GetRecentlyShortenedUrlsUseCase getRecentlyShortenedUrlsUseCase;

  UrlEntity? _currentUrl;
  UrlEntity? get currentUrl => _currentUrl;

  List<UrlEntity>? _currentUrlList = [];
  List<UrlEntity>? get currentUrlList => _currentUrlList;

  Future<void> shortenUrl(String currentUrl) async {
    setBusy(true);
    final ServiceResponse<Failure, UrlEntity> data =
        await shortenUrlUseCase(UrlParams(currentUrl));

    if (data.response != null) {
      _currentUrl = data.response;
    }

    await getRecentlyShortenedUrls();

    setBusy(false);
  }

  Future<void> getRecentlyShortenedUrls() async {
    setBusy(true);
    final ServiceResponse<Failure, List<UrlEntity>> data =
        await getRecentlyShortenedUrlsUseCase(NoParams());

    if (data.response != null) {
      _currentUrlList = data.response ?? [];
    }

    notifyListeners();
    setBusy(false);
  }
}
