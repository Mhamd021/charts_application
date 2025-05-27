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
            const Text("Average Rating", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: Dimensions.height10(context)),
            reviewController.averageRating.value > 0
                ? Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      SizedBox(width: 5),
                      Text(
                        reviewController.averageRating.value.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                : const Text("No ratings yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ],
        ));
  }
}
