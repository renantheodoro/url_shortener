import 'package:flutter/material.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';

class UrlList extends StatefulWidget {
  const UrlList({Key? key, this.urlList}) : super(key: key);

  final List<UrlEntity>? urlList;

  @override
  State<UrlList> createState() => _UrlListState();
}

class _UrlListState extends State<UrlList> {
  @override
  Widget build(BuildContext context) => Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.urlList?.length,
          itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                widget.urlList![index].urlLinks!.short ?? '',
              )),
        ),
      );
}
