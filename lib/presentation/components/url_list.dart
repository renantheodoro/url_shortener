import 'package:flutter/material.dart';
import 'package:url_shortener/domain/entities/url_entity.dart';
import 'package:flutter/services.dart';

class UrlList extends StatefulWidget {
  const UrlList({Key? key, this.urlList}) : super(key: key);

  final List<UrlEntity>? urlList;

  @override
  State<UrlList> createState() => _UrlListState();
}

class _UrlListState extends State<UrlList> {
  void _copyToClipboard(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.urlList?.length ?? 0,
      itemBuilder: (context, index) {
        final urlEntity = widget.urlList![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      urlEntity.shortUrl ?? '',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.blue),
                    onPressed: () => _copyToClipboard(urlEntity.shortUrl ?? ''),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
