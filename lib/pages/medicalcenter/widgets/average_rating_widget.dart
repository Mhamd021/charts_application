import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_application/controllers/reviewscontroller.dart';
import 'package:charts_application/constants/dimensions.dart';

class AverageRatingWidget extends StatelessWidget {
  final ReviewController reviewController;

  const AverageRatingWidget({super.key, required this.reviewController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Average Rating".tr, style: TextStyle(fontSize: Dimensions.iconSize16(context), fontWeight: FontWeight.bold)),
            SizedBox(height: Dimensions.height10(context)),
            reviewController.averageRating.value > 0
                ? Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: Dimensions.iconSize24(context)),
                      SizedBox(width: Dimensions.width10(context)/2),
                      Text(
                        reviewController.averageRating.value.toStringAsFixed(1),
                        style:  TextStyle(fontSize: Dimensions.font16(context), fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                :  Text("No ratings yet".tr, style: TextStyle(fontSize: Dimensions.font16(context), fontWeight: FontWeight.w400)),
          ],
        ));
  }
}
