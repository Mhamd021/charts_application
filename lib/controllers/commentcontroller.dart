
import 'package:charts_application/constants/app_consts.dart';
import 'package:charts_application/models/Comment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' as convert;


class Commentcontroller extends GetxController {
  final storage = const FlutterSecureStorage();
  var comments = <Comment>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  Future<void> getpostcomments(int postId) async {
    final token = await storage.read(key: 'access_token');
    try {
      isLoading(true);
      var url = Uri.http(Appconsts.appUri, '/api/apiPosts/$postId/comments');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': Appconsts.cookie,
          'User-Agent': Appconsts.useragent,
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = convert.jsonDecode(response.body);
        final commentsJson = data['comments'] as List;

        comments.assignAll(commentsJson
            .map((commentJson) => Comment.fromJson(commentJson))
            .toList());
      } else {
        errorMessage('Failed to load posts');
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }

    update();
  }

//   Future<ResponseModel> createComment(Post post, String commentInfo) async {
//   var url = Uri.http(Appconsts.appUri, '/api/comments');
//   final token = await storage.read(key: 'access_token');
//   late ResponseModel responseModel;
//   try {
//     final response = await http.post(
//       url,
//       body: convert.jsonEncode({
//         'post_id': post.id,
//         'comment_info': commentInfo,
//       }),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Cookie': Appconsts.cookie,
//         'Content-Type': 'application/json',
//         'User-Agent': Appconsts.useragent,
//       },
//     );

//     if (response.headers['content-type']?.contains('application/json') ?? false) {
//       Map<String, dynamic> data = convert.jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         responseModel = ResponseModel(true, data['message']);
//        final postController = Get.find<Postcontroller>();
//           final updatedPost = postController.posts.firstWhere((p) => p.id == post.id);
//           updatedPost.commentsCount++;
//           postController.update();
//           getpostcomments(post.id);
//       } else {
//         responseModel = ResponseModel(false, data['message']);
//         if (data.containsKey('errors')) {
//           errorMessage(data['errors'].toString());
//         }
//       }
//     } else {
//       throw const FormatException('Invalid JSON response');
//     }
//   } catch (e) {
    
//     responseModel = ResponseModel(false, 'An error occurred');
//   }

//   return responseModel;
// }



}
