import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/services/service_response.dart';
import 'package:url_shortener/core/usecases/usecase.dart';
import 'package:url_shortener/data/models/adapters/url_model_adapter.dart';
import 'package:url_shortener/data/models/url_model.dart';
import 'package:url_shortener/domain/usecases/get_full_url_list_use_case.dart';
import 'package:url_shortener/presentation/screens/complete_list/complete_list_view_model.dart';

import '../../../fixtures/fixture_reader.dart';

class MockGetFullUrlListUseCase extends Mock implements GetFullUrlListUseCase {}

void main() {
  late GetFullUrlListUseCase mockGetFullUrlListUseCase;
  late CompleteListViewModel completeListViewModel;

  late List<UrlModel> mockUrlModelList;

  setUp(() {
    mockGetFullUrlListUseCase = MockGetFullUrlListUseCase();
    completeListViewModel =
        CompleteListViewModel(getFullUrlListUseCase: mockGetFullUrlListUseCase);
    mockUrlModelList = UrlModelsAdapter.fromJson(fixture('url_list.json'));
  });

  testWidgets('should verify initial state', (tester) async {
    expect(completeListViewModel.busy, equals(false));
    expect(completeListViewModel.fullUrlList, equals(null));
  });

  testWidgets('should set true to setBusy', (tester) async {
    completeListViewModel.setBusy(true);
    expect(completeListViewModel.busy, equals(true));
  });

  testWidgets('should set false to setBusy', (tester) async {
    completeListViewModel.setBusy(false);
    expect(completeListViewModel.busy, equals(false));
  });

  testWidgets('should call getFullUrlListUseCase and receive the complete list of urls',
      (tester) async {
    when(() => mockGetFullUrlListUseCase(NoParams()))
        .thenAnswer((_) async => ServiceResponse.build(response: mockUrlModelList));

    await completeListViewModel.getShortenedUrls();

    expect(completeListViewModel.fullUrlList, equals(mockUrlModelList));

    verify(() => mockGetFullUrlListUseCase(NoParams())).called(1);
  });
}
