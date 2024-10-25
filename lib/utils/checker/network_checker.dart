import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:movie_ticket/utils/common_value/common_message.dart';

class CheckersUtils {
  static Future<String> checkNetworkError() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    try {
      InternetConnectionChecker().onStatusChange.listen((status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            isConnected = true;
            break;
          case InternetConnectionStatus.disconnected:
            isConnected = false;
            break;
        }
      });
    } catch (_) {}
    return isConnected ? '' : CommonMessage.noInternet;
  }
}
