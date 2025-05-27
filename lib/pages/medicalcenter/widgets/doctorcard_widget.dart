import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/models/medical_center_details_model.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(Dimensions.width15(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Dimensions.width20(context)*4,
            height: Dimensions.height20(context)*4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30(context)*2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              image: doctor.profileImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage("https://doctormap.onrender.com${doctor.profileImageUrl}"),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: doctor.profileImageUrl == null
                ?  Icon(Icons.person, size: Dimensions.width45(context)-5, color: Colors.grey)
                : null,
          ),
           SizedBox(width: Dimensions.width15(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.fullName ?? "Doctor Name",
                  style:  TextStyle(
                    fontSize: Dimensions.font16(context)+2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  doctor.specialty ?? "General Practitioner",
                  style: TextStyle(
                    fontSize: Dimensions.font16(context)-3,
                    color: Colors.grey[600],
                  ),
                ),
                 SizedBox(height: Dimensions.width10(context)-2),
                if (doctor.yearsOfExperience != null)
                  Row(
                    children: [
                      Icon(Icons.work_history, size: Dimensions.iconSize16(context), color: Colors.blue[300]),
                       SizedBox(width: Dimensions.width20(context)/5 ),
                      Text(
                        '${doctor.yearsOfExperience} years experience',
                        style: TextStyle(
                          fontSize: Dimensions.font16(context)-3,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                if (doctor.spokenLanguages != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 4,
                      children: doctor.spokenLanguages!
                          .map((lang) => Chip(
                                label: Text(lang),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ))
                          .toList(),
                    ),
                  ),
                if (doctor.isAvailableForOnlineBooking ?? false)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon:  Icon(Icons.calendar_month, size: Dimensions.iconSize16(context)),
                      label: const Text('Book Now'),
                      onPressed: () {},
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
