import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/postcontroller.dart';
import 'package:charts_application/models/Post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'posts_skeleton.dart';

class MedicalCenterPostsPage extends StatefulWidget {
  final int centerId;

  const MedicalCenterPostsPage({super.key, required this.centerId});

  @override
  _MedicalCenterPostsPageState createState() => _MedicalCenterPostsPageState();
}

class _MedicalCenterPostsPageState extends State<MedicalCenterPostsPage> {
  final postController = Get.put(PostController());

  @override
  void initState() {
    super.initState();
    postController.fetchPosts(widget.centerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Center Posts')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (postController.isLoading.value) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) => const PostsSkeleton(),
                );
              }
            
              if (postController.posts.isEmpty) {
                return const Center(child: Text("No posts available"));
              }
            
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: false, 
                cacheExtent: 300,
                itemCount: postController.posts.length,
                itemBuilder: (context, index) {
                  Post post = postController.posts[index];
                  return _buildPostItem(post, context);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem(Post post, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20(context),
        vertical: Dimensions.width10(context) / 1.5,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.width10(context) / 1.2,
        vertical: Dimensions.width10(context),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // User Info Section
          Row(
            children: [
              CircleAvatar(
                radius: Dimensions.width30(context),
                backgroundImage: post.medicalCenter.logoImageUrl.isNotEmpty
                    ? NetworkImage("https://doctormap.onrender.com${post.medicalCenter.logoImageUrl}")
                    : null,
                backgroundColor: Colors.grey.shade300,
              ),
              SizedBox(width: Dimensions.width10(context)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.medicalCenter.medicalCentersName, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(post.createdAt.toString(), style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const Divider(),

          // Post Text Section
          Align(
              alignment: Alignment.topLeft,
            child: Text(post.text, style: TextStyle(fontSize: Dimensions.font20(context) / 2 + 5))),
          SizedBox(height: Dimensions.width10(context) / 4),

          // Post Image Section (if available)
          post.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                  child: Image.network("https://doctormap.onrender.com${post.imageUrl}", fit: BoxFit.contain),
                )
              : const SizedBox(),

          SizedBox(height: Dimensions.height20(context)),

          // Likes & Comments Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${post.likesCount} likes"),
              Text("${post.commentsCount} comments"),
            ],
          ),
          const Divider(),

          // Action Buttons (Like & Comment)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {}, // 🔥 Functionality will be added later
                child: Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      color: post.isLiked ? Colors.blue : Colors.grey,
                    ),
                    SizedBox(width: Dimensions.width10(context)/2),
                                  Text(post.isLiked ? "Liked" : "Like"),

                  ],
                ),
              ),
              GestureDetector(
                onTap: () {}, // 🔥 Functionality will be added later
                child: Row(
                  children: [
                    const Icon(Icons.messenger_outline, color: Colors.grey),
                    SizedBox(width: Dimensions.width10(context)/2),
                    const Text("Comment"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
