import 'package:flutter/material.dart';
import 'package:url_shortener/core/consts/app_title.const.dart';
import 'package:url_shortener/presentation/components/button_submit.dart';
import 'package:url_shortener/presentation/components/text.dart';
import 'package:url_shortener/presentation/components/text_input.dart';
import 'package:url_shortener/presentation/components/url_list.dart';
import 'package:url_shortener/presentation/screens/home/home_view_model.dart';
import 'package:url_shortener/routes_path.dart';
import 'package:provider/provider.dart';

class HomeView<T extends ChangeNotifier> extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState<T extends ChangeNotifier> extends State<HomeView> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: Consumer<HomeViewModel>(builder: (context, model, child) {
        return model.busy
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : HomeViewBody(inputController: _urlController, model: model);
      }),
    );
  }
}

class HomeViewBody extends StatefulWidget {
  const HomeViewBody(
      {Key? key, required this.inputController, required this.model})
      : super(key: key);

  final TextEditingController inputController;
  final HomeViewModel model;

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final _formKey = GlobalKey<FormState>();

  Widget _buildNavigatorButton() => InkWell(
        key: const Key('navigatorButton'),
        onTap: () {
          Navigator.of(context).pushNamed(RoutePaths.completeList);
        },
        child: Container(
          decoration: const BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.black12, width: 1.0))),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recently shortened',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Expanded(
                child: Center(
                    child: Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.purple,
                )),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildForm(),
                const SizedBox(height: 16.0),
                if (widget.model.currentUrl != null)
                  _buildCurrentShortenedInfo(),
                if (widget.model.currentUrlList!.isNotEmpty)
                  _buildShortenedUrlList(),
              ],
            ),
          ),
          _buildNavigatorButton()
        ],
      );

  Widget _buildForm() => Form(
        key: _formKey,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: InputText(
                key: const Key('inputKey'),
                controller: widget.inputController,
                label: 'URL',
              ),
            ),
            ButtonSubmit(callback: () async {
              if (_formKey.currentState!.validate()) {
                await widget.model
                    .shortenUrl(widget.inputController.text.trim());
                widget.inputController.text = '';
              }
            }),
          ],
        ),
      );

  Widget _buildCurrentShortenedInfo() => Column(
        key: const Key('resultColumn'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextBold(
            text: 'Original:',
          ),
          Text(
            '''${widget.model.currentUrl?.urlLinks?.self}''',
          ),
          const SizedBox(
            height: 12.0,
          ),
          const TextBold(
            text: 'Shortened:',
          ),
          Text(
            '''${widget.model.currentUrl?.urlLinks?.short}''',
          ),
          const SizedBox(height: 16.0),
          const Divider(color: Colors.grey),
        ],
      );

  Widget _buildShortenedUrlList() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 16.0),
          const TextBold(
            text: 'Last shortened URLs',
          ),
          const SizedBox(height: 16.0),
          UrlList(
            urlList: widget.model.currentUrlList,
          ),
        ],
      );
}
