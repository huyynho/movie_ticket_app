import 'package:get/get.dart';
import 'package:movie_ticket/common/login/login_binding.dart';
import 'package:movie_ticket/common/login/login_screen.dart';
import 'package:movie_ticket/common/register/register_binding.dart';
import 'package:movie_ticket/common/register/register_screen.dart';
import 'package:movie_ticket/common/splash/splash_screen.dart';
import 'package:movie_ticket/screen/detail/detail_screen.dart';
import 'package:movie_ticket/screen/movie/movie_screen.dart';
import 'package:movie_ticket/screen/seat/seat_screen.dart';

class AppRouter {
  static final router = [
    GetPage(name: AppRouterName.splash, page: () => SplashScreen()),
    GetPage(
      name: AppRouterName.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRouterName.register,
      page: () => RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRouterName.movie,
      page: () => MovieScreen(),
    ),
    GetPage(
      name: AppRouterName.detail,
      page: () => DetailScreen(movie: Get.arguments),
    ),
    GetPage(
      name: AppRouterName.booking,
      page: () => SeatScreen(movie: Get.arguments),
    ),
  ];
}

class AppRouterName {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const movie = '/movie';
  static const detail = '/detail';
  static const booking = '/booking';
}
