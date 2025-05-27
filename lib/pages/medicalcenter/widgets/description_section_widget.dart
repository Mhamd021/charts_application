import 'package:charts_application/pages/medicalcenter/widgets/shadow_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/models/medical_center_details_model.dart';
import 'package:charts_application/pages/posts/medical_center_posts_page.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DescriptionSectionWidget extends StatelessWidget {
  final MedicalCenterDetailsModel medicalCenter;

  const DescriptionSectionWidget({super.key, required this.medicalCenter});

  @override
  Widget build(BuildContext context) {
    return ShadowedContainerWidget(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Dimensions.width10(context)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 4),
          borderRadius: BorderRadius.circular(Dimensions.radius20(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About Us",
              style: TextStyle(fontSize: Dimensions.font16(context) + 2, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: Dimensions.height15(context) - 3),
            Text(
              medicalCenter.medicalCentersDescription ?? "No description available",
              style: TextStyle(
                fontSize: Dimensions.font16(context),
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: Dimensions.height20(context)),

            // 🚀 Button to Navigate with Smooth Transition
            _buildPostsButton(context, medicalCenter.medicalCentersId),
          ],
        ),
      ),
    );
  }

  /// **Helper Method: Button to Navigate to Posts Page**
  Widget _buildPostsButton(BuildContext context, int? centerId) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuart,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (centerId != null) {
              HapticFeedback.lightImpact();
              Get.to(
                () => MedicalCenterPostsPage(centerId: centerId),
                transition: Transition.rightToLeftWithFade,
                duration: const Duration(milliseconds: 800),
                curve: Curves.fastEaseInToSlowEaseOut,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20(context) * 1.5,
              vertical: Dimensions.height15(context),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
            ),
            elevation: 0,
            foregroundColor: Colors.white.withOpacity(0.2),
            overlayColor: Colors.white10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.dynamic_feed, size: Dimensions.iconSize24(context), color: Colors.white),
              SizedBox(width: Dimensions.width10(context)),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: Dimensions.font16(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text("View Posts"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
