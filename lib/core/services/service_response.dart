class ServiceResponse<Failure, T> {
  ServiceResponse.build({this.failure, this.response});

  final Failure? failure;
  final T? response;
}