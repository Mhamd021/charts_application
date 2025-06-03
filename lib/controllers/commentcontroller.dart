
import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/controllers/favorite_controller.dart';
import 'package:charts_application/models/Comment.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class Commentcontroller extends GetxController {
   final AuthController _authController = Get.find<AuthController>();
  RxList<Comment> comments = <Comment>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchComments(int postId) async {
  try {
    isLoading.value = true;
    final token = await _authController.storage.read(key: "access_token");

    if (token == null) {
      Get.snackbar("Error", "User authentication failed");
      Get.offNamed("/signin");
      return;
    }

    final response = await http.get(
      Uri.parse("https://doctormap.onrender.com/api/Posts/GetCommentsByPostId?postId=$postId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List<dynamic> data = convert.jsonDecode(response.body);
      if (data.isNotEmpty) {
        comments.assignAll(Comment.fromJsonList(data)); 
        comments.refresh();
      } else {
        comments.clear(); 
      }
    } else {
      Get.snackbar("Error", "Failed to fetch comments: ${response.statusCode}");
    }
  } catch (e) {
    Get.snackbar("Failed", "Error fetching comments: $e");
  } finally {
    isLoading.value = false;
  }
  update();
}



Future<void>addComment(int postId, String commentText) async 
{
     try
    {
  isLoading.value = true;
  final userId = await _authController.getUserId();
    final token = await _authController.storage.read(key: "access_token");
    if(token == null || token.isEmpty)
    {
      Get.snackbar("Error", "User authentication failed");
      Get.offNamed("/signin");
      return;
    }
    final favController = Get.find<FavoriteController>();
      final postIndex = favController.favoritePosts.indexWhere(
        (p) => p.postId == postId);
      
      if (postIndex == -1) return;

    final response = await http.post(
     Uri.parse("https://doctormap.onrender.com/api/Posts/AddComment"),
     headers: 
     {
      "Content-Type" :'application/json'
     },
     body: convert.jsonEncode({
        "postId" : postId ,
        "commentText" : commentText,
        "userId" :  userId,
     }),

    );

    if(response.statusCode == 200)
    {
      final int newCount = int.parse(response.body);
        favController.favoritePosts[postIndex].commentsCount.value = newCount;
     await fetchComments(postId);
    }
    else
    {
        Get.snackbar("Error", "Failed to add comment");
    }

    } catch(e)
    {
      Get.snackbar("Failed", e.toString());
      
      Get.snackbar("Error", "Error adding comment: $e");
    } finally
    {
      isLoading.value = false;
    }
  
}

Future removeComment(int postId,int commmentId) async
{
    
    try
    {
  isLoading.value = true;
  final userId = await _authController.getUserId();
    final token = await _authController.storage.read(key: "access_token");
    if(token == null || token.isEmpty)
    {
      Get.snackbar("Error", "User authentication failed");
      Get.offNamed("/signin");
      return;
    }

    final favController = Get.find<FavoriteController>();
      final postIndex = favController.favoritePosts.indexWhere(
        (p) => p.postId == postId);
      
      if (postIndex == -1) return;

    final response = await http.post(
     Uri.parse("https://doctormap.onrender.com/api/Posts/DeleteComment"),
     headers: 
     {
      "Content-Type" :'application/json'

     },
     body: convert.jsonEncode({
        "commentId" : commmentId,
        "postId" : postId ,
        "userId" :  userId,
     }),

    );

    if(response.statusCode == 200)
    {
      final int newCount = int.parse(response.body);
        favController.favoritePosts[postIndex].commentsCount.value = newCount;
          await fetchComments(postId);
    }
    else
    {
      Get.snackbar("Failed", response.body);
    }

    } catch(e)
    {
      Get.snackbar("Failed", e.toString());
    } finally
    {
      isLoading.value = false;
    }
}

}