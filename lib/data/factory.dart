import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_shortener/core/platform/network_info.dart';
import 'package:url_shortener/data/datasource/local/url_local_data_source.dart';
import 'package:url_shortener/data/repositories/url_respository.dart';
import 'package:url_shortener/domain/protocols/get_full_urls_protocol.dart';
import 'package:url_shortener/domain/protocols/shorten_url_protocol.dart';
import 'package:url_shortener/domain/usecases/get_full_url_list_use_case.dart';
import 'package:url_shortener/domain/usecases/get_recently_urls_use_case.dart';
import 'package:url_shortener/domain/usecases/shorten_url_use_case.dart';
import 'package:url_shortener/presentation/screens/complete_list/complete_list_view.dart';
import 'package:url_shortener/presentation/screens/complete_list/complete_list_view_model.dart';
import 'package:url_shortener/presentation/screens/home/home_view.dart';
import 'package:url_shortener/presentation/screens/home/home_view_model.dart';
import 'package:provider/provider.dart';

import 'datasource/remote/url_remote_data_source.dart';

// HOME VIEW
Widget getHomeView() => ChangeNotifierProvider<HomeViewModel>(
      create: (context) =>
          getHomeViewModel(context)..getRecentlyShortenedUrls(),
      child: const HomeView(),
    );

// HOME VIEW MODEL
HomeViewModel getHomeViewModel(BuildContext context) => HomeViewModel(
    shortenUrlUseCase: ShortenUrlUseCase(getShortenUrlProtocol()),
    getRecentlyShortenedUrlsUseCase: GetRecentlyShortenedUrlsUseCase(
      getFullUrlsProtocol(),
    ))
  ..getRecentlyShortenedUrls();

// COMPLETE LIST VIEW
Widget getCompleteListView() => ChangeNotifierProvider<CompleteListViewModel>(
      create: (context) =>
          getCompleteListViewModel(context)..getShortenedUrls(),
      child: const CompleteListView(),
    );

// COMPLETE LIST VIEW MODEL
CompleteListViewModel getCompleteListViewModel(BuildContext context) =>
    CompleteListViewModel(getFullUrlListUseCase: getGetFullUrlsUseCase());

GetFullUrlListUseCase getGetFullUrlsUseCase() =>
    GetFullUrlListUseCase(getFullUrlsProtocol());

// SHORTEN
ShortenUrlProtocol getShortenUrlProtocol() => UrlRepository(
    localDataSource: UrlLocalDataSource(),
    remoteDataSource: UrlRemoteDataSource(getClient()),
    networkInfo: NetworkInfo());

GetFullUrlsProtocol getFullUrlsProtocol() => UrlRepository(
    localDataSource: UrlLocalDataSource(),
    remoteDataSource: UrlRemoteDataSource(getClient()),
    networkInfo: NetworkInfo());

// CLIENT
http.Client getClient() => http.Client();
