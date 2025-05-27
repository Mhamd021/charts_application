import 'package:charts_application/pages/medicalcenter/widgets/info_raw_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/shadow_container_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/social_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/models/medical_center_details_model.dart';


class ContactInformationWidget extends StatelessWidget {
  final MedicalCenterDetailsModel medicalCenter;

  const ContactInformationWidget({super.key, required this.medicalCenter});

  @override
  Widget build(BuildContext context) {
    return ShadowedContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Information",
            style: TextStyle(fontSize: Dimensions.font16(context) + 2, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Dimensions.height15(context) - 3),
          InfoRowWidget(label: "Phone", value: medicalCenter.medicalCentersPhoneNumber),
          InfoRowWidget(label: "Email", value: medicalCenter.medicalCentersEmail),
          if (medicalCenter.whatsAppNumber != null)
            InfoRowWidget(label: "WhatsApp", value: medicalCenter.whatsAppNumber),
          SizedBox(height: Dimensions.height15(context) - 3),
          SocialMediaRowWidget(medicalCenter: medicalCenter),
        ],
      ),
    );
  }
}
