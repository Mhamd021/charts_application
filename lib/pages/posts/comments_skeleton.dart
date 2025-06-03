import 'package:charts_application/constants/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommentsSkeleton extends StatelessWidget {
  const CommentsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height10(context),
        horizontal: Dimensions.width15(context),
      ),
      child: Column(
        children: List.generate(6, (index) => _buildSkeletonComment(context)), // Simulating 3 placeholder comments
      ),
    );
  }

  Widget _buildSkeletonComment(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Placeholder
            Container(
              width: Dimensions.width30(context),
              height: Dimensions.height30(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),

            // Name & Comment Placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Placeholder
                  Container(
                    width: Dimensions.width30(context) * 2,
                    height: Dimensions.height15(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Comment Text Placeholder
                  Container(
                    width: double.infinity,
                    height: Dimensions.height10(context) * 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
