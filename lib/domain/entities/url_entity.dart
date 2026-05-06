import 'package:equatable/equatable.dart';

class UrlEntity extends Equatable {
  const UrlEntity({
    this.originalUrl,
    this.shortCode,
    this.shortUrl,
  });

  final String? originalUrl;
  final String? shortCode;
  final String? shortUrl;

  @override
  List<Object?> get props => [originalUrl, shortCode, shortUrl];
}
