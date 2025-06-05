import 'package:charts_application/models/medical_center_details_model.dart';
import 'package:charts_application/models/medical_centers_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';

class MedicalMapController extends GetxController {
  var centers = <MedicalCentersModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var selectedCenter = Rxn<MedicalCenterDetailsModel>();
  var cachedCentersDetails = <int, MedicalCenterDetailsModel>{}.obs;
  var centersMap = <int, MedicalCentersModel>{}.obs;
  var isFetchingDetails = false.obs;
  
  Future<void> getMedicalCenters() async {
    isLoading(true);
    try {
      final url = Uri.parse(
        "https://doctormap.onrender.com/api/MedicalCenters/GetAllMedicalCenters",
      );
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> centersJson = convert.jsonDecode(response.body);
        final centerList =
            centersJson
                .map((json) => MedicalCentersModel.fromJson(json))
                .toList();

        centers.assignAll(centerList);
        centersMap.assignAll({
          for (var center in centerList) center.medicalCentersId!: center,
        });
      } else {
        Get.snackbar('Error'.tr, "medical_fetch_failed".tr);
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMedicalCenterDetails(int medicalCentersId) async {
    if (cachedCentersDetails.containsKey(medicalCentersId)) {
      selectedCenter.value = cachedCentersDetails[medicalCentersId];
      return;
    }

    isFetchingDetails(true);
    try {
      final url = Uri.parse(
        "https://doctormap.onrender.com/api/MedicalCenters/GetMedicalCenterById?id=$medicalCentersId",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        
        final details = MedicalCenterDetailsModel.fromJson(
          convert.jsonDecode(response.body),
        );

        cachedCentersDetails[medicalCentersId] = details;
        selectedCenter.value = details;
        cachedCentersDetails.refresh();
      } else {
                Get.snackbar('Error'.tr, "medical_details_failed".tr);

      }
    } catch (e) {
      errorMessage("Error fetching details: ${e.toString()}");
    } finally {
      isFetchingDetails(false);
    }
  }
   void clearCache() {
    cachedCentersDetails.clear(); 
  }

  Future<Position?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("location_disabled".tr);

    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("location_permission_denied".tr);

      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
