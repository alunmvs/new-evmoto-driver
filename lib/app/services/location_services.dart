// ignore_for_file: prefer_conditional_assignment

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/geocoding_address_model.dart';
import 'package:new_evmoto_driver/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_driver/app/services/background_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';

class LocationServices extends GetxService with WidgetsBindingObserver {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final backgroundServices = Get.find<BackgroundServices>();

  final geocodingAddress = GeocodingAddress().obs;

  final currentAltitude = Rx<double?>(null);
  final currentLatitude = Rx<double?>(null);
  final currentLongitude = Rx<double?>(null);
  final isPermissionLocationAllow = Rx<bool?>(false);

  final requestPermissionCount = 0.obs;

  final wasInBackground = false.obs;
  final isRequestingPermission = false.obs;
  final isRequiredAccessPermissionDialogActive = false.obs;

  StreamSubscription<Position>? positionStream;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      wasInBackground.value = true;
    }

    if (state == AppLifecycleState.resumed && wasInBackground.value == true) {
      await requestLocationSplashScreen();
      wasInBackground.value = false;
    }
  }

  Future<void> requestLocation() async {
    if (isRequestingPermission.value == false) {
      isRequestingPermission.value = true;
      var checkPermission = await Geolocator.checkPermission();
      var isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (isLocationServiceEnabled == false ||
          checkPermission == LocationPermission.denied ||
          checkPermission == LocationPermission.deniedForever) {
        var isLocationServiceEnabled =
            await Geolocator.isLocationServiceEnabled();
        var permission = await Geolocator.requestPermission();
        requestPermissionCount.value += 1;

        if (isLocationServiceEnabled == false ||
            (permission == LocationPermission.denied ||
                permission == LocationPermission.deniedForever)) {
          isPermissionLocationAllow.value = false;
          isRequestingPermission.value = false;

          currentAltitude.value = null;
          currentLatitude.value = null;
          currentLongitude.value = null;

          if (requestPermissionCount.value > 1) {
            await showRequiredAccessPermission();
          }
          return;
        }
      } else {
        isPermissionLocationAllow.value = true;
      }

      if (positionStream == null) {
        var locationSettings = LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        );

        positionStream =
            Geolocator.getPositionStream(
              locationSettings: locationSettings,
            ).listen((Position position) {
              // print(
              //   "[DEBUG POSITION] ${position.latitude},${position.longitude} Accuracy : ${position.accuracy.toStringAsFixed(2)} m",
              // );

              // var isValidLocation =
              //     currentLatitude.value == null || position.accuracy <= 20;
              // if (isValidLocation) {
              currentAltitude.value = position.altitude;
              currentLatitude.value = position.latitude;
              currentLongitude.value = position.longitude;
              // }
            });

        await backgroundServices.refreshState();
      }

      isRequestingPermission.value = false;
    }
  }

  Future<void> requestLocationSplashScreen() async {
    if (isRequestingPermission.value == false) {
      isRequestingPermission.value = true;
      var checkPermission = await Geolocator.checkPermission();
      var isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnabled == false ||
          checkPermission == LocationPermission.denied ||
          checkPermission == LocationPermission.deniedForever) {
        isPermissionLocationAllow.value = false;
        isRequestingPermission.value = false;

        currentAltitude.value = null;
        currentLatitude.value = null;
        currentLongitude.value = null;
        return;
      } else {
        isPermissionLocationAllow.value = true;
      }

      var locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      );

      if (positionStream == null) {
        positionStream =
            Geolocator.getPositionStream(
              locationSettings: locationSettings,
            ).listen((Position position) {
              // print(
              //   "[DEBUG POSITION] ${position.latitude},${position.longitude} Accuracy : ${position.accuracy.toStringAsFixed(2)} m",
              // );
              // var isValidLocation =
              //     currentLatitude.value == null || position.accuracy <= 20;
              // if (isValidLocation) {
              currentAltitude.value = position.altitude;
              currentLatitude.value = position.latitude;
              currentLongitude.value = position.longitude;
              // }
            });

        await backgroundServices.refreshState();
      }

      isRequestingPermission.value = false;
    }
  }

  Future<void> getGeocodingAddress() async {
    if (currentLatitude.value != null) {
      var geocodingRepository = GeocodingRepository();
      var geocodingAddress =
          (await geocodingRepository.getAddressByLatitudeLongitude(
            latitude: currentLatitude.value,
            longitude: currentLongitude.value,
          )) ??
          GeocodingAddress();
      this.geocodingAddress.value = geocodingAddress;
    }
  }

  Future<void> openAppSettings() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {}
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    }
  }

  Future<void> showRequiredAccessPermission() async {
    if (isRequiredAccessPermissionDialogActive.value == false) {
      isRequiredAccessPermissionDialogActive.value = true;
      await Get.dialog(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: themeColorServices.neutralsColorGrey0.value,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              languageServices
                                      .language
                                      .value
                                      .locationAccessConsent ??
                                  "-",
                              style: typographyServices.bodyLargeBold.value
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.close(1);
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_close.svg",
                                      width: 18,
                                      height: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 304.5 / 125,
                            child: Image.asset(
                              'assets/images/img_location_required.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          languageServices.language.value.needExactLocation ??
                              "-",
                          style: typographyServices.bodySmallRegular.value,
                        ),
                        SizedBox(height: 16),
                        LoaderElevatedButton(
                          child: Text(
                            languageServices.language.value.enableLocation ??
                                "-",
                            style: typographyServices.bodyLargeBold.value
                                .copyWith(
                                  color: themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                ),
                          ),
                          onPressed: () async {
                            await openAppSettings();
                            Get.close(1);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      isRequiredAccessPermissionDialogActive.value = false;
    }
  }
}
