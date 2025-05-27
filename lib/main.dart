import 'package:charts_application/helper/route_helper.dart';
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
      transitionDuration: const Duration(milliseconds: 75),
      getPages: RouteHelper.routes,
      home: const SplashScreen(),
    );
  }
}
