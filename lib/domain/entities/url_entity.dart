import 'package:equatable/equatable.dart';

class UrlEntity extends Equatable {
  const UrlEntity({this.alias, this.urlLinks});

  final String? alias;
  final UrlLinksEntity? urlLinks;

  @override
  List<Object?> get props => [alias, urlLinks];
}

class UrlLinksEntity {
  UrlLinksEntity({this.self, this.short});

  final String? self;
  final String? short;
}
