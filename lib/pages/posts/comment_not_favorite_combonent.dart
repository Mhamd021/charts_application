import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/controllers/commentcontroller.dart';
import 'package:charts_application/models/Comment.dart';
import 'package:charts_application/pages/posts/comment_not_favorite_input.dart';
import 'package:charts_application/pages/posts/comments_skeleton.dart';
import 'package:charts_application/widgets/animated_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CommentnotFavoriteButton extends StatelessWidget {
  final int postId;
const   CommentnotFavoriteButton({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Row(
        children: [
          const Icon(Icons.messenger_outline, color: Colors.grey),
           SizedBox(width: Dimensions.width12(context)/3),
          Text('comments'.tr),
        ],
      ),
      onPressed: () => _openCommentsDialog(context, postId),
    );
  }

  void _openCommentsDialog(BuildContext context, int postId) {
    final controller = Get.put(Commentcontroller());
    controller.fetchComments(postId);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommentDialog(postId: postId),
    );
  }
}

class CommentDialog extends StatelessWidget {
  final int postId;

  const CommentDialog({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding:  EdgeInsets.all(Dimensions.width12(context)+4),
        child: Column(
          children: [
            _buildHeader(context),
             Divider(height: Dimensions.height20(context)),
            Expanded(child: _buildCommentList()),
            CommentnotFavoriteInputField(postId: postId)
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text(
          "comments".tr,
          style: TextStyle(fontSize: Dimensions.font20(context), fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildCommentList() {
    return GetBuilder<Commentcontroller>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return const Center(child: CommentsSkeleton());
        }
        
        return ListView.builder(
          itemCount: controller.comments.length,
          itemBuilder: (context, index) => CommentnotFavoriteItem(
            comment: controller.comments[index],
            onDelete: ()=> 
            controller.removeCommentnotFavorite(postId,controller.comments[index].commentId),
         
          ),
        );
      },
    );
  }

  
}

class CommentnotFavoriteItem extends StatelessWidget {
  
  final Comment comment;
  final VoidCallback onDelete;

  const CommentnotFavoriteItem({
    super.key,
    required this.comment,
    required this.onDelete,
  });
                

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[200],
              child: Text(
                comment.userName.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.userName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.commentText,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            Visibility(
              visible: comment.userId == authController.userId.value,
              child: AnimatedDeleteIcon(onDelete: onDelete)
            ),
          ],
        ),
      ),
    );
  }
}



