import 'dart:convert' as convert;
import 'package:charts_application/constants/app_consts.dart';
import 'package:charts_application/models/response_model.dart';
import 'package:flutter/foundation.dart';
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
        responseModel = ResponseModel(true, response.body);
        await storage.write(key: 'access_token', value: data["token"]);
      } else {
        responseModel = ResponseModel(false, response.body);
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

      if (response.statusCode == 200) {
        // For success, our API returns plain text.
        String message;
        try {
          // Try to decode in case the backend sometimes sends JSON.
          var decoded = convert.jsonDecode(response.body);
          if (decoded is String) {
            message = decoded;
          } else if (decoded is Map<String, dynamic>) {
            message = decoded["message"] ?? "Registration successful";
          } else {
            message = "Registration successful";
          }
        } catch (e) {
          // If decoding fails, treat the body as plain text.
          message = response.body;
        }
        responseModel = ResponseModel(true, message);
      } else {
        dynamic decodedJson = convert.jsonDecode(response.body);
        if (decodedJson is List) {
          String errorMessage = decodedJson
              .map((errorObj) => errorObj["description"])
              .toList()
              .join("; ");
          responseModel = ResponseModel(false, errorMessage);
        } else if (decodedJson is Map<String, dynamic>) {
          String errorMessage = decodedJson["message"] ?? response.body;
          responseModel = ResponseModel(false, errorMessage);
        } else {
          responseModel = ResponseModel(false, response.body);
        }
      }
    } catch (error) {
      responseModel = ResponseModel(false, '$error');
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
      if (token == null) {
        isLoggedIn.value = false;
        return false;
      }
      isLoggedIn.value = !JwtDecoder.isExpired(token);
      return isLoggedIn.value;
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
        await storage.write(key: 'access_token', value: data["token"]);
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
      return _extractUserId(token!);
    } catch (e) {
      _handleAuthError(e);
      return null;
    }
  }

    String _extractUserId(String token) {
    final decoded = JwtDecoder.decode(token);
    final userId = decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
    
    if (userId == null || userId.isEmpty) {
      throw FormatException('Invalid token structure - missing user ID');
    }
    
    return userId;
  }

   Future<void> _validateToken(String? token) async {
    if (token == null) {
      throw Exception('No authentication token found');
    }
    
    if (JwtDecoder.isExpired(token)) {
      await clearAccessToken();
      throw Exception('Session expired - please login again');
    }
  }
   void _handleAuthError(dynamic error) {
    Get.snackbar(
      'Authentication Error',
      error.toString(),
      snackPosition: SnackPosition.TOP,
    );
    if (error is Exception && error.toString().contains('expired')) {
      clearAccessToken();
    }
  }

  

}
