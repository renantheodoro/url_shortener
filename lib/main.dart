import 'package:flutter/material.dart';
import 'package:url_shortener/core/consts/app_title.const.dart';
import 'package:url_shortener/routes.dart';

void main() {
  runApp(const URLShortnerApp());
}

class URLShortnerApp extends StatelessWidget {
  const URLShortnerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
