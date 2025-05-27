import 'dart:convert';
import 'package:charts_application/controllers/auth_controller.dart';
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
      final userId = await _authController.getUserId();
      final token = await _authController.storage.read(key: 'access_token');

      if (userId == null || token == null) {
        throw Exception("User is not authenticated.");
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
        throw Exception("Failed to fetch posts. Status code: ${response.statusCode}");
      }
    } catch (error) {
      Get.snackbar("Error", error.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }
}


  // Future<void> toggleLike(int postId) async {
  //   final token = await storage.read(key: 'access_token');

  //   final post = posts.firstWhere((post) => post.id == postId);
  //   post.hasLiked = !post.hasLiked;
  //   post.hasLiked ? post.likesCount++ : post.likesCount--;
  //   update();

  //   try {
  //     var url = Uri.http(Appconsts.appUri, '/api/apiPosts/like/$postId');
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //         'Cookie': Appconsts.cookie,
  //         'User-Agent': Appconsts.useragent,
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final data = convert.jsonDecode(response.body);
  //       post.hasLiked = data['liked'];
  //       post.likesCount = data['likes_count'];
  //     } else {
  //       post.hasLiked = !post.hasLiked;
  //       post.hasLiked ? post.likesCount++ : post.likesCount--;
  //     }
  //   } catch (e) {
  //     post.hasLiked = !post.hasLiked;
  //     post.hasLiked ? post.likesCount++ : post.likesCount--;
  //   }

  //   update();
  // }

  


