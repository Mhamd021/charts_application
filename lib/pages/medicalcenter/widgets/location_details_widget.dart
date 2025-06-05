import 'package:charts_application/pages/medicalcenter/widgets/info_raw_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/shadow_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/models/medical_center_details_model.dart';
import 'package:get/utils.dart';


class LocationDetailsWidget extends StatelessWidget {
  final MedicalCenterDetailsModel medicalCenter;

  const LocationDetailsWidget({super.key, required this.medicalCenter});

  @override
  Widget build(BuildContext context) {
    return ShadowedContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Location Details".tr,
            style: TextStyle(fontSize: Dimensions.font16(context) + 2, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Dimensions.height15(context) - 3),
          InfoRowWidget(label: "Building".tr, value: medicalCenter.buildingName),
          InfoRowWidget(label: "Floor".tr, value: medicalCenter.floorNumber?.toString()),
          InfoRowWidget(label: "Unit".tr, value: medicalCenter.unitNumber),
          
          if (medicalCenter.latitude != null && medicalCenter.longitude != null)
            Padding(
              padding: EdgeInsets.only(top: Dimensions.height12(context)),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label:  Text("View on Map".tr),
                onPressed: () {}, // Replace with actual navigation logic
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[50],
                  foregroundColor: Colors.blue[800],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
