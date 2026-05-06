import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade800, Colors.purple.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          appTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
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

  void _copyToClipboard(String text) {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link copiado!')),
      );
    }
  }

  Widget _buildNavigatorButton() => OutlinedButton(
        key: const Key('navigatorButton'),
        onPressed: () {
          Navigator.of(context).pushNamed(RoutePaths.completeList);
        },
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.purple, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(4), // Arredondamento das bordas
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0)),
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
                          'View all shortened links',
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
                label: 'Enter the URL that you want to short',
              ),
            ),
            const SizedBox(
              width: 12.0,
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
          const SizedBox(
            height: 4.0,
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.model.currentUrl?.originalUrl ?? '',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.purple),
                  onPressed: () {
                    _copyToClipboard(
                        widget.model.currentUrl?.originalUrl ?? '');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const TextBold(
            text: 'Shortened:',
          ),
          const SizedBox(
            height: 4.0,
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.model.currentUrl?.shortUrl ?? '',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.purple),
                  onPressed: () {
                    _copyToClipboard(widget.model.currentUrl?.shortUrl ?? '');
                  },
                ),
              ],
            ),
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
            text: 'Recently shortened',
          ),
          const SizedBox(height: 16.0),
          UrlList(
            urlList: widget.model.currentUrlList,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                const SizedBox(
                  height: 12.0,
                ),
                _buildNavigatorButton()
              ],
            ),
          ),
        ],
      );
}
