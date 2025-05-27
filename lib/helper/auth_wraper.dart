import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/pages/home/home_page.dart';
import 'package:charts_application/pages/sign_pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return FutureBuilder(
      future: authController.checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Obx(() =>
              authController.isLoggedIn.value ? const HomePage() : const SignupPage());
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator())); 
      },
    );
  }
}
