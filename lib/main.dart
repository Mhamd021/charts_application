import 'package:charts_application/helper/route_helper.dart';
import 'package:charts_application/langs/app_translations.dart';
import 'package:charts_application/pages/home/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_application/helper/initial.dart' as deb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deb.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      translations: AppTranslations(),
      locale: Locale('en'), // Default language
      fallbackLocale: Locale('en'),
      transitionDuration: const Duration(milliseconds: 75),
      getPages: RouteHelper.routes,
      home: const SplashScreen(),
    );
  }
}
//3-add Arabic lamguage and then the Logic for the arabic and english switch .and also add a Dark Theme for the APP and it is Optional!
//4-check for the methods and its return values.
//5-make a Save me button in the sign in and sign up.
//6-adjust the height and width to be dynamic.
//7- try to implement check connection before making requests!
//what else code i do ?


