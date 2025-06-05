import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/controllers/favorite_controller.dart';
import 'package:charts_application/controllers/postcontroller.dart';
import 'package:charts_application/helper/route_helper.dart';
import 'package:charts_application/models/Comment.dart';
import 'package:flutter/material.dart';
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

      final userId = _authController.userId.value;
      final token = await _authController.storage.read(key: 'access_token');

      if (userId.isEmpty || token == null) {
        Get.defaultDialog(
          title: 'Error'.tr,
          middleText: 'unauthorized'.tr,
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue,
        );
        Get.offNamed(RouteHelper.getSignIn());
        return;
      }

      final response = await http.get(
        Uri.parse(
          "https://doctormap.onrender.com/api/Posts/GetCommentsByPostId?postId=$postId",
        ),
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
        Get.snackbar(
          "Error".tr,
          "comment_fetch_failed".tr,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar("Failed", "Error fetching comments: $e");
    } finally {
      isLoading.value = false;
    }
    update();
  }

  Future<void> addComment(int postId, String commentText) async {
    try {
      isLoading.value = true;
      final userId = _authController.userId.value;
      final token = await _authController.storage.read(key: 'access_token');

      if (userId.isEmpty || token == null) {
        Get.defaultDialog(
          title: 'Error'.tr,
          middleText: 'unauthorized'.tr,
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue,
        );
        Get.offNamed(RouteHelper.getSignIn());
        return;
      }
      final favController = Get.find<FavoriteController>();
      final postIndex = favController.favoritePosts.indexWhere(
        (p) => p.postId == postId,
      );

      if (postIndex == -1) return;

      final response = await http.post(
        Uri.parse("https://doctormap.onrender.com/api/Posts/AddComment"),
        headers: {"Content-Type": 'application/json'},
        body: convert.jsonEncode({
          "postId": postId,
          "commentText": commentText,
          "userId": userId,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success".tr,
          "comment_add_success".tr,
          snackPosition: SnackPosition.TOP,
        );
        final int newCount = int.parse(response.body);
        favController.favoritePosts[postIndex].commentsCount.value = newCount;
        await fetchComments(postId);
      } else {
        Get.snackbar(
          "Error".tr,
          "comment_add_failed".tr,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Error adding comment: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future removeComment(int postId, int commmentId) async {
    try {
      isLoading.value = true;
      final userId = _authController.userId.value;
      final token = await _authController.storage.read(key: 'access_token');

      if (userId.isEmpty || token == null) {
        Get.defaultDialog(
          title: 'Error'.tr,
          middleText: 'unauthorized'.tr,
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue,
        );
        Get.offNamed(RouteHelper.getSignIn());
        return;
      }

      final favController = Get.find<FavoriteController>();
      final postIndex = favController.favoritePosts.indexWhere(
        (p) => p.postId == postId,
      );

      if (postIndex == -1) return;

      final response = await http.post(
        Uri.parse("https://doctormap.onrender.com/api/Posts/DeleteComment"),
        headers: {"Content-Type": 'application/json'},
        body: convert.jsonEncode({
          "commentId": commmentId,
          "postId": postId,
          "userId": userId,
        }),
      );

      if (response.statusCode == 200) {
        final int newCount = int.parse(response.body);
        favController.favoritePosts[postIndex].commentsCount.value = newCount;
        await fetchComments(postId);
        Get.snackbar(
          "Success".tr,
          "comment_delete_success".tr,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Error".tr,
          "comment_delete_failed".tr,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar("Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCommentnotFavorite(int postId, String commentText) async {
    try {
      isLoading.value = true;
      final userId = _authController.userId.value;
      final token = await _authController.storage.read(key: 'access_token');

      if (userId.isEmpty || token == null) {
        Get.defaultDialog(
          title: 'Error'.tr,
          middleText: 'unauthorized'.tr,
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue,
        );
        Get.offNamed(RouteHelper.getSignIn());
        return;
      }
      final postcontroller = Get.find<PostController>();
      final postIndex = postcontroller.posts.indexWhere((p) => p.id == postId);

      if (postIndex == -1) return;

      final response = await http.post(
        Uri.parse("https://doctormap.onrender.com/api/Posts/AddComment"),
        headers: {"Content-Type": 'application/json'},
        body: convert.jsonEncode({
          "postId": postId,
          "commentText": commentText,
          "userId": userId,
        }),
      );

      if (response.statusCode == 200) {
        final int newCount = int.parse(response.body);
        postcontroller.posts[postIndex].commentsCount.value = newCount;
        await fetchComments(postId);
        Get.snackbar(
          "Success".tr,
          "comment_add_success".tr,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Error".tr,
          "comment_add_failed".tr,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar("Failed", e.toString());

      Get.snackbar("Error", "Error adding comment: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future removeCommentnotFavorite(int postId, int commmentId) async {
    try {
      isLoading.value = true;
      final userId = _authController.userId.value;
      final token = await _authController.storage.read(key: 'access_token');

      if (userId.isEmpty || token == null) {
        Get.defaultDialog(
          title: 'Error'.tr,
          middleText: 'unauthorized'.tr,
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue,
        );
        Get.offNamed(RouteHelper.getSignIn());
        return;
      }

      final postcontroller = Get.find<PostController>();
      final postIndex = postcontroller.posts.indexWhere((p) => p.id == postId);

      if (postIndex == -1) return;

      final response = await http.post(
        Uri.parse("https://doctormap.onrender.com/api/Posts/DeleteComment"),
        headers: {"Content-Type": 'application/json'},
        body: convert.jsonEncode({
          "commentId": commmentId,
          "postId": postId,
          "userId": userId,
        }),
      );

      if (response.statusCode == 200) {
        final int newCount = int.parse(response.body);
        postcontroller.posts[postIndex].commentsCount.value = newCount;
        await fetchComments(postId);
        Get.snackbar(
          "Success".tr,
          "comment_delete_success".tr,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Error".tr,
          "comment_delete_failed".tr,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar("Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
