import 'dart:convert';
import 'package:charts_application/constants/app_consts.dart';
import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/models/FavoritePosts_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FavoriteController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  RxBool isFavorite = false.obs;
  RxBool isLoading = false.obs;
    RxList<FavoritePost> favoritePosts = <FavoritePost>[].obs;

  void playHapticFeedback() {
  HapticFeedback.lightImpact();
}

  Future<void> initializeFavoriteStatus(int medicalCenterId) async {
    try {
      final userId = await _authController.getUserId();
      final response = await http.get(
        Uri.parse('https://doctormap.onrender.com/api/Favorites/$userId'),
       headers: {
          'Content-Type': 'application/json',
          'Cookie': Appconsts.cookie,
          'User-Agent': Appconsts.useragent,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> favorites = json.decode(response.body);
        isFavorite.value = favorites.any((fav) => 
          fav['medicalCentersId'] == medicalCenterId);
      }
    } catch (e) {
      // Silent fail, will rely on optimistic updates
    }
  }

  Future<void> toggleFavorite(int medicalCenterId) async {
    playHapticFeedback();
    if (isLoading.value) return;
    isLoading.value = true;
    
    try {
      final previousState = isFavorite.value;
      final success = previousState
          ? await _removeFromFavorites(medicalCenterId)
          : await _addToFavorites(medicalCenterId);

      // Only update if server confirms
      if (success) {
        isFavorite.value = !previousState;
      } else {
        // Refresh actual state from server
        await initializeFavoriteStatus(medicalCenterId);
      }
    } finally {
      isLoading.value = false;
    }
  }

   Future<bool> _addToFavorites(int medicalCenterId) async {
    final userId =  _authController.userId.value;
    
    final response = await http.post(
      Uri.parse("https://doctormap.onrender.com/api/Favorites/Add"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "favorite" : 0,
        "userId": userId,
        "medicalCenterId": medicalCenterId  
      }),
    );
    Get.snackbar("Success", "added to favorites");
    fetchFavoritePosts();
    return response.statusCode == 200;
  }

  Future<bool> _removeFromFavorites(int medicalCenterId) async {
    final userId = await _authController.getUserId();
    final token = await _authController.storage.read(key: "access_token");
    
    final response = await http.delete(
      Uri.parse(
        "https://doctormap.onrender.com/api/Favorites/Remove"
        "?userId=$userId&medicalCenterId=$medicalCenterId"  
      ),
      headers: {"Authorization": "Bearer $token"},
    );
    Get.snackbar("Success", "removed from favorites"
    
    );
    return response.statusCode == 200;
  }


  Future<void> fetchFavoritePosts({int pageNumber = 1, int pageSize = 10}) async {
  try {
    isLoading.value = true;
    final userId = await _authController.getUserId();
    final token = await _authController.storage.read(key: "access_token");

    if (token == null || userId == null || userId.isEmpty) {
      Get.snackbar("Error", "User authentication failed");
      Get.offNamed("/signin"); 
      isLoading.value = false;
      return;
    }

    final response = await http.get(
      Uri.parse("https://doctormap.onrender.com/api/Favorites/GetFavorite/$userId?pageNumber=$pageNumber&pageSize=$pageSize"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body);
      if (data.containsKey('posts')) {
        List<FavoritePost> newFavoritePosts = (data['posts'] as List)
            .map((e) => FavoritePost.fromJson(e))
            .toList();

        if (newFavoritePosts.isNotEmpty) {
          favoritePosts.clear();
          favoritePosts.addAll(newFavoritePosts);
        }
      } else {
        Get.snackbar("Error", "Unexpected response structure");
      }
    } else {
      Get.snackbar("Error", "Failed to fetch favorite posts");
    }
  } catch (e) {
    Get.snackbar("Failed", "Error fetching favorite posts: $e");
  } finally {
    isLoading.value = false;
  }
}

Future<void> toggleLike(int postId) async {
  final token = await _authController.storage.read(key: 'access_token');
  int index = favoritePosts.indexWhere((post) => post.postId == postId);
  if (index == -1) return;
  playHapticFeedback();
  final post = favoritePosts[index];

  // 🔥 Optimistic UI update
  post.isLikedByUser.value = !post.isLikedByUser.value;
  post.likesCount.value += post.isLikedByUser.value ? 1 : -1;
  
  try {
    final response = await http.post(
      Uri.parse("https://doctormap.onrender.com/api/Posts/${post.isLikedByUser.value ? 'CreateNewLike' : 'RemoveLike'}"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'postId': post.postId,
        'userId': await _authController.getUserId(),
      }),
    );
    if (response.statusCode == 200) {
      post.likesCount.value = int.parse(response.body);
    } else {
      // 🔄 Rollback if request fails
      post.isLikedByUser.value = !post.isLikedByUser.value;
      post.likesCount.value += post.isLikedByUser.value ? 1 : -1;
      Get.snackbar("Error", "Failed to update like status");
    }
  } catch (e) {
    post.isLikedByUser.value = !post.isLikedByUser.value;
    post.likesCount.value += post.isLikedByUser.value ? 1 : -1;
    Get.snackbar("Error", "Error updating like: $e");
  }
}



}

