import 'package:charts_application/controllers/medicalmapcontroller.dart';
import 'package:charts_application/pages/map/map_loader_page.dart';
import 'package:charts_application/pages/map/marker_loader.dart';
import 'package:charts_application/pages/medicalcenter/medical_center_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapPageGetX extends StatefulWidget {
  const MapPageGetX({super.key});

  @override
  State<MapPageGetX> createState() => _MapPageGetXState();
}

class _MapPageGetXState extends State<MapPageGetX> with TickerProviderStateMixin {
  final apiController = Get.find<MedicalMapController>();
  final MapController leafletMapController = MapController();
  late String selectedCountry = 'UAE'.tr;
  late LatLng _lastCenter;
  double _lastZoom = 5.0;

  final List<String> countries = ['Germany'.tr, 'Syria'.tr, 'UAE'.tr];

  final Map<String, LatLng> countryCenter = {
    'Germany': LatLng(51.165691, 10.451526),
    'Syria': LatLng(34.802075, 38.996815),
    'UAE': LatLng(25.2048, 55.2708),
  };

  @override
  void initState() {
    super.initState();
    _lastCenter = LatLng(25.2048, 55.2708);
    apiController.getMedicalCenters();
  }

  void animateMapMove(LatLng destCenter, double destZoom) {
    final latTween = Tween<double>(begin: _lastCenter.latitude, end: destCenter.latitude);
    final lngTween = Tween<double>(begin: _lastCenter.longitude, end: destCenter.longitude);
    final zoomTween = Tween<double>(begin: _lastZoom, end: destZoom);

    AnimationController animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animation.addListener(() {
      final lat = latTween.evaluate(animation);
      final lng = lngTween.evaluate(animation);
      final zoom = zoomTween.evaluate(animation);
      leafletMapController.move(LatLng(lat, lng), zoom);
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _lastCenter = destCenter;
        _lastZoom = destZoom;
        animationController.dispose();
      }
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            Position? position = await apiController.getUserLocation();
            if (position != null) {
              LatLng userLocation = LatLng(position.latitude, position.longitude);
              leafletMapController.move(userLocation, 15.0);
            }
          } catch (e) {
            Get.snackbar("Error".tr, e.toString());
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
      appBar: AppBar(
        title:  Text("Medical Centers".tr),
        backgroundColor: Colors.white,
        actions: [
          DropdownButton<String>(
            value: selectedCountry,
            dropdownColor: Colors.white,
            iconEnabledColor: Colors.deepPurple,
            underline: const SizedBox(),
            onChanged: (newCountry) {
              if (newCountry != null && countryCenter.containsKey(newCountry)) {
                setState(() => selectedCountry = newCountry);
                animateMapMove(countryCenter[newCountry]!, 5);
              }
            },
            items: countries.map((String country) {
              return DropdownMenuItem<String>(
                value: country,
                child: Text(
                  country,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: leafletMapController,
            options: MapOptions(
              initialCenter: _lastCenter,
              initialZoom: _lastZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'http://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              Obx(() {
                return MarkerLayer(
                  markers: apiController.centers.map((center) => Marker(
                        point: LatLng(center.latitude ?? 0.0, center.longitude ?? 0.0),
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              if (center.medicalCentersId != null) {
                                apiController.isFetchingDetails(true);
                                if (apiController.cachedCentersDetails.containsKey(center.medicalCentersId)) {
                                  apiController.selectedCenter.value = apiController.cachedCentersDetails[center.medicalCentersId];
                                } else {
                                  await apiController.fetchMedicalCenterDetails(center.medicalCentersId!);
                                }

                                if (apiController.selectedCenter.value != null) {
                                  await Get.to(
                                    () => MedicalCenterDetailsPage(
                                      medicalCenter: apiController.selectedCenter.value!,
                                    ),
                                    transition: Transition.fadeIn,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                    fullscreenDialog: true,
                                      preventDuplicates: true,
                                    popGesture: false,
                                  );
                                }
                              }
                            } catch (e) {
                              Get.snackbar("Error".tr, e.toString());
                            } finally {
                              apiController.isFetchingDetails(false);
                            }
                          },
                          child: Obx(() => BouncingMarker(
                                isLoading: apiController.isFetchingDetails.value,
                                child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
                              )),
                        ),
                      )).toList(),
                );
              }),
            ],
          ),
          Obx(() => apiController.isLoading.value ? const MapLoader() : const SizedBox()),
        ],
      ),
    );
  }
}
