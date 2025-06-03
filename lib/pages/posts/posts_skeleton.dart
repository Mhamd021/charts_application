import 'package:charts_application/constants/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostsSkeleton extends StatelessWidget {
  const PostsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.radius15(context)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        padding: EdgeInsets.all(Dimensions.radius15(context)),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  
                  Container(
                    width: Dimensions.width30(context) + Dimensions.width20(context),
                    height: Dimensions.height30(context) + Dimensions.height20(context),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: Dimensions.width10(context)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Placeholder with Rounded Corners
                      Container(
                        width: Dimensions.width30(context) * 4,
                        height: Dimensions.height15(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: Dimensions.height30(context) / 5),
                      // Timestamp Placeholder with Rounded Corners
                      Container(
                        width: Dimensions.width20(context) * 4,
                        height: Dimensions.height10(context) / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height10(context) + 2),
              const Divider(color: Colors.grey, thickness: 0.5),
              SizedBox(height: Dimensions.height10(context) + 2),

              // Post Text Placeholder
              Container(
                width: double.infinity,
                height: Dimensions.height15(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: Dimensions.height15(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Dimensions.height10(context) + 2),

              // Image Placeholder (if any)
              Container(
                width: double.infinity,
                height: Dimensions.height20(context) * 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20(context)),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Dimensions.height10(context) + 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Dimensions.width10(context) * 6,
                    height: Dimensions.height10(context) + 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: Dimensions.width10(context) * 6,
                    height: Dimensions.height10(context) + 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height10(context) + 2),

              const Divider(color: Colors.grey, thickness: 0.5),
              SizedBox(height: Dimensions.height10(context) + 2),

              // Actions Placeholder (Like, Comment, Share)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: Dimensions.width10(context) * 4,
                    height: Dimensions.height10(context) + 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: Dimensions.width10(context) * 6,
                    height: Dimensions.height10(context) + 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: Dimensions.width10(context) * 6,
                    height: Dimensions.height10(context) + 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
