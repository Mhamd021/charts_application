import 'package:flutter/material.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/models/medical_center_details_model.dart';

class HeroHeaderWidget extends StatelessWidget {
  final MedicalCenterDetailsModel medicalCenter;

  const HeroHeaderWidget({super.key, required this.medicalCenter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.height10(context) * 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover image
          Hero(
            tag: "medicalCenter_${medicalCenter.medicalCentersId}",
            child: SizedBox(
              height: Dimensions.height10(context) * 28,
              width: double.infinity,
              child: medicalCenter.coverImageUrl != null
                  ? Image.network(
                      "https://doctormap.onrender.com${medicalCenter.coverImageUrl}",
                      fit: BoxFit.cover,
                    )
                  : Container(color: Colors.grey[300]),
            ),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              ),
            ),
          ),

          // Positioned logo
          Positioned(
            bottom: -Dimensions.height30(context) * 2,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: Dimensions.width15(context) * 10,
                height: Dimensions.height15(context) * 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: medicalCenter.logoImageUrl != null
                      ? Image.network(
                          "https://doctormap.onrender.com${medicalCenter.logoImageUrl}",
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.medical_services,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
