import 'package:charts_application/constants/app_consts.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/favorite_controller.dart';
import 'package:charts_application/controllers/medicalmapcontroller.dart';
import 'package:charts_application/helper/image_helper.dart';
import 'package:charts_application/models/FavoritePosts_model.dart';
import 'package:charts_application/pages/medicalcenter/medical_center_details_page.dart';
import 'package:charts_application/pages/posts/center_loading_from_post_animation.dart';
import 'package:charts_application/pages/posts/comment_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'posts_skeleton.dart';

class FavoritePostsPage extends StatefulWidget {
  const FavoritePostsPage({super.key});

  @override
  _FavoritePostsPageState createState() => _FavoritePostsPageState();
}

class _FavoritePostsPageState extends State<FavoritePostsPage> {
  final FavoriteController favoriteController = Get.put(FavoriteController());
  final apiController = Get.find<MedicalMapController>();
  Future<void> _handleRefresh() async {
    await favoriteController.fetchFavoritePosts(); 
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _handleRefresh();   
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Favorite Posts'.tr)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return RefreshIndicator(
                onRefresh: _handleRefresh, 
                child: favoriteController.isLoading.value
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context, index) => const PostsSkeleton(),
                      )
                    : favoriteController.favoritePosts.isEmpty
                        ? Center(
                            child: GestureDetector(
                              onTap: _handleRefresh,
                              child:  Text("No favorite posts available, tap to refresh".tr),
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: false,
                            cacheExtent: 300,
                            itemCount: favoriteController.favoritePosts.length,
                            itemBuilder: (context, index) {
                              FavoritePost post = favoriteController.favoritePosts[index];
                              return _buildFavoritePostItem(post, context);
                            },
                          ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritePostItem(FavoritePost post, BuildContext context) {
      String imageUrl = ImageHelper.getValidImageUrl(post.imageUrl);
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
                  Text(post.medicalCenter.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(Appconsts.formatDate(post.publishedAt), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const Divider(),

          // Post Text Section
          Align(
            alignment: Alignment.topLeft,
            child: Text(post.content, style: TextStyle(fontSize: Dimensions.font20(context) / 2 + 5)),
          ),
          SizedBox(height: Dimensions.width10(context) / 4),

          // Post Image Section (if available)
           imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              )
            : const SizedBox(),

          SizedBox(height: Dimensions.height20(context)),

          // Likes & Comments Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text("${post.likesCount.value} likes".tr)),
              Obx(()=> Text("${post.commentsCount.value} comments".tr)),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
         GestureDetector(
  onTap: () => favoriteController.toggleLike(post.postId),
  child: Obx(() => Row(
    children: [
      Icon(
        post.isLikedByUser.value ? Icons.thumb_up : Icons.thumb_up_outlined,
        color: post.isLikedByUser.value ? Colors.blue : Colors.grey,
      ),
      SizedBox(width: Dimensions.width10(context) / 2),
      Text(post.isLikedByUser.value ? "Liked".tr : "Like".tr),
    ],
  )),
),
             CommentButton(
                  postId: post.postId,
                ),
                GestureDetector(
  onTap: () async {
    try {
      apiController.isFetchingDetails(true);

      // Check if cached data matches the requested center
      if (!apiController.cachedCentersDetails.containsKey(post.medicalCenter.medicalCenterId) ||
          apiController.selectedCenter.value?.medicalCentersId != post.medicalCenter.medicalCenterId) {
        
        await apiController.fetchMedicalCenterDetails(post.medicalCenter.medicalCenterId);
      }

      if (apiController.cachedCentersDetails.containsKey(post.medicalCenter.medicalCenterId)) {
        await Get.to(
          () => MedicalCenterDetailsPage(
            medicalCenter: apiController.cachedCentersDetails[post.medicalCenter.medicalCenterId]!,
          ),
          transition: Transition.fadeIn,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          fullscreenDialog: true,
          preventDuplicates: true,
          popGesture: false,
        );
      }
    } catch (e) {
      Get.snackbar("Error".tr, e.toString());
    } finally {
      apiController.isFetchingDetails(false);
    }
  },
  child: Obx(() => LoadingTransitionIcon(
        isLoading: apiController.isFetchingDetails.value,
        child: Row(
          children: [
            Icon(Icons.medical_services_outlined, color: Colors.grey),
            Text("Center Details".tr),
          ],
        ),
      )),
),

            ],
          ),
        ],
      ),
    );
  }


}
