
import 'package:data_connection_checker_tv/data_connection_checker.dart';

abstract class NetworkInfoInterface {
  Future<bool>? get isConnected;
}

class NetworkInfo implements NetworkInfoInterface {
  @override
  Future<bool>? get isConnected async =>
      await DataConnectionChecker().hasConnection;
}
