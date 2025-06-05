import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/helper/route_helper.dart';
import 'package:charts_application/widgets/google_button.dart';
import 'package:charts_application/widgets/shake_widget.dart';
import 'package:charts_application/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
    final GlobalKey<ShakeWidgetState> passwordshakekey = GlobalKey<ShakeWidgetState>();
    final GlobalKey<ShakeWidgetState> emailshakekey = GlobalKey<ShakeWidgetState>();
  // Get the AuthController from GetX.
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (!_formKey.currentState!.validate()) {
      passwordshakekey.currentState?.shake();
    emailshakekey.currentState?.shake();
    return;
    }
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      authController.login(email, password).then((status) {
        if (status.isSuccess == true) {
          Get.offNamed(RouteHelper.getHome());
        } else {
          Get.snackbar(
            "Failed".tr,
            status.message,
            colorText: Colors.black,
            snackPosition: SnackPosition.TOP,
            
          );
        }
      });
  }

  void google() {
    authController.authGoogleSignIn().then((status) {
      if (status.isSuccess == true) {
        Get.snackbar(
          "Success".tr,
          status.message,
          backgroundColor: Colors.lightBlueAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Failed".tr,
          status.message,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          // Enable instant validation after user interaction
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: Dimensions.height30(context) * 4),

             Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Dimensions.radius15(context) * 5,
                  backgroundImage: const AssetImage("assets/image/app_logo.png"),
                ),
              ),

              SizedBox(height: Dimensions.height30(context) + Dimensions.height20(context)),

              // Optional Welcome Message
               Text(
                "welcome".tr,
                style: TextStyle(fontSize: Dimensions.font26(context), fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Dimensions.height30(context)),

              // Email Text Field using your AppTextField widget
              ShakeWidget(
                key:emailshakekey,
                child: AppTextField(
                  textController: emailController,
                  hintText: "user@example.com",
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required".tr;
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                    ).hasMatch(value)) {
                      return "Invalid email format".tr;
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: Dimensions.height30(context)),

              // Password Field with toggle functionality
              ShakeWidget(
                key: passwordshakekey,
                child: AppTextField(
  textController: passwordController,
  hintText: "*********",
  icon: Icons.password,
  isObs: true,
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required".tr;
    }
    if (value.trim().length < 8) {
      return "Password must be at least 8 characters".tr;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least 1 uppercase letter".tr;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least 1 lowercase letter".tr;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least 1 number".tr;
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return "Password must contain at least 1 special character".tr;
    }
    return null;
  },
),

              ),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.height20(context),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password action here.
                    },
                    child:  Text(
                      "Forgot Password?".tr,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),

              SizedBox(height: Dimensions.height30(context)/2),

              // Sign In Button using authController.isLoading
          Obx(
  () => InkWell(
    onTap: authController.isLoading.value ? null : login,
    borderRadius: BorderRadius.circular(Dimensions.radius30(context)),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: Dimensions.screenWidth(context) / 2,
      height: Dimensions.screenHeight(context) / 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30(context)),
        color: Colors.blue,
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: authController.isLoading.value
              ?  CircularProgressIndicator(
                  key: ValueKey("loading".tr),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  "Sign In".tr,
                  key:  ValueKey("signIn".tr),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.font16(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    ),
  ),
),


              SizedBox(height: Dimensions.height10(context)),

              // Row for Google Sign-In and navigation to Sign Up page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoogleSignInButton(onPressed: google),
                  SizedBox(width: Dimensions.width15(context)),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed(RouteHelper.getSignUp());
                    },
                    child:  Text(
                      "Don't have an account?".tr,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Dimensions.height30(context)),
            ],
          ),
        ),
      ),
    );
  }
}
