import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseCache {
  final Future<SharedPreferences> cacheInstance = SharedPreferences.getInstance();
}