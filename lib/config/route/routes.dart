import 'package:get/get.dart';
import 'package:movie_ticket/common/login/login_binding.dart';
import 'package:movie_ticket/common/login/login_screen.dart';
import 'package:movie_ticket/common/register/register_binding.dart';
import 'package:movie_ticket/common/register/register_screen.dart';
import 'package:movie_ticket/common/splash/splash_screen.dart';
import 'package:movie_ticket/screen/detail/detail_screen.dart';
import 'package:movie_ticket/screen/home/home_screen.dart';
import 'package:movie_ticket/screen/movie/movie_screen.dart';
import 'package:movie_ticket/screen/my_ticket/my_ticket_screen.dart';
import 'package:movie_ticket/screen/seat/seat_screen.dart';
import 'package:movie_ticket/screen/setting/setting_screen.dart';
import 'package:movie_ticket/screen/ticket/ticket_screen.dart';

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
      name: AppRouterName.home,
      page: () => HomeScreen(),
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
      name: AppRouterName.seat,
      page: () => SeatScreen(movie: Get.arguments),
    ),
    GetPage(
      name: AppRouterName.ticket,
      page: () => TicketScreen(ticket: Get.arguments),
    ),
    GetPage(
      name: AppRouterName.myticket,
      page: () => MyTicketScreen(),
    ),
    GetPage(
      name: AppRouterName.setting,
      page: () => SettingScreen(),
    ),
  ];
}

class AppRouterName {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const movie = '/movie';
  static const detail = '/detail';
  static const seat = '/seat';
  static const ticket = '/ticket';
  static const myticket = '/myticket';
  static const setting = '/setting';
}
