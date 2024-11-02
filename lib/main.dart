import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:movie_ticket/config/lang/local_string.dart';
import 'package:movie_ticket/config/route/routes.dart';
import 'package:movie_ticket/config/theme/theme_app.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

Future<void> configureApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) {
        return const Center(
          child: SpinKitCubeGrid(
            color: Colors.black45,
            size: 50,
          ),
        );
      },
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        ensureScreenSize: true,
        builder: (_, __) {
          return GetMaterialApp(
            translations: LocalString(),
            locale: const Locale('vi', 'VI'),
            theme: ThemesApp.light,
            darkTheme: ThemesApp.dark,
            debugShowCheckedModeBanner: false,
            getPages: AppRouter.router,
            initialRoute: AppRouterName.splash,
          );
        },
      ),
    );
  }
}
