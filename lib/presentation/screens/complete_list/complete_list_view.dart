import 'package:flutter/material.dart';
import 'package:url_shortener/presentation/components/text.dart';
import 'package:url_shortener/presentation/components/url_list.dart';
import 'package:url_shortener/presentation/screens/complete_list/complete_list_view_model.dart';
import 'package:provider/provider.dart';

class CompleteListView extends StatefulWidget {
  const CompleteListView({Key? key}) : super(key: key);

  @override
  State<CompleteListView> createState() => _CompleteListViewState();
}

class _CompleteListViewState extends State<CompleteListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<CompleteListViewModel>(
        builder: (context, model, child) {
          return model.busy
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      const TextBold(
                        text: 'Recently shortened URLs',
                      ),
                      const SizedBox(height: 16.0),
                      if (model.fullUrlList != null &&
                          model.fullUrlList!.isNotEmpty)
                        UrlList(
                          urlList: model.fullUrlList,
                        )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
