import 'dart:math' as math;

import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/models/reviews_model.dart';
import 'package:charts_application/pages/medicalcenter/widgets/shadow_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/reviewscontroller.dart';
import 'package:shimmer/shimmer.dart';

class ReviewsSectionWidget extends StatelessWidget {
  final int _visibleReviewsCount = 3;
  final RxInt _expandedReviews = 0.obs;
  final TextEditingController _commentController = TextEditingController();
  final RxInt _selectedRating = 0.obs;
  final RxBool _isEditing = false.obs;
  final RxInt _editingReviewId = (-1).obs;
  final int medicalCenterId;
  final ReviewController reviewController = Get.put(ReviewController());
  final AuthController authController = Get.find<AuthController>();
  

  ReviewsSectionWidget({super.key, required this.medicalCenterId});

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if (reviewController.isLoading.value) {
        return _buildSkeletonLoader(context); 
      }

      if (reviewController.reviews.isEmpty) 
      {
        return ShadowedContainerWidget(
          child:  Center(
            child: Padding(
              padding:  EdgeInsets.all(Dimensions.width10(context)-2),
              child: GestureDetector(
                onTap: () 
                {
                  _showReviewDialog(context);
                },
                child: Text(
                  "No reviews yet.click and be the first to leave one!".tr,
                  style: TextStyle
                  (
                    color: Colors.blue
                  ),
                  
                  ),
              ),
            ),
          ),
        );
      }
      
      return ShadowedContainerWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
           Text("User Reviews".tr, style: TextStyle(fontSize: Dimensions.font16(context) + 2, fontWeight: FontWeight.bold)),
        _buildAddReviewButton(context),
      ],
    ),
    SizedBox(height: Dimensions.height12(context)),
     Obx(() => Column(
      children: [
        ...reviewController.reviews
          .sublist(0, _expandedReviews.value > 0 
            ? reviewController.reviews.length 
            : _effectiveVisibleCount)
          .map((review) => _buildReviewCard(review, context)),
        if (reviewController.reviews.length > _visibleReviewsCount )
          TextButton(
          onPressed: () => _expandedReviews.value = _expandedReviews.value > 0 
          ? 0 
          : reviewController.reviews.length,
                child: Text(_expandedReviews.value > 0 
              ? "Show Less".tr 
              : "Show More (${reviewController.reviews.length - _visibleReviewsCount})".tr),
        ),
      ],
    )
    ),
          ],
        ),
      );
    });
  }

      Widget _buildAddReviewButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'addReview_$medicalCenterId',
      mini: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onPressed: () => _showReviewDialog(context),
      child: Icon(Icons.add_comment_rounded, size: Dimensions.font16(context)),
    );
  }

 Widget _buildReviewCard(ReviewModel review,BuildContext context) {
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.height10(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Dimensions.width10(context)*4,
                    height: Dimensions.height10(context)*4,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getUserInitials(review.userName),
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        )
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width15(context)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Name and Rating
                        Row(
                          children: [
                            Expanded(
                              child: Text(review.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Dimensions.font16(context)
                                )),
                            ),
                            _buildStarRating(review.rating,context),
                            SizedBox(width: Dimensions.width10(context)-2),
                            Text("${review.rating}.0",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: Dimensions.font16(context)-2
                              )),
                          ],
                        ),
                        
                        // Review Date
                        Padding(
                          padding: EdgeInsets.only(top: Dimensions.width10(context)-6),
                          child: Text(
                            _formatDate(review.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: Dimensions.font16(context)-4
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            
      Visibility(
        visible: review.userId == authController.userId.value,
        child: PopupMenuButton(
                            itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Edit".tr),
          onTap: () => _showReviewDialog(context, existingReview: review),
        ),
        
        
        PopupMenuItem(
          child: Text("Delete".tr),
          onTap: () => reviewController.deleteReview(review.id, medicalCenterId, review.userId),
        ),
            ],
            ),
      ),
    
    ] ,
              ),
              
              // Review Comment
              Padding(
                padding: EdgeInsets.only(
                  left: Dimensions.width10(context)*10 +Dimensions.width10(context)/2, 
                  top: Dimensions.height10(context),
                ),
                child: Text(review.comment,
                  style: TextStyle(
                    color: Colors.blueGrey[700],
                    height: 1.4
                  )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildStarRating(int rating,BuildContext context) {
    return Row(
      children: List.generate(5, (index) => Icon(
        Icons.star,
        color: index < rating ? Colors.amber : Colors.grey.shade300,
        size: Dimensions.iconSize16(context),
      )),
    );
  }
//  void _showReviewDialog(BuildContext context, {ReviewModel? existingReview}) {
//     if (existingReview != null) {
//       _commentController.text = existingReview.comment;
//       _selectedRating.value = existingReview.rating;
//       _editingReviewId.value = existingReview.id;
//       _isEditing.value = true;
//     }
    
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(_isEditing.value ? "Edit Review" : "Add Review"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Obx(() => Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (index) => IconButton(
//                 icon: Icon(Icons.star,
//                   color: index < _selectedRating.value ? Colors.amber : Colors.grey,
//                   size: Dimensions.font16(context) + 8),
//                 onPressed: () => _selectedRating.value = index + 1,
//               )),
//             )),
//             SizedBox(height: Dimensions.height10(context)),
//             TextField(
//               controller: _commentController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 hintText: "Write your review...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (_selectedRating.value > 0) {
//                 if (_isEditing.value) {
//                   await reviewController.updateReview(
                    
//                     _editingReviewId.value,
//                     _selectedRating.value,
//                     _commentController.text,
//                     medicalCenterId
//                   );
//                 } else {
//                   await reviewController.addReview(
//                     medicalCenterId,
//                     _selectedRating.value,
//                     _commentController.text,
//                   );
//                 }
//                 _resetDialogState();
//                 Navigator.pop(context);
//               }
//             },
//             child: Text(_isEditing.value ? "Update" : "Submit"),
//           ),
//         ],
//       ),
//     );
//   }
void _showReviewDialog(BuildContext context, {ReviewModel? existingReview}) {
  if (existingReview != null) {
    _commentController.text = existingReview.comment;
    _selectedRating.value = existingReview.rating;
    _editingReviewId.value = existingReview.id;
    _isEditing.value = true;
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width15(context) + 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog Title
            Text(
              _isEditing.value ? "Edit Review".tr : "Add Review".tr,
              style: TextStyle(
                fontSize: Dimensions.font20(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Dimensions.height10(context)),

            // Star Rating Selection
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => IconButton(
                icon: Icon(Icons.star,
                    color: index < _selectedRating.value ? Colors.amber : Colors.grey,
                    size: Dimensions.font16(context) + 6),
                onPressed: () => _selectedRating.value = index + 1,
              )),
            )),
            SizedBox(height: Dimensions.height10(context)),

            // Comment Input
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write your review...".tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15(context) - 2),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height15(context)),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "cancel".tr,
                    style: TextStyle(color: Colors.red, fontSize: Dimensions.font16(context)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedRating.value > 0) {
                      if (_isEditing.value) {
                        await reviewController.updateReview(
                          _editingReviewId.value,
                          _selectedRating.value,
                          _commentController.text,
                          medicalCenterId,
                        );
                      } else {
                        await reviewController.addReview(
                          medicalCenterId,
                          _selectedRating.value,
                          _commentController.text,
                        );
                      }
                      _resetDialogState();
                      Get.back(); // Close the dialog
                    }
                  },
                  child: Text(
                    _isEditing.value ? "Update".tr : "submit".tr,
                    style: TextStyle(fontSize: Dimensions.font16(context)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    transitionCurve: Curves.easeInOut,
    transitionDuration: const Duration(milliseconds: 300),
    barrierColor: Colors.black.withOpacity(0.3),
  );
}

   void _resetDialogState() {
    _commentController.clear();
    _selectedRating.value = 0;
    _isEditing.value = false;
    _editingReviewId.value = -1;
  }

 Widget _buildSkeletonLoader(BuildContext context) {
  return ShadowedContainerWidget(
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(3, (index) => Padding(
          padding: EdgeInsets.all(Dimensions.height10(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: Dimensions.width10(context)*4,
                    height: Dimensions.height10(context)*4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: Dimensions.width15(context)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Dimensions.width10(context)*10,
                        height: Dimensions.height15(context)+1,
                        color: Colors.white,
                      ),
                      SizedBox(height: Dimensions.height12(context)/3),
                      Container(
                        width: Dimensions.width10(context)*8,
                        height: Dimensions.height12(context),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height10(context)),
              Container(
                width: double.infinity,
                height: Dimensions.height12(context)+2,
                color: Colors.white,
              ),
              SizedBox(height: Dimensions.height12(context)/3),
              Container(
                width: Dimensions.width10(context)*20,
                height: Dimensions.height12(context)+2,
                color: Colors.white,
              ),
            ],
          ),
        )),
      ),
    ),
  );
}

  String _getUserInitials(String name) => 
    name.isNotEmpty ? name.trim().split(' ').map((n) => n[0]).take(2).join() : '';

  String _formatDate(DateTime date) => 
    "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";

    int get _effectiveVisibleCount => 
    math.min(_visibleReviewsCount, reviewController.reviews.length);
}