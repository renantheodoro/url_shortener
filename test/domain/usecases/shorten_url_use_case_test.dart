import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:url_shortener/domain/protocols/shorten_url_protocol.dart';
import 'package:url_shortener/domain/usecases/shorten_url_use_case.dart';

import '../../fixtures/fixture_reader.dart';

class MockShortenUrlProtocol extends Mock implements ShortenUrlProtocol {}

void main() {
  late MockShortenUrlProtocol mockProtocol;
  late ShortenUrlUseCase useCase;

  late UrlParams validUrlParams;
  late UrlParams invalidUrlParams;

  late String originalUrl;

  setUp(() {
    mockProtocol = MockShortenUrlProtocol();
    useCase = ShortenUrlUseCase(mockProtocol);

    originalUrl = '<original url>';

    validUrlParams = UrlParams(originalUrl);
    invalidUrlParams = const UrlParams('');
  });

  test(
      'should return a valid UrlEntity when calls use case with correct params',
      () async {
    when(() => mockProtocol.shorten(validUrlParams.originalUrl))
        .thenAnswer((_) async =>
            await Future.value(ServiceResponse.build(response:  UrlModelAdapter.fromJson(fixture('url.json')))));

    final ServiceResponse<Failure, UrlEntity> result =
        await useCase(validUrlParams);

    expect(result.failure, equals(isNull));
    expect(result.response, equals(isNotNull));
    expect(
        result.response!.alias, allOf([equals(isNotNull), isA<String>(), isNot('')]));
  });

  test('should throws a failure when calls using incorrect params',
      () async {
    final ServiceResponse<Failure, dynamic> result =
        await useCase(invalidUrlParams);

    expect(result.failure, allOf([equals(isNotNull), equals(InvalidParams())]));
    expect(result.response, equals(isNull));
  });
}
