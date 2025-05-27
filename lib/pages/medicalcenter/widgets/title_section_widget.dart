import 'package:flutter/material.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/models/medical_center_details_model.dart';

class TitleSectionWidget extends StatelessWidget {
  final MedicalCenterDetailsModel medicalCenter;

  const TitleSectionWidget({super.key, required this.medicalCenter});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Column(
        children: [
          Text(
            medicalCenter.medicalCentersName ?? "Medical Center",
            style: TextStyle(
              fontSize: Dimensions.font26(context) + 2,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: Dimensions.height10(context) - 2),
          Chip(
            backgroundColor: Colors.blue[50],
            label: Text(
              medicalCenter.category ?? "General",
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
