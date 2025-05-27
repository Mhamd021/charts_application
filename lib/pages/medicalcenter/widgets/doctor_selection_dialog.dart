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
            const Text(
              "Select a Doctor",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
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
                                Dimensions.width10(context) + 2,
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: Dimensions.height10(context) - 4,
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
                                        backgroundImage:
                                            doctor.profileImageUrl != null
                                                ? NetworkImage(
                                                  "https://doctormap.onrender.com${doctor.profileImageUrl}",
                                                )
                                                : null,
                                        child:
                                            doctor.profileImageUrl == null
                                                ? const Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color: Colors.grey,
                                                )
                                                : null,
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    width: Dimensions.width10(context) + 2,
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
            const SizedBox(height: 12),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Cancel",
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
                              medicalCenter.medicalCentersId!,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Confirm",
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

    if (bookController.selectedDoctor.value != null) {
      bookController.createAppointment(
        doctorId: bookController.selectedDoctor.value!.id!,
        medicalCenterId: medicalCenterId,
      );
    }
  }
}
