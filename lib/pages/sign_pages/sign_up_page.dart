import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/helper/route_helper.dart';
import 'package:charts_application/widgets/google_button.dart';
import 'package:charts_application/widgets/shake_widget.dart';
import 'package:charts_application/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final GlobalKey<ShakeWidgetState> shakeKey = GlobalKey<ShakeWidgetState>();

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
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void register() {
    if (!_formKey.currentState!.validate()) {
      shakeKey.currentState?.shake();
      return;
    }

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    authController.register(name, email, password).then((status) {
      if (status.isSuccess == true) {
        Get.offNamed(RouteHelper.getSignIn());
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

  void google() {
    authController.authGoogleSignIn().then((status) {
      if (status.isSuccess == true) {
        Get.toNamed(RouteHelper.getHome());
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: Dimensions.height30(context) * 4),

              // App Logo
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Dimensions.radius15(context) * 5,
                  backgroundImage: const AssetImage("assets/image/app_logo.png"),
                ),
              ),

              SizedBox(height: Dimensions.height20(context)),

               Text(
                "Create Account".tr,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: Dimensions.height30(context)),

              ShakeWidget(
                key: shakeKey,
                child: Column(
                  children: [
                    AppTextField(
                      textController: nameController,
                      hintText: "Full Name".tr,
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Name is required".tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: Dimensions.height20(context)),
                    AppTextField(
                      textController: emailController,
                      hintText: "user@example.com",
                      icon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required".tr;
                        }
                        if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                          return "Invalid email format".tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: Dimensions.height20(context)),
                    AppTextField(
                      textController: passwordController,
                      hintText: "*********",
                      icon: Icons.password,
                      isObs: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Password is required".tr;
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) return "Must have at least 1 uppercase letter".tr;
                        if (!RegExp(r'[a-z]').hasMatch(value)) return "Must have at least 1 lowercase letter".tr;
                        if (!RegExp(r'[0-9]').hasMatch(value)) return "Must have at least 1 number".tr;
                        if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) return "Must have at least 1 special character".tr;
                        if (value.trim().length < 8) return "Password must be at least 8 characters".tr;
                        return null;
                      },
                    ),
                    SizedBox(height: Dimensions.height20(context)),
                    AppTextField(
                      textController: confirmPasswordController,
                      hintText: "Confirm Password".tr,
                      icon: Icons.key,
                      isObs: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please confirm your password".tr;
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match".tr;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height30(context)),

              // Sign Up Button with loading animation
              Obx(
                () => InkWell(
                  onTap: authController.isLoading.value ? null : register,
                  borderRadius: BorderRadius.circular(Dimensions.radius30(context)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                         width: Dimensions.screenWidth(context) / 2,
                        height: Dimensions.screenHeight(context) / 15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30(context)),
                      color: Colors.blue.shade500,
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
                                "Sign Up".tr,
                                key: const ValueKey("signUp"),
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

              SizedBox(height: Dimensions.height20(context)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoogleSignInButton(onPressed: google),
                  SizedBox(width: Dimensions.width15(context)),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed(RouteHelper.getSignIn());
                    },
                    child:  Text(
                      "Already have an account?".tr,
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
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
