
import 'package:charts_application/controllers/appointment_controller.dart';
import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/controllers/medicalmapcontroller.dart';
import 'package:charts_application/controllers/reviewscontroller.dart';
import 'package:get/get.dart';



Future<void> init() async 
{
  Get.lazyPut(() => AuthController());
    Get.lazyPut(() => MedicalMapController());
      Get.lazyPut(() => BookAppointmentController());
        Get.lazyPut(()=> ReviewController());

  
}