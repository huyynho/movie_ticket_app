import 'package:get/get.dart';
import 'package:movie_ticket/screen/movie/movie_controller.dart';

class MovieBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MovieController());
  }
}
