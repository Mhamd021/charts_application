import 'dart:convert';
import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/helper/route_helper.dart';
import 'package:charts_application/models/Post.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PostController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  RxList<Post> posts = <Post>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchPosts(int centerId) async {
    try {
      isLoading.value = true;
      final userId = _authController.userId.value;
      final token = await _authController.storage.read(key: 'access_token');

      if (userId.isEmpty || token == null) {
        Get.snackbar("Error".tr, "unauthorized".tr, snackPosition: SnackPosition.TOP);
Get.offNamed(RouteHelper.getSignIn());
return;
      }

      final url = Uri.parse("https://doctormap.onrender.com/api/Posts/GetPostswithCenter/$centerId?UserId=$userId");
      
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        posts.value = Post.fromJsonList(jsonResponse);
      } else {
        Get.snackbar("Error".tr, "posts_fetch_failed".tr, snackPosition: SnackPosition.TOP);

      }
    } catch (error) {
      Get.snackbar("Error", error.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> toggleLike(int postId) async {
  final userId = _authController.userId.value;
final token = await _authController.storage.read(key: 'access_token');

if (userId.isEmpty || token == null) {
  Get.snackbar("Error".tr, "unauthorized".tr, snackPosition: SnackPosition.TOP);
  Get.offNamed(RouteHelper.getSignIn());
  return;
}
  int index = posts.indexWhere((post) => post.id == postId);
  if (index == -1) return;
  final post = posts[index];

  // 🔥 Optimistic UI update
  post.isLiked.value = !post.isLiked.value;
  post.likesCount.value += post.isLiked.value ? 1 : -1;
  
  try {
    final response = await http.post(
      Uri.parse("https://doctormap.onrender.com/api/Posts/${post.isLiked.value ? 'CreateNewLike' : 'RemoveLike'}"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'postId': post.id,
        'userId': await _authController.getUserId(),
      }),
    );
    if (response.statusCode == 200) {
      post.likesCount.value = int.parse(response.body);
    } else {
      // 🔄 Rollback if request fails
      post.isLiked.value = !post.isLiked.value;
      post.likesCount.value += post.isLiked.value ? 1 : -1;
      Get.snackbar("Error".tr, "like_update_failed".tr, snackPosition: SnackPosition.TOP);

    }
  } catch (e) {
    post.isLiked.value = !post.isLiked.value;
    post.likesCount.value += post.isLiked.value ? 1 : -1;
    Get.snackbar("Error", "Error updating like: $e");
  }
}


}


  

  


