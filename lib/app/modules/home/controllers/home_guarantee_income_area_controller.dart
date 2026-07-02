import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class HomeGuaranteeIncomeAreaController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final homeController = Get.find<HomeController>();

  final draggableScrollableController = DraggableScrollableController();
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final locationServices = Get.find<LocationServices>();

  final googleMapController = Completer<GoogleMapController>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  final markers = <MarkerId, Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;
  final polygon = <Polygon>{}.obs;

  final driverLatitude = Rx<double>(0.0);
  final driverLongitude = Rx<double>(0.0);

  final startTimeLocal = Rx<DateTime?>(null);
  final endTimeLocal = Rx<DateTime?>(null);
  final guaranteeIncomeProgress = 0.0.obs;
  final onlineDurationMinutes = 0.obs;
  final draggableScrollableSize = 0.0.obs;

  Timer? driverLocationTimer;

  final isFetch = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;

    draggableScrollableController.addListener(() {
      draggableScrollableSize.value = draggableScrollableController.size;
    });
    isFetch.value = false;
  }

  Future<void> setupMarkers() async {
    // Marker Driver
    var driverMarkerId = MarkerId("driver");
    var driverMarker = Marker(
      markerId: driverMarkerId,
      position: LatLng(driverLatitude.value, driverLongitude.value),
      icon: await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(24.6, 24.37)),
        'assets/icons/icon_guarantee_income_area_driver.png',
      ),
      anchor: Offset(0.5, 0.5),
    );
    markers[driverMarkerId] = driverMarker;

    // Polygon Guarantee Income
  }

  Future<void> setupDriverLocationTimer() async {
    driverLocationTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      refreshDriverLocation();

      var driverMarkerId = MarkerId("driver");
      var driverMarker = Marker(
        markerId: driverMarkerId,
        position: LatLng(driverLatitude.value, driverLongitude.value),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(24.6, 24.37)),
          'assets/icons/icon_guarantee_income_area_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
      );
      markers[driverMarkerId] = driverMarker;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();

    draggableScrollableController.dispose();
    driverLocationTimer?.cancel();
  }

  Future<void> refreshDriverLocation() async {
    driverLatitude.value = locationServices.currentLatitude.value ?? 0.0;
    driverLongitude.value = locationServices.currentLongitude.value ?? 0.0;
  }
}
