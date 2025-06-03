import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/controllers/commentcontroller.dart';
import 'package:charts_application/models/Comment.dart';
import 'package:charts_application/pages/posts/comment_input_field.dart';
import 'package:charts_application/pages/posts/comments_skeleton.dart';
import 'package:charts_application/widgets/animated_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CommentButton extends StatelessWidget {
  final int postId;
const   CommentButton({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Row(
        children: [
          const Icon(Icons.messenger_outline, color: Colors.grey),
          const SizedBox(width: 4),
          Text('Comment'),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 20),
            Expanded(child: _buildCommentList()),
            CommentInputField(postId: postId)
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Comments",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          itemBuilder: (context, index) => CommentItem(
            comment: controller.comments[index],
            onDelete: ()=> 
            controller.removeComment(postId,controller.comments[index].commentId),
         
          ),
        );
      },
    );
  }

  
}

class CommentItem extends StatelessWidget {
  
  final Comment comment;
  final VoidCallback onDelete;

  const CommentItem({
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



