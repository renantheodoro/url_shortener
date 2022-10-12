import 'package:flutter/material.dart';
import 'package:url_shortener/data/factory.dart';
import 'package:url_shortener/routes_path.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.initialRoute:
      case RoutePaths.home:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => getHomeView(),
        );
      case RoutePaths.completeList:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => getCompleteListView(),
        );

      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
