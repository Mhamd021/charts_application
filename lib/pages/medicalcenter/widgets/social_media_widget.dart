import 'package:charts_application/constants/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:charts_application/models/medical_center_details_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaRowWidget extends StatelessWidget {
  final MedicalCenterDetailsModel medicalCenter;

  const SocialMediaRowWidget({super.key, required this.medicalCenter});

  @override
  Widget build(BuildContext context) {
    return Wrap(
       spacing: Dimensions.width12(context),
      alignment: WrapAlignment.center,
      children: [
        if (medicalCenter.facebookUrl != null)
          _socialMediaButton(Icons.facebook, Colors.blue[800]!),
        if (medicalCenter.instagramUrl != null)
          _socialMediaButton(FontAwesomeIcons.instagram, Colors.pink[600]!),
        if (medicalCenter.twitterUrl != null)
          _socialMediaButton(FontAwesomeIcons.twitter, Colors.blue[400]!),
        if (medicalCenter.whatsAppNumber != null)
          _socialMediaButton(FontAwesomeIcons.whatsapp, Colors.green[600]!),
      ],
    );
  }

  Widget _socialMediaButton(IconData icon, Color color) {
    return IconButton(
      icon: Icon(icon),
      color: color,
      onPressed: () {}
   , 
      style: IconButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
