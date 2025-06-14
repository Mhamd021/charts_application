import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/commentcontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentInputField extends StatefulWidget {
  final int postId;

  const CommentInputField({super.key, required this.postId});

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
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
    
    await controller.addComment(widget.postId, textController.text);
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                      height: Dimensions.height10(context)*3,
                      width: Dimensions.width10(context)*3,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    )
                  : Icon(
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
