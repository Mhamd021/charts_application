import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/commentcontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentnotFavoriteInputField extends StatefulWidget {
  final int postId;

  const CommentnotFavoriteInputField({super.key, required this.postId});

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentnotFavoriteInputField> {
  final TextEditingController textController = TextEditingController();
  final Commentcontroller controller = Get.find<Commentcontroller>();
  bool isTyping = false;
  bool isSending = false; // New state for sending animation

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      bool hasText = textController.text.trim().isNotEmpty;
      if (hasText != isTyping) {
        setState(() {
          isTyping = hasText;
        });
      }
    });
  }

  void _sendComment() async {
    if (!isTyping) return;
    
    setState(() => isSending = true);
    
    await controller.addCommentnotFavorite(widget.postId, textController.text);
    textController.clear();

    // Wait a bit before resetting animation
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() => isSending = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(vertical: Dimensions.height10(context)-2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "Write a comment...".tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:  EdgeInsets.symmetric(horizontal: Dimensions.width15(context)+1),
              ),
            ),
          ),
           SizedBox(width: Dimensions.width10(context)-2),

          // Animated Send Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: GestureDetector(
              onTap: _sendComment,
              child: isSending
                  ?  SizedBox(
                      height: Dimensions.height30(context),
                      width: Dimensions.width20(context),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    )
                  : Icon(
                    //Icons.near_me
                      CupertinoIcons.paperplane_fill,
                      key: ValueKey(isTyping),
                      color: isTyping ? Colors.blue : Colors.grey,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
