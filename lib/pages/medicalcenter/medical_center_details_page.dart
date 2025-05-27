import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/reviewscontroller.dart';
import 'package:charts_application/pages/medicalcenter/widgets/average_rating_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/contact_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/description_section_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/doctor_selection_dialog.dart';
import 'package:charts_application/pages/medicalcenter/widgets/doctorcard_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/hero_header_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/location_details_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/reviews_section_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/shadow_container_widget.dart';
import 'package:charts_application/pages/medicalcenter/widgets/title_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:charts_application/models/medical_center_details_model.dart';
import 'package:get/get.dart';

class MedicalCenterDetailsPage extends StatefulWidget {
  final MedicalCenterDetailsModel medicalCenter;
  
  const MedicalCenterDetailsPage({super.key, required this.medicalCenter});

  @override
  State<MedicalCenterDetailsPage> createState() => _MedicalCenterDetailsPageState();
}

class _MedicalCenterDetailsPageState extends State<MedicalCenterDetailsPage> {

  final ReviewController reviewController = Get.put(ReviewController());
late final ScrollController _scrollController;

@override
void initState() {
  super.initState();
  reviewController.getReviews(widget.medicalCenter.medicalCentersId!);
  _scrollController = ScrollController();
  _scrollController.addListener(_scrollListener);
}

void _scrollListener() {
  if (_scrollController.position.pixels >= 
      _scrollController.position.maxScrollExtent * 0.7) {
    reviewController.getReviews(widget.medicalCenter.medicalCentersId!);
  }
}

@override
void dispose() {
  _scrollController.dispose();
  reviewController.clearReviews();
  super.dispose();
  
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: _buildBookButton(context,widget.medicalCenter),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: Dimensions.height10(context)*25,
            flexibleSpace: HeroHeaderWidget(medicalCenter: widget.medicalCenter),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:  EdgeInsets.all(Dimensions.width15(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 TitleSectionWidget(medicalCenter: widget.medicalCenter),
                   SizedBox(height: Dimensions.height20(context)+4),
                  ContactInformationWidget(medicalCenter: widget.medicalCenter),
                   SizedBox(height: Dimensions.height20(context)+4),
                  LocationDetailsWidget(medicalCenter: widget.medicalCenter),
                   SizedBox(height: Dimensions.height20(context)+4),
                  if (widget.medicalCenter.medicalCentersDescription != null)
                    DescriptionSectionWidget(medicalCenter: widget.medicalCenter),
                   SizedBox(height: Dimensions.height20(context)+4),
                  if(widget.medicalCenter.workingHours!=null)
                  _buildWorkingHoursSection(context),
                   SizedBox(height: Dimensions.height20(context)+4),
                  if (widget.medicalCenter.doctors != null && widget.medicalCenter.doctors!.isNotEmpty)
                    _buildDoctorsSection(context),
                   SizedBox(height: Dimensions.height20(context)*4),
                   AverageRatingWidget(reviewController: reviewController),
                    SizedBox(height: Dimensions.height20(context)),
                      ReviewsSectionWidget(medicalCenterId: widget.medicalCenter.medicalCentersId!)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDoctorsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: EdgeInsets.only(bottom: Dimensions.height15(context)),
          child: Text(
            'Our Doctors',
            style: TextStyle(
              fontSize: Dimensions.font26(context)-2,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.medicalCenter.doctors!.length,
          separatorBuilder: (context, index) =>  SizedBox(height: Dimensions.height15(context)),
          itemBuilder: (context, index) {
            final doctor = widget.medicalCenter.doctors![index];
            return DoctorCard(doctor: doctor);
          },
        ),
      ],
    );
  }

  Widget _buildBookButton(BuildContext context, MedicalCenterDetailsModel medicalCenter) {
  bool hasDoctors = medicalCenter.doctors != null && medicalCenter.doctors!.isNotEmpty;

  return Opacity(
    opacity: hasDoctors ? 1.0 : 0.5, // ✅ Dim when disabled
    child: Container(
      margin: EdgeInsets.only(
        bottom: Dimensions.height15(context),
        right: Dimensions.width15(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20(context)),
        boxShadow: hasDoctors
            ? [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 12, spreadRadius: 2)]
            : [],
      ),
      child: FloatingActionButton.extended(
        onPressed: hasDoctors ? () => _showDoctorSelectionDialog(context) : null, 
        backgroundColor: hasDoctors ? Colors.blue[600] : Colors.grey, 
        elevation: hasDoctors ? 3 : 0, 
        icon: const Icon(Icons.calendar_today, color: Colors.white),
        label: Text(
          'Book Now!',
          style: TextStyle(
            color: Colors.white.withOpacity(hasDoctors ? 1.0 : 0.5), 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

void _showDoctorSelectionDialog(BuildContext context) {
    Get.dialog(DoctorSelectionDialog(medicalCenter: widget.medicalCenter));
}



Widget _buildWorkingHoursSection(BuildContext context) 
{
  if (widget.medicalCenter.workingHours == null || widget.medicalCenter.workingHours!.isEmpty) {
    return const SizedBox(); 
  }

  return ShadowedContainerWidget(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "Working Hours",
          style: TextStyle(fontSize: Dimensions.font16(context)+2, fontWeight: FontWeight.bold),
        ),
                   SizedBox(height: Dimensions.height15(context)-3),
        ...widget.medicalCenter.workingHours!.map((hour) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Text(_getDayName(hour.dayOfWeek!),
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const SizedBox(width: 8),
              Text("${hour.openingTime} - ${hour.closingTime}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 15)),
            ],
          ),
        ))
      ],
    ),
  );
}


String _getDayName(int dayIndex) {
  const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  return days[dayIndex];
}




}




