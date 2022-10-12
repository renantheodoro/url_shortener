import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/core/usecases/usecase.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/domain/protocols/get_full_urls_protocol.dart';
import 'package:url_shortener/domain/usecases/get_full_url_list_use_case.dart';

import '../../fixtures/fixture_reader.dart';

class MockGetFullUrlsProtocol extends Mock
    implements GetFullUrlsProtocol {}

List<UrlEntity> _generateList(int quantity) {
  List<UrlEntity> list = [];
  for (var i = 0; i < quantity; i++) {
    list.add( UrlModelAdapter.fromJson(fixture('url.json')));
  }
  return list;
}

void main() {
  late GetFullUrlsProtocol mockProtocol;
  late GetFullUrlListUseCase useCase;

  setUp(() {
    mockProtocol = MockGetFullUrlsProtocol();
    useCase = GetFullUrlListUseCase(mockProtocol);
  });

  test('should return a url list from cache data', () async {
    when(() => mockProtocol.getCachedList()).thenAnswer((_) async =>
        await Future.value(ServiceResponse.build(response: _generateList(10))));

    final ServiceResponse<Failure, List<UrlEntity>> result =
        await useCase(NoParams());

    expect(result.failure, equals(isNull));
    expect(result.response, allOf([equals(isNotNull), isA<List<UrlEntity>>()]));
  });

  test('should return exactly same length from received',
      () async {
    when(() => mockProtocol.getCachedList()).thenAnswer((_) async =>
        await Future.value(ServiceResponse.build(response: _generateList(10))));

    final ServiceResponse<Failure, List<UrlEntity>> result =
        await useCase(NoParams());

    expect(result.failure, equals(isNull));
    expect(result.response,
        allOf([equals(isNotNull), isA<List<UrlEntity>>(), hasLength(10)]));
  });

  test('should return an empty list if there isnt cache', () async {
    when(() => mockProtocol.getCachedList()).thenAnswer((_) async =>
        await Future.value(ServiceResponse.build(response: _generateList(0))));

    final ServiceResponse<Failure, List<UrlEntity>> result =
        await useCase(NoParams());

    expect(result.failure, equals(isNull));
    expect(result.response, allOf([equals(isNotNull), isA<List<UrlEntity>>(), hasLength(0)]));
  });

  test('should return a cache failure if protocols returns failure', () async {
    when(() => mockProtocol.getCachedList()).thenAnswer((_) async =>
        await Future.value(ServiceResponse.build(failure: CacheFailure())));

    final ServiceResponse<Failure, dynamic> result = await useCase(NoParams());

    expect(result.response, equals(isNull));
    expect(result.failure, allOf([equals(isNotNull), isA<CacheFailure>()]));
  });
}
