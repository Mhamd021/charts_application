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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "Write a comment...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Animated Send Button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: GestureDetector(
              onTap: _sendComment,
              child: isSending
                  ? const SizedBox(
                      height: 30,
                      width: 30,
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
