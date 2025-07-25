import 'package:charts_application/constants/dimensions.dart';
import 'package:charts_application/controllers/appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_application/models/Appointment_model.dart';
import 'package:shimmer/shimmer.dart';

class UserAppointmentsPage extends StatefulWidget {
  const UserAppointmentsPage({super.key});

  @override
  State<UserAppointmentsPage> createState() => _UserAppointmentsPageState();
}

class _UserAppointmentsPageState extends State<UserAppointmentsPage> {
  final BookAppointmentController appointmentController = Get.put(BookAppointmentController());

  @override
  void initState() {
    super.initState();
    if (appointmentController.appointments.isEmpty) {
      appointmentController.getUserAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
  "My Appointments".tr,
  style: TextStyle(fontSize: Dimensions.font20(context)), 
),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: RefreshIndicator(
        onRefresh: () async => await appointmentController.getUserAppointments(),
        child: Obx(() {
          if (appointmentController.isLoading.value) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => _buildSkeletonLoader(context),
            );
          }

          if (appointmentController.appointments.isEmpty) {
            return Center(
              child: Text("No appointments found".tr, 
                style: TextStyle(color: Colors.grey.shade600, fontSize: Dimensions.font16(context))),
            );
          }

          return ListView.separated(
          padding: EdgeInsets.all(Dimensions.height15(context)),
            itemCount: appointmentController.appointments.length,
            separatorBuilder: (context, index) =>  SizedBox(height: Dimensions.height12(context)),
            itemBuilder: (context, index) {
              final appointment = appointmentController.appointments[index];
              return _buildAppointmentCard(appointment);
            },
          );
        }),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.height15(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: Colors.blue, size: Dimensions.iconSize24(context)),
                 SizedBox(width: Dimensions.width10(context)),
                Text(appointment.doctorName, style: TextStyle(fontSize: Dimensions.font16(context), fontWeight: FontWeight.w600)),
              ],
            ),
             SizedBox(height: Dimensions.height12(context)),
            _buildDetailRow(Icons.business, "Medical Center".tr, appointment.centerName),
            _buildDetailRow(Icons.calendar_today, "Requested".tr, 
              "${appointment.requestedAt.toLocal().day}/${appointment.requestedAt.toLocal().month}/${appointment.requestedAt.toLocal().year}"),
            SizedBox(height: Dimensions.height10(context)),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:  EdgeInsets.symmetric(horizontal: Dimensions.width12(context), vertical: Dimensions.height12(context)/2),
                decoration: BoxDecoration(
                  color: _getStatusColor(appointment.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getStatusColor(appointment.status)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getStatusIcon(appointment.status), 
                      size: Dimensions.iconSize16(context), color: _getStatusColor(appointment.status)),
                     SizedBox(width: Dimensions.width12(context)/2),
                    Text(_getStatusText(appointment.status),
                      style: TextStyle(
                        color: _getStatusColor(appointment.status),
                        fontWeight: FontWeight.w500
                      )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: Dimensions.height10(context)-6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey.shade800, fontSize: Dimensions.font16(context)),
              children: [
                TextSpan(text: "$label: ", 
                  style: const TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: value),
              ]
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildSkeletonLoader(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(Dimensions.radius15(context)),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius15(context)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.radius15(context)),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Header Section
              Row(
                children: [
                  // Icon Placeholder
                  Container(
                    width: Dimensions.width30(context),
                    height: Dimensions.height30(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10(context)),
                  // Doctor Name & Specialization
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Dimensions.width30(context) * 5,
                        height: Dimensions.height15(context),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: Dimensions.height10(context)),
                      Container(
                        width: Dimensions.width30(context) * 3,
                        height: Dimensions.height10(context),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20(context)),

              // Medical Center Details
              _buildSkeletonDetailRow(
                iconSize: Dimensions.width20(context),
                textWidth: Dimensions.width30(context) * 4,
              ),
              SizedBox(height: Dimensions.height15(context)),

              // Date & Time Details
              _buildSkeletonDetailRow(
                iconSize: Dimensions.width20(context),
                textWidth: Dimensions.width30(context) * 5,
              ),
              SizedBox(height: Dimensions.height15(context)),

              // Divider
              Container(
                height: 1,
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: Dimensions.height10(context)),
              ),

              // Status Section
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: Dimensions.width30(context) * 3,
                  height: Dimensions.height20(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

 Widget _buildSkeletonDetailRow({required double iconSize, required double textWidth}) {
  return Row(
    children: [
      Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      SizedBox(width: Dimensions.width10(context)),
      Container(
        width: textWidth,
        height: Dimensions.height15(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ],
  );
}

  String _getStatusText(int status) {
    switch (status) {
      case 0: return "Pending".tr;
      case 1: return "Approved".tr;
      case 2: return "Rejected".tr;
      default: return "Unknown".tr;
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0: return Colors.amber.shade700;
      case 1: return Colors.green.shade700;
      case 2: return Colors.red.shade700;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0: return Icons.access_time;
      case 1: return Icons.check_circle;
      case 2: return Icons.cancel;
      default: return Icons.help_outline;
    }
  }
}