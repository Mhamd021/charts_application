import 'package:charts_application/pages/medicalcenter/widgets/info_raw_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/shadow_container_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/social_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/models/medical_center_details_model.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';


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
            "Contact Information".tr,
            style: TextStyle(fontSize: Dimensions.font16(context) + 2, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Dimensions.height12(context)),
          InfoRowWidget(label: "Phone".tr, value: medicalCenter.medicalCentersPhoneNumber),
          InfoRowWidget(label: "Email".tr, value: medicalCenter.medicalCentersEmail),
          if (medicalCenter.whatsAppNumber != null)
            InfoRowWidget(label: "WhatsApp".tr, value: medicalCenter.whatsAppNumber),
          SizedBox(height: Dimensions.height12(context)),
          SocialMediaRowWidget(medicalCenter: medicalCenter),
        ],
      ),
    );
  }
}
