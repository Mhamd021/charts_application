import 'dart:convert' as convert;
import 'package:charts_application/constants/app_consts.dart';
import 'package:charts_application/helper/route_helper.dart';
import 'package:charts_application/models/response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthController extends GetxController implements GetxService {
  final storage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '1019784272471-th4he9rgkcde1fssefhn1a8o55taa8av.apps.googleusercontent.com',
  );
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  final RxString userId = ''.obs;

  Future<ResponseModel> login(String email, String password) async {
    isLoading.value = true;
    late ResponseModel responseModel;
    try {
      final url = Uri.parse("https://doctormap.onrender.com/api/Auth/login");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': Appconsts.cookie,
          'User-Agent': Appconsts.useragent,
        },
        body: convert.jsonEncode({
          'Email': email,
          'password': password,
        }),
      );
      Map<String, dynamic> data = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
if (response.statusCode == 200) {
  responseModel = ResponseModel(true, 'login_success'.tr);
  
  String userIdFromToken = _extractUserId(data["token"]);
  userId.value = userIdFromToken;
  
  await storage.write(key: 'access_token', value: data["token"]);
  await storage.write(key: 'user_id', value: userIdFromToken); 
}

} else {
  responseModel = ResponseModel(false, 'login_failed'.tr);
}

    } on Exception catch (error) {
      debugPrint(error.toString()); 
      responseModel = ResponseModel(
        false,
        'Failed! check your internet connection please !',
      );
    }
    isLoading.value = false;
    return responseModel;
  }

  Future<ResponseModel> register(
    String name,
    String email,
    String password,
) async {
  isLoading.value = true;
  late ResponseModel responseModel;
  final url = Uri.parse('https://doctormap.onrender.com/api/Auth/register');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': Appconsts.cookie,
        'User-Agent': Appconsts.useragent,
      },
      body: convert.jsonEncode({
        'username': name,
        'email': email,
        'password': password,
      }),
    );

    responseModel = _handleRegisterResponse(response);
  } catch (error) {
    responseModel = ResponseModel(false, 'network_error'.tr);
  }

  isLoading.value = false;
  return responseModel;
}


  Future<ResponseModel> logout() async {
    late ResponseModel responseModel;
    var url = Uri.http(Appconsts.appUri, Appconsts.logout);
    final token = await storage.read(key: 'access_token');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Cookie': Appconsts.cookie,
        'User-Agent': Appconsts.useragent,
      },
    );
    Map<String, dynamic> data = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, data["message"]);
    } else {
      responseModel = ResponseModel(false, data["message"]);
    }
    return responseModel;
  }

 Future<bool> checkLoginStatus() async {
  try {
    final token = await storage.read(key: 'access_token');
    final storedUserId = await storage.read(key: 'user_id');
    
    if (token == null || JwtDecoder.isExpired(token)) {
      isLoggedIn.value = false;
      return false;
    }
    
    isLoggedIn.value = true;
    userId.value = storedUserId ?? ""; 
    return true;
  } catch (e) {
    isLoggedIn.value = false;
    return false;
  }
}


  Future<void> clearAccessToken() async {
    await storage.delete(key: 'access_token');
    isLoggedIn.value = false;
  }

  
  Future<ResponseModel> authGoogleSignIn() async {
    late ResponseModel responseModel;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        responseModel = ResponseModel(false, "Google sign-in cancelled");
        isLoading.value = false;
        return responseModel;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      String? idToken = googleAuth.idToken;
      if (idToken == null) {
        responseModel = ResponseModel(false, "Failed! please try again");
        isLoading.value = false;
        return responseModel;
      }
      final url = Uri.parse('https://doctormap.onrender.com/api/Auth/google');
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode({'idToken': idToken}),
      );
      Map<String, dynamic> data = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, "Google sign-in successful");
        String userIdFromToken = _extractUserId(data["token"]);
        userId.value = userIdFromToken;

        await storage.write(key: 'access_token', value: data["token"]);
        await storage.write(key: 'user_id', value: userIdFromToken); 
      } else {
        responseModel = ResponseModel(false, "Google sign-in failed");
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print("Error during Google Sign-In: $error");
        print("Stack trace: $stackTrace");
      }
      responseModel = ResponseModel(false, "$error");
    }
    return responseModel;
  }

    Future<String?> getUserId() async {
    try {
      final token = await storage.read(key: 'access_token');
      _validateToken(token);
            userId.value = _extractUserId(token!);

      return _extractUserId(token);
    } catch (e) {
      _handleAuthError(e);
      userId.value = "";
      return null;
    }
  }

 

    String _extractUserId(String token) {
    final decoded = JwtDecoder.decode(token);
    final userId = decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
    
    if (userId == null || userId.isEmpty) {
      clearAccessToken();
      Get.defaultDialog(
        title: 'Error'.tr,
        middleText: 'session_expired'.tr,
        confirmTextColor: Colors.white,
        buttonColor: Colors.blue,
        );
        Get.offNamed(RouteHelper.signIn);
      
    }
    
    return userId;
  }
  

   Future<void> _validateToken(String? token) async {
    if (token == null) {
      throw Exception('No authentication token found');
    }
    
    if (JwtDecoder.isExpired(token)) {
      await clearAccessToken();
      Get.defaultDialog(
        title: 'Error'.tr,
        middleText: 'session_expired'.tr,
        confirmTextColor: Colors.white,
        buttonColor: Colors.blue,
        );
        Get.offNamed(RouteHelper.signIn);
    }
  }
  ResponseModel _handleRegisterResponse(http.Response response) {
  if (response.statusCode == 200) {
    return ResponseModel(true, 'register_success'.tr);
  }

  dynamic decodedJson = convert.jsonDecode(response.body);
  String errorMessage;

  if (decodedJson is List) {
    errorMessage = decodedJson.map((e) => e["description"]).join("; ");
  } else if (decodedJson is Map<String, dynamic>) {
    errorMessage = decodedJson["message"] ?? 'register_failed'.tr;
  } else {
    errorMessage = 'unknown_error'.tr;
  }

  return ResponseModel(false, errorMessage);
}

   void _handleAuthError(dynamic error) {
  String message;

  if (error.toString().contains('expired')) {
    message = 'session_expired'.tr;
    clearAccessToken();
    Get.offAllNamed(RouteHelper.getSignIn());
  } else if (error.toString().contains('authentication')) {
    message = 'unauthorized'.tr;
    clearAccessToken();
    Get.offAllNamed(RouteHelper.getSignIn());
  } else if (error.toString().contains('network')) {
    message = 'network_error'.tr;
  } else {
    message = 'unknown_error'.tr;
  }

  Get.snackbar(
    'Error'.tr,
    message,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 3),
  );
}

Future<void> handleTokenExpiry() async {
  final token = await storage.read(key: 'access_token');
  if (token != null && JwtDecoder.isExpired(token)) {
    await clearAccessToken();
    Get.offAllNamed(RouteHelper.getSignIn());
  }
}

  

}
