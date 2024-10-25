import 'package:get/get.dart';
import 'package:movie_ticket/common/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
