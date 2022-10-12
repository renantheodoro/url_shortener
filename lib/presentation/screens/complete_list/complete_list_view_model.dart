import 'package:flutter/material.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/core/usecases/usecase.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/domain/usecases/get_full_url_list_use_case.dart';

class CompleteListViewModel extends ChangeNotifier {
  CompleteListViewModel({required this.getFullUrlListUseCase});

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  GetFullUrlListUseCase getFullUrlListUseCase;

  List<UrlEntity>? _fullUrlList;
  List<UrlEntity>? get fullUrlList => _fullUrlList;

  Future<void> getShortenedUrls() async {
    setBusy(true);
    ServiceResponse<Failure, List<UrlEntity>> data = await getFullUrlListUseCase(NoParams());
    _fullUrlList = data.response;
    setBusy(false);
  }
}
