import 'package:equatable/equatable.dart';
import 'package:url_shortener/core/error/failures.dart';
import 'package:url_shortener/core/services/service_response.dart';

abstract class UseCase<Type, Params> {
  Future<ServiceResponse<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}