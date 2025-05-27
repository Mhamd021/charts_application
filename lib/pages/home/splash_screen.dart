import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_application/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    bool isLoggedIn = await authController.checkLoginStatus();

    Get.offNamed(isLoggedIn ? RouteHelper.getHome() : RouteHelper.getSignIn());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 1200),
              child: Image.asset(
                "assets/image/app_logo.png",
                width: Dimensions.width30(context) * 2.5,
                height: Dimensions.height30(context) * 2.5,
              ),
            ),
            SizedBox(height: Dimensions.height15(context)),
            Text(
              "DoctorMap",
              style: TextStyle(
                fontSize: Dimensions.font26(context),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
