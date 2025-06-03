import 'package:charts_application/helper/route_helper.dart';
import 'package:charts_application/models/reviews_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_application/constants/app_consts.dart';
import 'package:charts_application/controllers/auth_controller.dart';

class ReviewController extends GetxController {
  var reviews = <ReviewModel>[].obs;
  var averageRating = 0.0.obs;
  var isLoading = false.obs;

  final AuthController _authController = Get.find<AuthController>();

 void clearReviews() => reviews.clear();
  Future<void> getReviews(int medicalCenterId) async 
  {
    final userId = await _authController.getUserId();
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse("https://doctormap.onrender.com/api/Review/GetReviewsByMedicalCenter/$medicalCenterId?UserId=$userId"),
        headers: {
          "User-Agent": Appconsts.useragent
          },
      );

      if (response.statusCode == 200) 
      {
        final List<dynamic> data = jsonDecode(response.body);
        reviews.assignAll(data.map((json) => ReviewModel.fromJson(json)).toList());
      } else {
        throw Exception("Failed to load reviews (Status ${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAverageRating(int medicalCenterId) async {

    try {
      final response = await http.get(
        Uri.parse("https://doctormap.onrender.com/api/Review/GetAverageRating/$medicalCenterId"),
        headers: {
          "User-Agent": Appconsts.useragent
          },
      );

      if (response.statusCode == 200) {
        averageRating.value = double.parse(response.body);
      } else {
        throw Exception("Failed to fetch average rating.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> addReview(int medicalCenterId, int rating, String comment) async 
  {
    try {
      final userId = await _authController.getUserId();
      final token = await _authController.storage.read(key: "access_token");

      if (userId == null || token == null) throw Exception("Login required.");

      final response = await http.post(
        Uri.parse("https://doctormap.onrender.com/api/Review/AddReview"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "User-Agent": Appconsts.useragent,
        },
        body: jsonEncode({
          "userId": userId,
          "medicalCenterId": medicalCenterId,
          "rating": rating,
          "comment": comment,
        }),
      );

      if (response.statusCode == 200) 
      {
        getReviews(medicalCenterId); 
        getAverageRating(medicalCenterId); 
        
      } else {
       Get.snackbar("failed", response.body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> updateReview(int reviewId, int rating, String comment,int medicalCenterId) async {
    try {
      final userId = await _authController.getUserId();
      final token = await _authController.storage.read(key: "access_token");
      if (token == null) 
      {
        Get.offNamed(RouteHelper.getSignIn());
      }

      final response = await http.post(
        Uri.parse("https://doctormap.onrender.com/api/Review/UpdateReview"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "User-Agent": Appconsts.useragent,
        },
        body: jsonEncode({
          "reviewId" : reviewId,
           "userId" : userId,
          "rating": rating,
          "comment": comment,
        }),
       
      );



      if (response.statusCode == 200) {
        reviews[reviews.indexWhere((r) => r.id == reviewId)] ;
        getReviews(medicalCenterId);
        getAverageRating(medicalCenterId);
      } else {
        Get.snackbar("Failed", response.body);
              }
    } catch (e) {
      Get.snackbar("Failed", e.toString());
    }
  }

  Future<void> deleteReview(int reviewId, int medicalCenterId, String userReviewId) async {
  try {
    final token = await _authController.storage.read(key: "access_token");
    final userId = await _authController.getUserId();

    if (token == null) {
      Get.offNamed(RouteHelper.getSignIn());
      return;
    }

    if (userId.toString() != userReviewId) {
      Get.snackbar("Unauthorized", "You can only delete your own reviews!");
      return;
    }

    final response = await http.delete(
      Uri.parse("https://doctormap.onrender.com/api/Review/DeleteReview?id=$reviewId&userId=$userId"),
      headers: {
        "Authorization": "Bearer $token",
        "User-Agent": Appconsts.useragent,
      },
    );

    if (response.statusCode == 200) {
      reviews.removeWhere((r) => r.id == reviewId);
      reviews.refresh();
      getAverageRating(medicalCenterId);
    } else {
      Get.snackbar("Failed", response.body);
    }
  } catch (e) {
    Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
  }
}
}
