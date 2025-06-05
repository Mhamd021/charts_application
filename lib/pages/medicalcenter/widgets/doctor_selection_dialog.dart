import 'package:charts_application/helper/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_application/controllers/appointment_controller.dart';
import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/models/medical_center_details_model.dart';

class DoctorSelectionDialog extends StatelessWidget {
  final MedicalCenterDetailsModel medicalCenter;

  const DoctorSelectionDialog({super.key, required this.medicalCenter});

  @override
  Widget build(BuildContext context) {
    final bookController = Get.put(BookAppointmentController());

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(Dimensions.width15(context) + 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              "Select a Doctor".tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: Dimensions.height10(context)),
            SizedBox(
              height: Dimensions.height10(context)*25,
              child: SingleChildScrollView(
                child: Column(
                  children:
                  
                      medicalCenter.doctors!.map((doctor) {
                        return Obx(() {
                            
                          final isSelected =
                              bookController.selectedDoctor.value == doctor;
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              bookController.selectedDoctor.value = doctor;
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              padding: EdgeInsets.all(
                                Dimensions.width12(context),
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: Dimensions.height12(context)/2,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius15(context) - 3,
                                ),
                                boxShadow:
                                    isSelected
                                        ? [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.3),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                        : [],
                              ),
                              child: Row(
                                children: [
                                  Obx(() {
                                    String imageUrl = ImageHelper.getValidImageUrl(doctor.profileImageUrl);
                                    return TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: bookController.isLoading.value ? 2 * 3.14 : 0),
                                      duration: Duration(
                                        seconds: 2,
                                      ), // Slower spin
                                      curve: Curves.easeInExpo,
                                      builder: (context, angle, child) {
                                        return Transform(
                                          alignment: Alignment.center,
                                          transform:
                                              Matrix4.identity()
                                                ..setEntry(3, 2, 0.002)
                                                ..rotateY(angle % (2 * 3.14)),
                                          child: child!,
                                        );
                                      },
                                     child: CircleAvatar(
      backgroundImage: imageUrl.isNotEmpty // ✅ Check if image URL is valid
          ? NetworkImage(imageUrl)
          : null,
      child: imageUrl.isEmpty // ✅ Fallback when no valid image
          ?  Icon(Icons.person, size: Dimensions.iconSize24(context)*2 -8, color: Colors.grey)
          : null,
    ),
                                    );
                                  }),
                                  SizedBox(
                                    width: Dimensions.width12(context),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor.fullName ?? "Doctor Name",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        doctor.specialty ??
                                            "General Practitioner",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      }).toList(),
                ),
              ),
            ),
             SizedBox(height: Dimensions.height12(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:  EdgeInsets.symmetric(
                      horizontal: Dimensions.width15(context),
                      vertical: Dimensions.height10(context),
                    ),
                    elevation: 3,
                  ),
                  child:  Text(
                    "cancel".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Obx(() {
                  return ElevatedButton(
                    onPressed:
                        bookController.selectedDoctor.value != null
                            ? () => _confirmAppointment(
                              2,
                            )
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          bookController.selectedDoctor.value != null
                              ? Colors.blue
                              : Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:  EdgeInsets.symmetric(
                        horizontal: Dimensions.width15(context),
                        vertical: Dimensions.width10(context),
                      ),
                      elevation: 3,
                    ),
                    child:  Text(
                      "Confirm".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmAppointment(int medicalCenterId) {
    final BookAppointmentController bookController =
        Get.find<BookAppointmentController>();
      if (bookController.selectedDoctor.value == null) {
    Get.snackbar("Error", "Please select a doctor and try again.");
    return;
  }

    if (bookController.selectedDoctor.value != null) {
      bookController.createAppointment(
        doctorId: bookController.selectedDoctor.value!.id!,
        medicalCenterId: medicalCenterId,
      );
    }
  }
}
