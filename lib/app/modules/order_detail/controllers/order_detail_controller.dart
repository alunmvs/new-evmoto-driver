import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_driver/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_driver/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/bitmap_descriptor_helper.dart';
import 'package:new_evmoto_driver/app/utils/google_maps_helper.dart';
import 'package:new_evmoto_driver/app/utils/location_helper.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailController extends GetxController with WidgetsBindingObserver {
  final OrderRepository orderRepository;
  final GoogleMapsRepository googleMapsRepository;
  final OpenMapsRepository openMapsRepository;

  OrderDetailController({
    required this.orderRepository,
    required this.googleMapsRepository,
    required this.openMapsRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final homeController = Get.find<HomeController>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  late GoogleMapController googleMapController;

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;

  final currentLatitude = "".obs;
  final currentLongitude = "".obs;

  final orderId = "".obs;
  final orderType = 0.obs;
  final orderDetail = OrderDetail().obs;

  final isInformationShow = false.obs;

  late Timer? driverCurrentLocationTimer;
  late Timer? refocusMapBoundsTimer;

  final isSchedulerDriverCurrentLocationIsProcess = false.obs;
  final evmotoOrderChatParticipants = EvmotoOrderChatParticipants().obs;

  final isLocationReadyStatus = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'].toString();
    orderType.value = Get.arguments['order_type'];

    isLocationReadyStatus.value = await isLocationReady();

    if (isLocationReadyStatus.value == true) {
      await requestLocation();
      await getOrderDetail();
      await joinFirestoreChatRooms();
      WidgetsBinding.instance.addObserver(this);
      isFetch.value = false;

      if (orderDetail.value.state == 2 || orderDetail.value.state == 3) {
        await setupGoogleMapsPickUpCustomer();
      }

      if (orderDetail.value.state == 4 ||
          orderDetail.value.state == 5 ||
          orderDetail.value.state == 6) {
        await setupGoogleMapOriginToDestination();
      }

      await Future.wait([
        setupSchedulerDriverCurrentLocation(),
        setupSchedulerDriverRefocusMapBound(),
      ]);

      if ([7].contains(orderDetail.value.state)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAndToNamed(
            Routes.ORDER_PAYMENT_CONFIRMATION,
            arguments: {
              "order_id": orderId.value,
              "order_type": orderType.value,
            },
          );
        });
      }

      if ([8, 9].contains(orderDetail.value.state)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAndToNamed(
            Routes.ORDER_DETAIL_DONE,
            arguments: {
              "order_id": orderId.value,
              "order_type": orderType.value,
            },
          );
        });
      }

      if (orderDetail.value.state == 10) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAndToNamed(
            Routes.ORDER_DETAIL_CANCEL,
            arguments: {
              "order_id": orderId.value,
              "order_type": orderType.value,
            },
          );
        });
      }
    } else {
      isFetch.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();

    await FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .doc(orderDetail.value.orderId.toString())
        .set({
          "driverId": orderDetail.value.driverId,
          "driverName": homeController.userInfo.value.name,
          "driverIsOnline": false,
          "driverLastSeen": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    try {
      googleMapController.dispose();
    } catch (e) {}
    try {
      driverCurrentLocationTimer?.cancel();
    } catch (e) {}
    try {
      refocusMapBoundsTimer?.cancel();
    } catch (e) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(orderDetail.value.orderId.toString())
          .set({
            "driverId": orderDetail.value.driverId,
            "driverName": homeController.userInfo.value.name,
            "driverIsOnline": true,
            "driverLastSeen": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } else if (state == AppLifecycleState.paused) {
      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(orderDetail.value.orderId.toString())
          .set({
            "driverId": orderDetail.value.driverId,
            "driverName": homeController.userInfo.value.name,
            "driverIsOnline": false,
            "driverLastSeen": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    }
  }

  Future<void> refreshAll() async {
    markers.clear();
    polylines.clear();
    polylinesCoordinate.clear();
    driverCurrentLocationTimer?.cancel();
    driverCurrentLocationTimer = null;
    refocusMapBoundsTimer?.cancel();
    refocusMapBoundsTimer = null;

    await requestLocation();
    await getOrderDetail();

    if (orderDetail.value.state == 2 || orderDetail.value.state == 3) {
      await setupGoogleMapsPickUpCustomer();
    }

    if (orderDetail.value.state == 4 ||
        orderDetail.value.state == 5 ||
        orderDetail.value.state == 6) {
      await setupGoogleMapOriginToDestination();
    }

    await Future.wait([
      setupSchedulerDriverCurrentLocation(),
      setupSchedulerDriverRefocusMapBound(),
    ]);
  }

  Future<void> joinFirestoreChatRooms() async {
    FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .doc(orderDetail.value.orderId.toString())
        .snapshots()
        .listen((event) {
          evmotoOrderChatParticipants.value =
              EvmotoOrderChatParticipants.fromJson(event.data()!);
        });

    await FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .doc(orderDetail.value.orderId.toString())
        .set({
          "driverId": orderDetail.value.driverId,
          "driverName": homeController.userInfo.value.name,
          "driverIsOnline": true,
          "driverLastSeen": FieldValue.serverTimestamp(),
          "driverJoinedAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<void> requestLocation() async {
    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.requestPermission();

    if (isLocationServiceEnabled == false ||
        (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever)) {
      return;
    }

    var locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    var position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    currentLatitude.value = position.latitude.toString();
    currentLongitude.value = position.longitude.toString();
  }

  Future<void> getOrderDetail() async {
    orderDetail.value = await orderRepository.getOrderDetail(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
    );
  }

  Future<void> setupGoogleMapsPickUpCustomer() async {
    polylines.clear();

    var markerId = MarkerId("driver_current_location");
    var newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(currentLatitude.value),
        double.parse(currentLongitude.value),
      ),
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
        'assets/icons/icon_order_my_location.png',
        Size(53, 53),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    markerId = MarkerId("appointment_origin");
    newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        orderDetail.value.startLat!,
        orderDetail.value.startLon!,
      ),
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
        'assets/icons/icon_order_appointment_point.png',
        Size(46, 46),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    var openMapDirection = await openMapsRepository.getDirection(
      originLatitude: currentLatitude.value,
      originLongitude: currentLongitude.value,
      destinationLatitude: orderDetail.value.startLat.toString(),
      destinationLongitude: orderDetail.value.startLon.toString(),
    );

    var polylineCoordinates = openMapDirection
        .routes!
        .first
        .geometry!
        .coordinates!
        .map((p) => LatLng(p[1], p[0]))
        .toList();

    polylines.clear();

    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: Color(0XFF37C086),
        width: 6,
      ),
    );

    LatLngBounds bounds;

    var originLatitude = double.parse(this.currentLatitude.value);
    var originLongitude = double.parse(this.currentLongitude.value);
    var destinationLatitude = this.orderDetail.value.startLat!;
    var destinationLongitude = this.orderDetail.value.startLon!;

    if (originLatitude > destinationLatitude &&
        originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, destinationLongitude),
        northeast: LatLng(originLatitude, originLongitude),
      );
    } else if (originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, destinationLongitude),
        northeast: LatLng(destinationLatitude, originLongitude),
      );
    } else if (originLatitude > destinationLatitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, originLongitude),
        northeast: LatLng(originLatitude, destinationLongitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, originLongitude),
        northeast: LatLng(destinationLatitude, destinationLongitude),
      );
    }

    final basePadding = Get.width * 0.1;
    double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
        .abs();
    double lngDiff = (bounds.northeast.longitude - bounds.southwest.longitude)
        .abs();
    double areaFactor = (latDiff + lngDiff) * 80000;
    var dynamicPadding = (basePadding + areaFactor).clamp(60, 250);

    await googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
    );
  }

  Future<void> setupGoogleMapOriginToDestination() async {
    polylines.clear();

    markers.value = markers
        .where((m) => m.markerId != MarkerId('appointment_origin'))
        .toSet();

    var markerId = MarkerId("origin");
    var newMarker = Marker(
      markerId: MarkerId("origin"),
      position: LatLng(
        orderDetail.value.startLat!,
        orderDetail.value.startLon!,
      ),
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
        'assets/icons/icon_order_origin.png',
        Size(35, 35),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    markerId = MarkerId("destination");
    newMarker = Marker(
      markerId: markerId,
      position: LatLng(orderDetail.value.endLat!, orderDetail.value.endLon!),
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
        'assets/icons/icon_order_destination.png',
        Size(29, 29),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    markerId = MarkerId("driver_current_location");
    newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(currentLatitude.value),
        double.parse(currentLongitude.value),
      ),
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
        'assets/icons/icon_order_scooter.png',
        Size(49, 49),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    var openMapDirection = await openMapsRepository.getDirection(
      originLatitude: orderDetail.value.startLat.toString(),
      originLongitude: orderDetail.value.startLon.toString(),
      destinationLatitude: orderDetail.value.endLat.toString(),
      destinationLongitude: orderDetail.value.endLon.toString(),
    );

    var polylineCoordinates = openMapDirection
        .routes!
        .first
        .geometry!
        .coordinates!
        .map((p) => LatLng(p[1], p[0]))
        .toList();

    polylines.clear();
    isFetch.value = true;
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: Color(0XFF37C086),
        width: 6,
      ),
    );
    isFetch.value = false;
    polylines.refresh();

    LatLngBounds bounds;

    var originLatitude = this.orderDetail.value.startLat!;
    var originLongitude = this.orderDetail.value.startLon!;
    var destinationLatitude = this.orderDetail.value.endLat!;
    var destinationLongitude = this.orderDetail.value.endLon!;

    if (originLatitude > destinationLatitude &&
        originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, destinationLongitude),
        northeast: LatLng(originLatitude, originLongitude),
      );
    } else if (originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, destinationLongitude),
        northeast: LatLng(destinationLatitude, originLongitude),
      );
    } else if (originLatitude > destinationLatitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, originLongitude),
        northeast: LatLng(originLatitude, destinationLongitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, originLongitude),
        northeast: LatLng(destinationLatitude, destinationLongitude),
      );
    }

    await googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 200),
    );
  }

  Future<void> setupSchedulerDriverCurrentLocation() async {
    driverCurrentLocationTimer = Timer.periodic(Duration(seconds: 3), (
      timer,
    ) async {
      if (isSchedulerDriverCurrentLocationIsProcess.value == false) {
        isSchedulerDriverCurrentLocationIsProcess.value = true;
        var locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );

        var position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        currentLatitude.value = position.latitude.toString();
        currentLongitude.value = position.longitude.toString();

        var markerId = MarkerId("driver_current_location");
        var newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            double.parse(currentLatitude.value),
            double.parse(currentLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
            orderDetail.value.state == 2 || orderDetail.value.state == 3
                ? 'assets/icons/icon_order_my_location.png'
                : 'assets/icons/icon_order_scooter.png',
            Size(53, 53),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        updatePolyline(
          LatLng(
            double.parse(currentLatitude.value),
            double.parse(currentLongitude.value),
          ),
        );

        try {
          await checkDriverOffRoute();
        } catch (e) {}
        isSchedulerDriverCurrentLocationIsProcess.value = false;
      }
    });
  }

  void upsertMarker({required Marker newMarker, required MarkerId markerId}) {
    var isNewMarkerExists = markers.any((m) => m.markerId == markerId);

    if (isNewMarkerExists) {
      markers.value = markers
          .map((m) => m.markerId == markerId ? newMarker : m)
          .toSet();
    } else {
      markers.add(newMarker);
    }
  }

  Future<void> setupSchedulerDriverRefocusMapBound() async {
    refocusMapBoundsTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await onTapRefocus();
    });
  }

  Future<void> checkDriverOffRoute() async {
    var driverPosition = LatLng(
      double.parse(currentLatitude.value),
      double.parse(currentLongitude.value),
    );

    var routePoint = polylinesCoordinate;

    var distanceFromRoute = getDistanceFromRoute(driverPosition, routePoint);

    if (distanceFromRoute > 50) {
      if (orderDetail.value.state == 2 || orderDetail.value.state == 3) {
        polylines.clear();

        var markerId = MarkerId("driver_current_location");
        var newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            double.parse(currentLatitude.value),
            double.parse(currentLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
            'assets/icons/icon_order_my_location.png',
            Size(53, 53),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        markerId = MarkerId("appointment_origin");
        newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            orderDetail.value.startLat!,
            orderDetail.value.startLon!,
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
            'assets/icons/icon_order_appointment_point.png',
            Size(46, 46),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        var openMapDirection = await openMapsRepository.getDirection(
          originLatitude: currentLatitude.value,
          originLongitude: currentLongitude.value,
          destinationLatitude: orderDetail.value.startLat.toString(),
          destinationLongitude: orderDetail.value.startLon.toString(),
        );

        var polylineCoordinates = openMapDirection
            .routes!
            .first
            .geometry!
            .coordinates!
            .map((p) => LatLng(p[1], p[0]))
            .toList();
        polylinesCoordinate.value = polylineCoordinates;

        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Color(0XFF37C086),
            width: 6,
          ),
        );

        LatLngBounds bounds;

        var originLatitude = double.parse(this.currentLatitude.value);
        var originLongitude = double.parse(this.currentLongitude.value);
        var destinationLatitude = this.orderDetail.value.startLat!;
        var destinationLongitude = this.orderDetail.value.startLon!;

        if (originLatitude > destinationLatitude &&
            originLongitude > destinationLongitude) {
          bounds = LatLngBounds(
            southwest: LatLng(destinationLatitude, destinationLongitude),
            northeast: LatLng(originLatitude, originLongitude),
          );
        } else if (originLongitude > destinationLongitude) {
          bounds = LatLngBounds(
            southwest: LatLng(originLatitude, destinationLongitude),
            northeast: LatLng(destinationLatitude, originLongitude),
          );
        } else if (originLatitude > destinationLatitude) {
          bounds = LatLngBounds(
            southwest: LatLng(destinationLatitude, originLongitude),
            northeast: LatLng(originLatitude, destinationLongitude),
          );
        } else {
          bounds = LatLngBounds(
            southwest: LatLng(originLatitude, originLongitude),
            northeast: LatLng(destinationLatitude, destinationLongitude),
          );
        }

        final basePadding = Get.width * 0.1;
        double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
            .abs();
        double lngDiff =
            (bounds.northeast.longitude - bounds.southwest.longitude).abs();
        double areaFactor = (latDiff + lngDiff) * 80000;
        var dynamicPadding = (basePadding + areaFactor).clamp(60, 250);

        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
        );
      }

      if (orderDetail.value.state == 4 ||
          orderDetail.value.state == 5 ||
          orderDetail.value.state == 6) {
        polylines.clear();

        var markerId = MarkerId("driver_current_location");
        var newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            double.parse(currentLatitude.value),
            double.parse(currentLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
            'assets/icons/icon_order_scooter.png',
            Size(53, 53),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        markerId = MarkerId("destination");
        newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            orderDetail.value.endLat!,
            orderDetail.value.endLon!,
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
            'assets/icons/icon_order_destination.png',
            Size(29, 29),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        var openMapDirection = await openMapsRepository.getDirection(
          originLatitude: currentLatitude.value,
          originLongitude: currentLongitude.value,
          destinationLatitude: orderDetail.value.endLat.toString(),
          destinationLongitude: orderDetail.value.endLon.toString(),
        );

        var polylineCoordinates = openMapDirection
            .routes!
            .first
            .geometry!
            .coordinates!
            .map((p) => LatLng(p[1], p[0]))
            .toList();
        polylinesCoordinate.value = polylineCoordinates;

        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Color(0XFF37C086),
            width: 6,
          ),
        );

        LatLngBounds bounds;

        var originLatitude = double.parse(this.currentLatitude.value);
        var originLongitude = double.parse(this.currentLongitude.value);
        var destinationLatitude = this.orderDetail.value.startLat!;
        var destinationLongitude = this.orderDetail.value.startLon!;

        if (originLatitude > destinationLatitude &&
            originLongitude > destinationLongitude) {
          bounds = LatLngBounds(
            southwest: LatLng(destinationLatitude, destinationLongitude),
            northeast: LatLng(originLatitude, originLongitude),
          );
        } else if (originLongitude > destinationLongitude) {
          bounds = LatLngBounds(
            southwest: LatLng(originLatitude, destinationLongitude),
            northeast: LatLng(destinationLatitude, originLongitude),
          );
        } else if (originLatitude > destinationLatitude) {
          bounds = LatLngBounds(
            southwest: LatLng(destinationLatitude, originLongitude),
            northeast: LatLng(originLatitude, destinationLongitude),
          );
        } else {
          bounds = LatLngBounds(
            southwest: LatLng(originLatitude, originLongitude),
            northeast: LatLng(destinationLatitude, destinationLongitude),
          );
        }

        final basePadding = Get.width * 0.1;
        double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
            .abs();
        double lngDiff =
            (bounds.northeast.longitude - bounds.southwest.longitude).abs();
        double areaFactor = (latDiff + lngDiff) * 80000;
        var dynamicPadding = (basePadding + areaFactor).clamp(60, 250);

        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
        );
      }
    }
  }

  void updatePolyline(LatLng driverPos) {
    var result = getClosestPointIndex(driverPos, polylinesCoordinate);

    var closestIndex = result['index'];
    var minDistance = result['min_distance'];
    var threshold = 30.0;

    if (minDistance < threshold && closestIndex > 0) {
      polylinesCoordinate.value = polylinesCoordinate.sublist(closestIndex);

      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          color: Color(0XFF37C086),
          width: 5,
          points: polylinesCoordinate,
        ),
      );
    }
  }

  Future<void> updateStateStartOrderTrip() async {
    await orderRepository.setOrderState(
      orderType: orderType.value,
      orderId: orderId.value,
      lat: currentLatitude.value,
      lon: currentLongitude.value,
      language: 2,
      state: 3,
    );

    await refreshAll();
  }

  Future<void> updateStateArrivedOrigin() async {
    await orderRepository.setOrderState(
      orderType: orderType.value,
      orderId: orderId.value,
      lat: currentLatitude.value,
      lon: currentLongitude.value,
      language: 2,
      state: 4,
    );

    await refreshAll();
  }

  Future<void> updateStateOnProgress() async {
    await orderRepository.setOrderState(
      orderType: orderType.value,
      orderId: orderId.value,
      lat: currentLatitude.value,
      lon: currentLongitude.value,
      language: 2,
      state: 5,
    );

    await refreshAll();
  }

  Future<void> updateStateArrivedAtDestination() async {
    await orderRepository.setOrderState(
      orderType: orderType.value,
      orderId: orderId.value,
      lat: currentLatitude.value,
      lon: currentLongitude.value,
      language: 2,
      state: 6,
    );

    await getOrderDetail();

    Get.toNamed(
      Routes.ORDER_PAYMENT_CONFIRMATION,
      arguments: {"order_id": orderId.value, "order_type": orderType.value},
    );
  }

  Future<void> onTapRefocus() async {
    if (orderDetail.value.state == 2 || orderDetail.value.state == 3) {
      LatLngBounds bounds;

      var originLatitude = double.parse(currentLatitude.value);
      var originLongitude = double.parse(currentLongitude.value);
      var destinationLatitude = this.orderDetail.value.startLat!;
      var destinationLongitude = this.orderDetail.value.startLon!;

      if (originLatitude > destinationLatitude &&
          originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, destinationLongitude),
          northeast: LatLng(originLatitude, originLongitude),
        );
      } else if (originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, destinationLongitude),
          northeast: LatLng(destinationLatitude, originLongitude),
        );
      } else if (originLatitude > destinationLatitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, originLongitude),
          northeast: LatLng(originLatitude, destinationLongitude),
        );
      } else {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, originLongitude),
          northeast: LatLng(destinationLatitude, destinationLongitude),
        );
      }

      final basePadding = Get.width * 0.1;
      double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
          .abs();
      double lngDiff = (bounds.northeast.longitude - bounds.southwest.longitude)
          .abs();
      double areaFactor = (latDiff + lngDiff) * 80000;
      var dynamicPadding = (basePadding + areaFactor).clamp(60, 250);

      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
      );
    } else {
      LatLngBounds bounds;

      var originLatitude = double.parse(currentLatitude.value);
      var originLongitude = double.parse(currentLongitude.value);
      var destinationLatitude = this.orderDetail.value.endLat!;
      var destinationLongitude = this.orderDetail.value.endLon!;

      if (originLatitude > destinationLatitude &&
          originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, destinationLongitude),
          northeast: LatLng(originLatitude, originLongitude),
        );
      } else if (originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, destinationLongitude),
          northeast: LatLng(destinationLatitude, originLongitude),
        );
      } else if (originLatitude > destinationLatitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, originLongitude),
          northeast: LatLng(originLatitude, destinationLongitude),
        );
      } else {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, originLongitude),
          northeast: LatLng(destinationLatitude, destinationLongitude),
        );
      }
      final basePadding = Get.width * 0.1;
      double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
          .abs();
      double lngDiff = (bounds.northeast.longitude - bounds.southwest.longitude)
          .abs();
      double areaFactor = (latDiff + lngDiff) * 80000;
      var dynamicPadding = (basePadding + areaFactor).clamp(60, 250);

      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
      );
    }
  }

  Future<void> onTapOpenGoogleMaps() async {
    if (orderDetail.value.state == 2 || orderDetail.value.state == 3) {
      final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${orderDetail.value.startLat},${orderDetail.value.startLon}',
      );

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open Google Maps.';
      }
    } else {
      final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${orderDetail.value.endLat},${orderDetail.value.endLon}',
      );

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open Google Maps.';
      }
    }
  }

  Future<void> onTapCallEmergency() async {
    var phoneNumber = '110';
    var launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.platformDefault);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> onTapCancelOrder() async {
    Get.dialog(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Apakah Anda yakin ingin membatalkan pesanan?",
                        style: typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              width: Get.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: themeColorServices
                                        .neutralsColorGrey300
                                        .value,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.close(1);
                                },
                                child: Text(
                                  "Tutup",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              width: Get.width,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await orderRepository.cancelOrder(
                                      orderType: orderType.value,
                                      orderId: orderId.value,
                                      language: 2,
                                    );
                                    Get.close(1);
                                    Get.back();
                                    Get.find<HomeController>().refreshAll();

                                    final SnackBar snackBar = SnackBar(
                                      behavior: SnackBarBehavior.fixed,
                                      backgroundColor: themeColorServices
                                          .sematicColorGreen400
                                          .value,
                                      content: Text(
                                        "Berhasil membatalkan pesanan",
                                        style: typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(
                                              color: themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                      ),
                                    );
                                    rootScaffoldMessengerKey.currentState
                                        ?.showSnackBar(snackBar);
                                  } catch (e) {
                                    final SnackBar snackBar = SnackBar(
                                      behavior: SnackBarBehavior.fixed,
                                      backgroundColor: themeColorServices
                                          .sematicColorRed400
                                          .value,
                                      content: Text(
                                        e.toString(),
                                        style: typographyServices
                                            .bodySmallBold
                                            .value
                                            .copyWith(
                                              color: themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                      ),
                                    );
                                    rootScaffoldMessengerKey.currentState
                                        ?.showSnackBar(snackBar);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      themeColorServices.redColor.value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  "Batalkan",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
  }
}
