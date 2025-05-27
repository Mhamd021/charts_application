import 'package:charts_application/widgets/shake_widget.dart';
import 'package:charts_application/widgets/text_field2_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/widgets/google_button.dart';
import '../../helper/route_helper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Global key for the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ShakeWidgetState> passwordshakekey = GlobalKey<ShakeWidgetState>();
    final GlobalKey<ShakeWidgetState> emailshakekey = GlobalKey<ShakeWidgetState>();

  final GlobalKey<ShakeWidgetState> nameshakekey = GlobalKey<ShakeWidgetState>();
    final GlobalKey<ShakeWidgetState> confirmpasswordshakekey = GlobalKey<ShakeWidgetState>();


  // Controllers for each text field.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  late AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  void google() {
    authController.authGoogleSignIn().then((status) {
      if (status.isSuccess == true) {
        Get.snackbar(
          "Success",
          status.message,
          backgroundColor: Colors.lightBlueAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Get.toNamed(RouteHelper.getHome());
      } else {
        Get.snackbar(
          "Failed",
          status.message,
          backgroundColor: Colors.deepPurple,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }

 void register() {

  if (!_formKey.currentState!.validate()) {
    passwordshakekey.currentState?.shake();
    emailshakekey.currentState?.shake();
    nameshakekey.currentState?.shake();
    confirmpasswordshakekey.currentState?.shake();
    return; 
  }

  String name = nameController.text.trim();
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  authController.register(name, email, password).then((status) {
    if (status.isSuccess == true) {
      Get.snackbar(
        "Success",
        status.message,
        backgroundColor: Colors.lightBlueAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offNamed(RouteHelper.getSignIn());
    } else {
      Get.snackbar(
        "Failed",
        status.message,
        backgroundColor: Colors.deepPurple,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: CurvedClipper(), 
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      backgroundImage: const AssetImage(
                        "assets/image/app_logo.png",
                      ),
                    ),
                    SizedBox(height: Dimensions.height10(context)),
                    Text(
                      "GeoClinic",
                      style: TextStyle(
                        fontSize: Dimensions.font20(context) + 4,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Sign-up form card.
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.30,
                20,
                20,
              ),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Dimensions.radius30(context),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        ShakeWidget(
                          key: nameshakekey,
                          child: CustomTextField(
                            controller: nameController,
                            labelText: "Username",
                            prefixIcon: Icons.person,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Name is required";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: Dimensions.height20(context)),
                        ShakeWidget(
                          key: emailshakekey,
                          child: CustomTextField(
                            controller: emailController,
                            labelText: "Email",
                            prefixIcon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Email is required";
                              }
                              RegExp emailRegex = RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return "Invalid email format";
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: Dimensions.height20(context)),
                       ShakeWidget(
                        key: passwordshakekey,
                         child: CustomTextField(
                           controller: passwordController,
                           labelText: "Password",
                           prefixIcon: Icons.password,
                           isPassword: true, // enable password-specific functionality
                           validator: (value) {
                             if (value == null || value.trim().isEmpty) {
                               return "Password is required";
                             }
                           
                             if (!RegExp(r'[A-Z]').hasMatch(value)) {
                               return "Password must contain at least 1 uppercase letter";
                             }
                             if (!RegExp(r'[a-z]').hasMatch(value)) {
                               return "Password must contain at least 1 lowercase letter";
                             }
                             if (!RegExp(r'[0-9]').hasMatch(value)) {
                               return "Password must contain at least 1 number";
                             }
                             if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                               return "Password must contain at least 1 special character";
                             }
                               if (value.trim().length < 8) {
                               return "Password must be at least 8 characters";
                             }
                             return null;
                           },
                         ),
                       ),

                        SizedBox(height: Dimensions.height20(context)),
                        ShakeWidget(
                          key:confirmpasswordshakekey,
                          child: CustomTextField(
                            controller: passwordConfirmController,
                            labelText: "Confirm Password",
                            prefixIcon: Icons.key,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please confirm your password";
                              }
                              if (value != passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: Dimensions.height30(context)),
                        Obx(
  () => InkWell(
    onTap: authController.isLoading.value ? null : register,
    borderRadius: BorderRadius.circular(Dimensions.radius30(context)),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: Dimensions.screenHeight(context) / 17,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30(context)),
        color: Colors.blue.shade500,
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: authController.isLoading.value
              ? const CircularProgressIndicator(
                  key: ValueKey("loading"),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  "Sign Up",
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
)
,
                        SizedBox(height: Dimensions.height20(context)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GoogleSignInButton(onPressed: google),
                            SizedBox(width: Dimensions.width10(context)),
                            GestureDetector(
                              onTap: () {
                                Get.offNamed(RouteHelper.getSignIn());
                              },
                              child: const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start at the top left corner
    path.lineTo(0, size.height - 50);
    // First curve
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    // Second curve
    var secondControlPoint = Offset(3 * size.width / 4, size.height);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    // Complete the path
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
