import 'package:charts_application/constants/app_consts.dart';
import 'package:charts_application/helper/route_helper.dart';
import 'package:charts_application/models/Appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_application/controllers/auth_controller.dart';
import 'package:charts_application/models/medical_center_details_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class BookAppointmentController extends GetxController {
  var selectedDoctor = Rxn<Doctor>();
  var isLoading = false.obs;
  var appointments = <AppointmentModel>[].obs;
  final AuthController _authController = Get.find<AuthController>();

  Future<void> createAppointment({
    required int doctorId,
    required int medicalCenterId,
  }) async {
    try {
      isLoading.value = true;

      final userId = _authController.userId.value;

      final token = await _authController.storage.read(key: 'access_token');

      if (userId.isEmpty || token == null) {
        Get.defaultDialog(
          title: 'Error'.tr,
          middleText: 'unauthorized'.tr,
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue,
        );
        Get.offNamed(RouteHelper.signIn);
        return;
      }

      final response = await http.post(
        Uri.parse(
          'https://doctormap.onrender.com/api/Appointments/CreateAppointment',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'User-Agent': Appconsts.useragent,
        },
        body: convert.jsonEncode({
          'userId': userId,
          'doctorId': doctorId,
          'medicalCenterId': medicalCenterId,
        }),
      );

      _handleResponse(response);
    } on Exception catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserAppointments() async {
    try {
      isLoading.value = true;

      final userId = _authController.userId.value;
      final token = await _authController.storage.read(key: 'access_token');

      if (userId.isEmpty || token == null) {
        Get.defaultDialog(
          title: 'Error'.tr,
          middleText: 'unauthorized'.tr,
          confirmTextColor: Colors.white,
          buttonColor: Colors.blue,
        );
        Get.offNamed(RouteHelper.getSignIn());
        return;
      }

      final response = await http.get(
        Uri.parse(
          "https://doctormap.onrender.com/api/Appointments/GetAppointment/$userId",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "User-Agent": Appconsts.useragent,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = convert.jsonDecode(response.body);
        appointments.assignAll(
          data.map((json) => AppointmentModel.fromJson(json)).toList(),
        );
      } else {
        throw Exception(
          "Failed to fetch appointments (Status ${response.statusCode})",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleResponse(http.Response response) {
    final status = response.statusCode;

    if (status == 200) {
      getUserAppointments();
      Get.back();
      Get.snackbar(
        'Success',
        'Appointment booked!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.defaultDialog(
        title: 'Error'.tr,
        middleText: 'network_error'.tr,
        confirmTextColor: Colors.white,
        buttonColor: Colors.blue,
      );
    }
  }

  void _handleError(dynamic error) {
    String message;

    if (error is http.Response) {
      switch (error.statusCode) {
        case 400:
          message = 'bad_request'.tr;
          break;
        case 401:
          message = 'unauthorized'.tr;
          _authController.clearAccessToken();
          Get.offAllNamed(RouteHelper.getSignIn()); // Auto redirect to login
          break;
        case 404:
          message = 'data_not_found'.tr;
          break;
        case 500:
          message = 'server_error'.tr;
          break;
        default:
          message = 'unknown_error'.tr;
      }
    } else if (error.toString().contains('expired') ||
        error.toString().contains('authentic')) {
      message = 'session_expired'.tr;
      _authController.clearAccessToken();
      Get.offAllNamed(RouteHelper.getSignIn()); // Redirect user to login
    } else {
      message = 'network_error'.tr;
    }

    Get.snackbar(
      'Error'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
}
