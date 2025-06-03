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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find<AuthController>();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat();
    _checkLoginStatus();
    authController.clearAccessToken();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1));
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
                width: Dimensions.width30(context) * 3,
                height: Dimensions.height30(context) * 3,
              ),
            ),
            SizedBox(height: Dimensions.height15(context)),
            Text(
              "splash_welcome".tr,
              style: TextStyle(
                fontSize: Dimensions.font26(context)/2,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: Dimensions.height10(context)),

            // Typing dots animation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedOpacity(
                  opacity: _controller.value < 0.5 ? 1.0 : 0.2,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    "•",
                    style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
