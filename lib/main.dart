import 'package:charts_application/helper/route_helper.dart';
import 'package:charts_application/langs/app_translations.dart';
import 'package:charts_application/pages/home/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_application/helper/initial.dart' as deb;
import 'package:shared_preferences/shared_preferences.dart';



Future<Locale> getSavedLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? langCode = prefs.getString('selected_language') ?? 'en';
  return Locale(langCode);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deb.init();
   Locale locale = await getSavedLocale();
  runApp(MyApp(locale: locale));
}

class MyApp extends StatelessWidget {
    final Locale locale;
const MyApp({super.key, required  this.locale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: Locale('en'),
      transitionDuration: const Duration(milliseconds: 75),
      getPages: RouteHelper.routes,
      home: const SplashScreen(),
    );
  }
}

//5-make a Save me button in the sign in and sign up.
//what else code i do ?
//catch the user if he has a profile image or not ! this is something cool maybe!
//and here what else 


