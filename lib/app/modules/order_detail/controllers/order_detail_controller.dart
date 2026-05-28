import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_driver/app/data/models/evmoto_order_chat_messages_model.dart';
import 'package:new_evmoto_driver/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_user_model.dart';
import 'package:new_evmoto_driver/app/data/models/socket_driver_position_data_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_driver/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import 'package:new_evmoto_driver/app/utils/bitmap_descriptor_helper.dart';
import 'package:new_evmoto_driver/app/utils/google_maps_helper.dart';
import 'package:new_evmoto_driver/app/utils/time_process_helper.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:new_evmoto_driver/app/data/models/open_map_direction_model.dart'
    as direction_model;

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
  final userServices = Get.find<UserServices>();
  final socketServices = Get.find<SocketServices>();

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
  final orderUser = OrderUser().obs;

  final isInformationShow = false.obs;

  Timer? driverCurrentLocationTimer;
  Timer? refocusMapBoundsTimer;

  final isSchedulerDriverCurrentLocationIsProcess = false.obs;
  final evmotoOrderChatParticipants = EvmotoOrderChatParticipants().obs;

  final locationServices = Get.find<LocationServices>();

  final driverToOriginDirection = direction_model.OpenMapDirection().obs;
  final driverToDestinationDirection = direction_model.OpenMapDirection().obs;
  final originToDestinationDirection = direction_model.OpenMapDirection().obs;

  // debug purposes
  final distanceFromRoute = 0.0.obs;
  final distanceFromNearestRoute = 0.0.obs;
  final totalHitAPIGetDirectionDriverToOrigin = 0.obs;
  final totalHitAPIGetDirectionDriverToDestination = 0.obs;
  final totalRefreshStatus = 0.obs;

  final isDriverToOriginDirectionVisible = true.obs;
  final isDriverToDestinationDirectionVisible = true.obs;
  final isOriginToDestinationDirectionVisible = true.obs;
  final isMarkerDriverVisible = true.obs;
  final isMarkerOriginVisible = true.obs;
  final isMarkerDestinationVisible = true.obs;
  final isPinLocationWaitingForDriverHide = true.obs;

  final evmotoOrderChatMessagesList = <EvmotoOrderChatMessages>[].obs;

  StreamSubscription? streamEvmotoOrderChatParticipants;
  StreamSubscription? streamEvmotoOrderChatMessages;

  final state = 0.obs;
  final previousState = 0.obs;

  final socketDriverPositionData = SocketDriverPositionData().obs;

  late Timer? globalSchedulerTimer;

  final isCreateRoomLoading = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'].toString();
    orderType.value = Get.arguments['order_type'];

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await locationServices.requestLocation();
      await Future.wait([getOrderDetail(), getOrderUserDetail()]);

      while (locationServices.currentLatitude.value == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await Future.wait([getAllRoutingCache()]);
      await Future.wait([updateVisibility()]);
      await Future.wait([
        setupAllMarkers(),
        setupAllRouting(),
        updateCameraAutoFocus(),
      ]);

      isFetch.value = false;

      if ([1, 2, 3, 4, 5, 6, 7, 8].contains(orderDetail.value.state)) {
        await updateDriverPositionReducedPolyline();
        await updateDriverPositionReroutingOffRoute();
      }

      ever(locationServices.currentLatitude, (value) async {
        await handleSocketDriverPosition();
      });

      ever(state, (value) async {
        await measureTime(
          "[Essentials] Get Order Ride Detail & Get Order Ride Server Detail",
          () => Future.wait([getOrderDetail(), getOrderUserDetail()]),
        );

        if (value == 2 || value == 1) {
          if (locationServices.currentLatitude.value == null) {
            await locationServices.currentLatitude.stream.firstWhere(
              (value) => value != null,
            );
            await getAllRoutingCache();
          }
        }

        await measureTime(
          "[Essentials] Get All Routing Cache",
          () => Future.wait([getAllRoutingCache()]),
        );

        await updateVisibility();
        await Future.wait([
          setupAllMarkers(),
          setupAllRouting(),
          updateCameraAutoFocus(),
        ]);
        // await Future.wait([checkReceiveInvoice()]);

        if ([1, 2, 3, 4, 5, 6, 7, 8].contains(state.value)) {
          await updateDriverPositionReducedPolyline();
          await updateDriverPositionReroutingOffRoute();
        }

        previousState.value = value;
      });

      await checkSendInvoice();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();

    WidgetsBinding.instance.removeObserver(this);

    await streamEvmotoOrderChatParticipants?.cancel();
    await streamEvmotoOrderChatMessages?.cancel();
    await setChatOffline();

    try {
      googleMapController.dispose();
    } catch (e) {}
    try {
      driverCurrentLocationTimer?.cancel();
    } catch (e) {}
    try {
      refocusMapBoundsTimer?.cancel();
    } catch (e) {}
    try {
      globalSchedulerTimer?.cancel();
    } catch (e) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await setChatOnline();
      await Future.wait([getOrderDetail(), getOrderUserDetail()]);
    } else if (state == AppLifecycleState.paused) {
      await setChatOffline();
    }
  }

  Future<void> setupGlobalSchedulerTimer() async {
    globalSchedulerTimer ??= Timer.periodic(Duration(minutes: 1), (
      timer,
    ) async {
      await Future.wait([getOrderDetail(), getOrderUserDetail()]);

      if (orderDetail.value.state == 10) {
        Get.back();
        await Get.find<HomeController>().refreshAll();
        final SnackBar snackBar = SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: themeColorServices.sematicColorRed400.value,
          content: Text(
            "Pelanggan membatalkan pesanan",
            style: typographyServices.bodySmallRegular.value.copyWith(
              color: themeColorServices.neutralsColorGrey0.value,
            ),
          ),
        );
        rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
      }
    });
  }

  Future<void> refreshAll() async {
    markers.clear();
    polylines.clear();
    polylinesCoordinate.clear();
    try {
      driverCurrentLocationTimer?.cancel();
      driverCurrentLocationTimer = null;
    } catch (e) {}
    try {
      refocusMapBoundsTimer?.cancel();
      refocusMapBoundsTimer = null;
    } catch (e) {}

    try {
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
    } catch (e) {
      var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          "Terdapat error pada aplikasi",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
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
      language: languageServices.languageCodeSystem.value,
    );

    state.value = orderDetail.value.state ?? 0;

    if (isCreateRoomLoading.value == false) {
      if ((evmotoOrderChatParticipants.value.userId !=
                  orderDetail.value.userId.toString() &&
              evmotoOrderChatParticipants.value.driverId !=
                  orderDetail.value.driverId.toString() &&
              evmotoOrderChatParticipants.value.orderId !=
                  orderDetail.value.orderId.toString()) &&
          (orderDetail.value.userId != null &&
              orderDetail.value.driverId != null &&
              orderDetail.value.driverId != 0 &&
              orderDetail.value.orderId != null)) {
        isCreateRoomLoading.value = true;
        await getExistingChatRoom();
        if (evmotoOrderChatParticipants.value.docId == null) {
          await userCreateChatRoom();
        }

        if (evmotoOrderChatParticipants.value.docId != null) {
          await setChatOnline();
          await streamExistingChatRoom();
          await streamExistingChatList();
        }
        isCreateRoomLoading.value = false;
      }
    }
  }

  Future<void> refreshChatRoom() async {
    if (isCreateRoomLoading.value == false) {
      if ((evmotoOrderChatParticipants.value.userId !=
                  orderDetail.value.userId.toString() &&
              evmotoOrderChatParticipants.value.driverId !=
                  orderDetail.value.driverId.toString() &&
              evmotoOrderChatParticipants.value.orderId !=
                  orderDetail.value.orderId.toString()) &&
          (orderDetail.value.userId != null &&
              orderDetail.value.driverId != null &&
              orderDetail.value.driverId != 0 &&
              orderDetail.value.orderId != null)) {
        isCreateRoomLoading.value = true;
        await getExistingChatRoom();
        if (evmotoOrderChatParticipants.value.docId == null) {
          await userCreateChatRoom();
        }

        if (evmotoOrderChatParticipants.value.docId != null) {
          await setChatOnline();
          await streamExistingChatRoom();
          await streamExistingChatList();
        }
        isCreateRoomLoading.value = false;
      }
    }
  }

  Future<void> getOrderUserDetail() async {
    orderUser.value = await orderRepository.getOrderUserDetail(
      orderType: orderType.value,
      orderId: orderId.value,
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
    polylinesCoordinate.value = polylineCoordinates;

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

    await googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
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
    polylinesCoordinate.value = polylineCoordinates;

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
    await onTapRefocus();
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

        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
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

        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
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
    try {
      await orderRepository.setOrderState(
        orderType: orderType.value,
        orderId: orderId.value,
        lat: locationServices.currentLatitude.value.toString(),
        lon: locationServices.currentLongitude.value.toString(),
        language: languageServices.languageCodeSystem.value,
        state: 3,
      );
      await getOrderDetail();
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);

      if ([
        "Better luck, next time!",
        "Semoga lain kali lebih beruntung!",
        "手速有点慢哦，订单已被抢啦！",
      ].contains(e.toString())) {
        Get.back();
      }
    } finally {
      state.value = 3;
    }
  }

  Future<void> updateStateArrivedOrigin() async {
    try {
      await orderRepository.setOrderState(
        orderType: orderType.value,
        orderId: orderId.value,
        lat: locationServices.currentLatitude.value.toString(),
        lon: locationServices.currentLongitude.value.toString(),
        language: languageServices.languageCodeSystem.value,
        state: 4,
      );
      await getOrderDetail();
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);

      if ([
        "Better luck, next time!",
        "Semoga lain kali lebih beruntung!",
        "手速有点慢哦，订单已被抢啦！",
      ].contains(e.toString())) {
        Get.back();
      }
    } finally {
      state.value = 4;
    }
  }

  Future<void> updateStateOnProgress() async {
    try {
      await orderRepository.setOrderState(
        orderType: orderType.value,
        orderId: orderId.value,
        lat: locationServices.currentLatitude.value.toString(),
        lon: locationServices.currentLongitude.value.toString(),
        language: languageServices.languageCodeSystem.value,
        state: 5,
      );
      await getOrderDetail();
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);

      if ([
        "Better luck, next time!",
        "Semoga lain kali lebih beruntung!",
        "手速有点慢哦，订单已被抢啦！",
      ].contains(e.toString())) {
        Get.back();
      }
    } finally {
      state.value = 5;
    }
  }

  Future<void> updateStateArrivedAtDestination() async {
    try {
      await orderRepository.setOrderState(
        orderType: orderType.value,
        orderId: orderId.value,
        lat: locationServices.currentLatitude.value.toString(),
        lon: locationServices.currentLongitude.value.toString(),
        language: languageServices.languageCodeSystem.value,
        state: 6,
      );
      await getOrderDetail();

      state.value = 6;

      Get.back();
      Get.toNamed(
        Routes.ORDER_PAYMENT_CONFIRMATION,
        arguments: {"order_id": orderId.value, "order_type": orderType.value},
      );
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);

      if ([
        "Better luck, next time!",
        "Semoga lain kali lebih beruntung!",
        "手速有点慢哦，订单已被抢啦！",
      ].contains(e.toString())) {
        Get.back();
      }
    } finally {}
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

      var movementDirection = compareLatLng(
        originLat: originLatitude,
        originLng: originLongitude,
        destLat: destinationLatitude,
        destLng: destinationLongitude,
      );

      if (movementDirection == MovementDirection.vertical) {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.height * 0.3),
        );
      } else {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
        );
      }
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

      var movementDirection = compareLatLng(
        originLat: originLatitude,
        originLng: originLongitude,
        destLat: destinationLatitude,
        destLng: destinationLongitude,
      );

      if (movementDirection == MovementDirection.vertical) {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.height * 0.3),
        );
      } else {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
        );
      }
    }
  }

  MovementDirection compareLatLng({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) {
    final double deltaLat = (destLat - originLat).abs();
    final double deltaLng = (destLng - originLng).abs();

    if (deltaLat > deltaLng) {
      return MovementDirection.vertical;
    } else {
      return MovementDirection.horizontal;
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
                              height: 46,
                              width: MediaQuery.of(
                                navigatorKey.currentContext!,
                              ).size.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Color(0XFFE54C3F)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  try {
                                    await orderRepository.cancelOrder(
                                      orderType: orderType.value,
                                      orderId: orderId.value,
                                      language: languageServices
                                          .languageCodeSystem
                                          .value,
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
                                child: Text(
                                  languageServices.language.value.cancel ?? "-",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(color: Color(0XFFE54C3F)),
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

  Future<void> updateStateGrabOrder() async {
    try {
      await orderRepository.grabOrder(
        orderType: orderType.value,
        orderId: orderDetail.value.orderId.toString(),
        language: languageServices.languageCodeSystem.value,
      );
      await getOrderDetail();
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          e.toString(),
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);

      if ([
        "Better luck, next time!",
        "Semoga lain kali lebih beruntung!",
        "手速有点慢哦，订单已被抢啦！",
      ].contains(e.toString())) {
        Get.back();
      }
    } finally {
      // await refreshAll();
    }
  }

  // driverToOriginDirection & originToDestinationDirection
  Future<void> getAllRoutingCache({
    bool forceUpdateDriverToOrigin = false,
    bool forceUpdateDriverToDestination = false,
  }) async {
    var prefs = await SharedPreferences.getInstance();

    var driverToOriginDirectionCache = prefs.getString(
      'order_${orderDetail.value.orderId}_driver_to_origin_direction_cache_${orderDetail.value.driverId}',
    );
    var driverToDestinationDirectionCache = prefs.getString(
      'order_${orderDetail.value.orderId}_driver_to_destination_direction_cache_${orderDetail.value.driverId}',
    );

    var totalHitAPIGetDirectionDriverToOrigin =
        prefs.getInt(
          'order_${orderDetail.value.orderId}_driver_to_origin_total_hit_api_${orderDetail.value.driverId}',
        ) ??
        0;

    var totalHitAPIGetDirectionDriverToDestination =
        prefs.getInt(
          'order_${orderDetail.value.orderId}_driver_to_destination_total_hit_api_${orderDetail.value.driverId}',
        ) ??
        0;
    // var originToDestinationCache = prefs.getString(
    //   'order_${orderRideDetail.value.orderId}_origin_to_destination_direction_cache',
    // );

    if ([1, 2, 3, 4].contains(orderDetail.value.state)) {
      if (locationServices.currentLatitude.value != null) {
        if (driverToOriginDirectionCache == null ||
            forceUpdateDriverToOrigin == true) {
          driverToOriginDirection.value = await openMapsRepository.getDirection(
            originLatitude: locationServices.currentLatitude.value.toString(),
            originLongitude: locationServices.currentLongitude.value.toString(),
            destinationLatitude: orderDetail.value.startLat.toString(),
            destinationLongitude: orderDetail.value.startLon.toString(),
          );
          totalHitAPIGetDirectionDriverToOrigin += 1;
          await prefs.setString(
            'order_${orderDetail.value.orderId}_driver_to_origin_direction_cache_${orderDetail.value.driverId}',
            jsonEncode(driverToOriginDirection.value.toJson()),
          );
          await prefs.setInt(
            'order_${orderDetail.value.orderId}_driver_to_origin_total_hit_api_${orderDetail.value.driverId}',
            totalHitAPIGetDirectionDriverToOrigin,
          );
          this.totalHitAPIGetDirectionDriverToOrigin.value =
              totalHitAPIGetDirectionDriverToOrigin;
        } else {
          driverToOriginDirection.value =
              direction_model.OpenMapDirection.fromJson(
                jsonDecode(driverToOriginDirectionCache),
              );
        }
      }
    }

    if ([5, 6, 7, 8].contains(orderDetail.value.state)) {
      if (locationServices.currentLatitude.value != null) {
        if (driverToDestinationDirectionCache == null ||
            forceUpdateDriverToDestination == true) {
          driverToDestinationDirection
              .value = await openMapsRepository.getDirection(
            originLatitude: locationServices.currentLatitude.value.toString(),
            originLongitude: locationServices.currentLongitude.value.toString(),
            destinationLatitude: orderDetail.value.endLat.toString(),
            destinationLongitude: orderDetail.value.endLon.toString(),
          );
          totalHitAPIGetDirectionDriverToDestination += 1;
          await prefs.setString(
            'order_${orderDetail.value.orderId}_driver_to_destination_direction_cache_${orderDetail.value.driverId}',
            jsonEncode(driverToDestinationDirection.value.toJson()),
          );
          await prefs.setInt(
            'order_${orderDetail.value.orderId}_driver_to_destination_total_hit_api_${orderDetail.value.driverId}',
            totalHitAPIGetDirectionDriverToDestination,
          );
          this.totalHitAPIGetDirectionDriverToDestination.value =
              totalHitAPIGetDirectionDriverToDestination;
        } else {
          driverToDestinationDirection.value =
              direction_model.OpenMapDirection.fromJson(
                jsonDecode(driverToDestinationDirectionCache),
              );
        }
      }
    }

    // if (originToDestinationCache == null) {
    //   originToDestinationDirection.value = await openMapsRepository
    //       .getDirection(
    //         originLatitude: orderRideDetail.value.startLat.toString(),
    //         originLongitude: orderRideDetail.value.startLon.toString(),
    //         destinationLatitude: orderRideDetail.value.endLat.toString(),
    //         destinationLongitude: orderRideDetail.value.endLon.toString(),
    //       );

    //   await prefs.setString(
    //     'order_${orderRideDetail.value.orderId}_origin_to_destination_direction_cache',
    //     jsonEncode(originToDestinationDirection.value.toJson()),
    //   );
    // } else {
    //   originToDestinationDirection.value = direction_model
    //       .OpenMapDirection.fromJson(jsonDecode(originToDestinationCache));
    // }
  }

  Future<void> updateVisibility() async {
    // if ([1].contains(orderDetail.value.state)) {
    //   isDriverToOriginDirectionVisible.value = false;
    //   isOriginToDestinationDirectionVisible.value = false;
    //   isMarkerDriverVisible.value = false;
    //   isMarkerOriginVisible.value = false;
    //   isMarkerDestinationVisible.value = false;
    //   isPinLocationWaitingForDriverHide.value = false;
    // }

    if ([1, 2, 3, 4].contains(orderDetail.value.state)) {
      isDriverToOriginDirectionVisible.value = true;
      isOriginToDestinationDirectionVisible.value = true;
      isMarkerDriverVisible.value = true;
      isMarkerOriginVisible.value = true;
      isMarkerDestinationVisible.value = false;
      isPinLocationWaitingForDriverHide.value = true;
    }

    if ([5, 6, 7, 8].contains(orderDetail.value.state)) {
      isDriverToOriginDirectionVisible.value = false;
      isOriginToDestinationDirectionVisible.value = true;
      isMarkerDriverVisible.value = true;
      isMarkerOriginVisible.value = true;
      isMarkerDestinationVisible.value = true;
      isPinLocationWaitingForDriverHide.value = true;
    }
  }

  double getKmOnGoing() {
    var mileage = 0.0;

    if ([1, 2, 3, 4].contains(orderDetail.value.state)) {
      mileage =
          double.tryParse(
            socketDriverPositionData.value.reservationMileage ?? "0",
          ) ??
          0.0;
    }

    if ([5, 6, 7, 8].contains(orderDetail.value.state)) {
      mileage =
          double.tryParse(socketDriverPositionData.value.laveMileage ?? "0") ??
          0.0;
    }

    return mileage;
  }

  String getStatusOnGoing() {
    var statusOngoing = 'Penjemputan';

    if ([1, 2, 3, 4].contains(orderDetail.value.state)) {
      statusOngoing = 'Penjemputan';
    }

    if ([5, 6, 7, 8].contains(orderDetail.value.state)) {
      statusOngoing = 'Pengantaran';
    }

    return statusOngoing;
  }

  // markers
  Future<void> setupAllMarkers() async {
    if ([1].contains(orderDetail.value.state)) {
      // markers.clear();
    }

    if ([1, 2, 3, 4].contains(orderDetail.value.state)) {
      var driverMarkerId = MarkerId("driver");
      var driverNewMarker = Marker(
        markerId: driverMarkerId,
        position: LatLng(
          double.parse(locationServices.currentLatitude.value.toString()),
          double.parse(locationServices.currentLongitude.value.toString()),
        ),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(64, 106)),
          'assets/icons/icon_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: isMarkerDriverVisible.value,
      );
      upsertMarker(markerId: driverMarkerId, newMarker: driverNewMarker);

      var originMarkerId = MarkerId("origin");
      var originNewMarker = Marker(
        markerId: originMarkerId,
        position: LatLng(
          orderDetail.value.startLat!,
          orderDetail.value.startLon!,
        ),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(33, 39)),
          'assets/icons/icon_pinpoint_map_green.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: isMarkerOriginVisible.value,
      );
      upsertMarker(markerId: originMarkerId, newMarker: originNewMarker);
    }

    if ([5, 6, 7, 8].contains(orderDetail.value.state)) {
      var driverMarkerId = MarkerId("driver");
      var driverNewMarker = Marker(
        markerId: driverMarkerId,
        position: LatLng(
          double.parse(locationServices.currentLatitude.value.toString()),
          double.parse(locationServices.currentLongitude.value.toString()),
        ),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(64, 106)),
          'assets/icons/icon_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: isMarkerDriverVisible.value,
      );
      upsertMarker(markerId: driverMarkerId, newMarker: driverNewMarker);

      var originMarkerId = MarkerId("origin");
      var originNewMarker = Marker(
        markerId: originMarkerId,
        position: LatLng(
          orderDetail.value.startLat!,
          orderDetail.value.startLon!,
        ),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(33, 39)),
          'assets/icons/icon_pinpoint_map_green.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: isMarkerOriginVisible.value,
      );
      upsertMarker(markerId: originMarkerId, newMarker: originNewMarker);

      var destinationMarkerId = MarkerId("destination");
      var destinationNewMarker = Marker(
        markerId: destinationMarkerId,
        position: LatLng(orderDetail.value.endLat!, orderDetail.value.endLon!),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(33, 39)),
          'assets/icons/icon_pinpoint_map_red.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: isMarkerDestinationVisible.value,
      );
      upsertMarker(
        markerId: destinationMarkerId,
        newMarker: destinationNewMarker,
      );
    }
  }

  // googleMapController
  Future<void> updateCameraAutoFocus() async {
    // waiting driver accept
    // if ([1].contains(orderDetail.value.state)) {
    //   if (isClosed) return;
    //   await googleMapController.animateCamera(
    //     CameraUpdate.newLatLngZoom(
    //       LatLng(orderDetail.value.startLat!, orderDetail.value.startLon!),
    //       16,
    //     ),
    //   );
    // }

    var driverLatitude =
        (double.tryParse(locationServices.currentLatitude.value.toString()) ??
                0.0)
            .toInt();
    var driverLongitude =
        (double.tryParse(locationServices.currentLongitude.value.toString()) ??
                0.0)
            .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
      // driver to origin
      if ([1, 2, 3, 4].contains(orderDetail.value.state)) {
        LatLngBounds bounds;

        var originLatitude = locationServices.currentLatitude.value!;
        var originLongitude = locationServices.currentLongitude.value!;
        var destinationLatitude = orderDetail.value.startLat!;
        var destinationLongitude = orderDetail.value.startLon!;

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

        var movementDirection = compareLatLng(
          originLat: originLatitude,
          originLng: originLongitude,
          destLat: destinationLatitude,
          destLng: destinationLongitude,
        );

        if (isClosed) return;
        if (movementDirection == MovementDirection.vertical) {
          await googleMapController.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, Get.height * 0.3),
          );
        } else {
          await googleMapController.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
          );
        }
      }

      // driver to destination
      if ([5, 6, 7, 8].contains(orderDetail.value.state)) {
        LatLngBounds bounds;

        var originLatitude = locationServices.currentLatitude.value!;
        var originLongitude = locationServices.currentLongitude.value!;
        var destinationLatitude = orderDetail.value.endLat!;
        var destinationLongitude = orderDetail.value.endLon!;

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

        var movementDirection = compareLatLng(
          originLat: originLatitude,
          originLng: originLongitude,
          destLat: destinationLatitude,
          destLng: destinationLongitude,
        );

        if (isClosed) return;
        if (movementDirection == MovementDirection.vertical) {
          await googleMapController.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, Get.height * 0.3),
          );
        } else {
          await googleMapController.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
          );
        }
      }
    } else {
      if ([1, 2, 3, 4, 5, 6, 7, 8].contains(orderDetail.value.state)) {
        LatLngBounds bounds;

        var originLatitude = orderDetail.value.startLat!;
        var originLongitude = orderDetail.value.startLon!;
        var destinationLatitude = orderDetail.value.endLat!;
        var destinationLongitude = orderDetail.value.endLon!;

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

        var movementDirection = compareLatLng(
          originLat: originLatitude,
          originLng: originLongitude,
          destLat: destinationLatitude,
          destLng: destinationLongitude,
        );

        if (isClosed) return;
        if (movementDirection == MovementDirection.vertical) {
          await googleMapController.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, Get.height * 0.2),
          );
        } else {
          await googleMapController.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
          );
        }
      }
    }
  }

  // polylines & polylinesCoordinate
  Future<void> setupAllRouting() async {
    polylines.clear();
    polylinesCoordinate.clear();

    var driverLatitude =
        (double.tryParse(locationServices.currentLatitude.value.toString()) ??
                0.0)
            .toInt();
    var driverLongitude =
        (double.tryParse(locationServices.currentLongitude.value.toString()) ??
                0.0)
            .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
      // waiting driver accept
      // if ([1].contains(orderDetail.value.state)) {}

      // driver to origin
      if ([1, 2, 3, 4].contains(orderDetail.value.state)) {
        polylinesCoordinate.value = driverToOriginDirection
            .value
            .routes!
            .first
            .geometry!
            .coordinates!
            .map((p) => LatLng(p[1], p[0]))
            .toList();
        polylines.add(
          Polyline(
            polylineId: PolylineId("driver_to_origin_direction"),
            points: polylinesCoordinate,
            color: Color(0XFF4DABF5),
            width: 6,
            visible: isDriverToOriginDirectionVisible.value,
          ),
        );
      }

      // driver to destination
      if ([5, 6, 7, 8].contains(orderDetail.value.state)) {
        polylinesCoordinate.value = driverToDestinationDirection
            .value
            .routes!
            .first
            .geometry!
            .coordinates!
            .map((p) => LatLng(p[1], p[0]))
            .toList();
        polylines.add(
          Polyline(
            polylineId: PolylineId("driver_to_destination_direction"),
            points: polylinesCoordinate,
            color: Color(0XFF4DABF5),
            width: 6,
            visible: isDriverToDestinationDirectionVisible.value,
          ),
        );
      }
    }
  }

  Future<void> updateDriverPositionReducedPolyline() async {
    var driverLatitude =
        (double.tryParse(locationServices.currentLatitude.value.toString()) ??
                0.0)
            .toInt();
    var driverLongitude =
        (double.tryParse(locationServices.currentLongitude.value.toString()) ??
                0.0)
            .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
      var closestPointIndex = getClosestPointIndex(
        LatLng(
          double.parse(locationServices.currentLatitude.value.toString()),
          double.parse(locationServices.currentLongitude.value.toString()),
        ),
        polylinesCoordinate,
      );

      var closestIndex = closestPointIndex['index'];
      var minDistance = closestPointIndex['min_distance'];
      var threshold = 30.0;

      this.distanceFromNearestRoute.value = minDistance;

      if (minDistance < threshold && closestIndex > 0) {
        polylinesCoordinate.value = polylinesCoordinate.sublist(closestIndex);

        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: PolylineId("updated_polyline"),
            color: Color(0XFF4DABF5),
            width: 5,
            points: polylinesCoordinate,
          ),
        );
      }
    }
  }

  Future<void> updateDriverPositionReroutingOffRoute() async {
    var driverLatitude =
        (double.tryParse(locationServices.currentLatitude.value.toString()) ??
                0.0)
            .toInt();
    var driverLongitude =
        (double.tryParse(locationServices.currentLongitude.value.toString()) ??
                0.0)
            .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
      if (polylinesCoordinate.isNotEmpty) {
        var distanceFromRoute = getDistanceFromRoute(
          LatLng(
            double.parse(locationServices.currentLatitude.value.toString()),
            double.parse(locationServices.currentLongitude.value.toString()),
          ),
          polylinesCoordinate,
        );

        this.distanceFromRoute.value = distanceFromRoute;

        if (distanceFromRoute > 50) {
          if ([1, 2, 3, 4].contains(state.value)) {
            await getAllRoutingCache(forceUpdateDriverToOrigin: true);
            await setupAllRouting();
          }

          if ([5, 6, 7, 8].contains(state.value)) {
            await getAllRoutingCache(forceUpdateDriverToDestination: true);
            await setupAllRouting();
          }
        }
      }
    }
  }

  Future<void> handleSocketDriverPositionUser({
    required SocketDriverPositionData socketDriverPositionData,
  }) async {
    this.socketDriverPositionData.value = socketDriverPositionData;
  }

  Future<void> handleSocketDriverPosition() async {
    var driverLatitude =
        (double.tryParse(locationServices.currentLatitude.value.toString()) ??
                0.0)
            .toInt();
    var driverLongitude =
        (double.tryParse(locationServices.currentLongitude.value.toString()) ??
                0.0)
            .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
      var markerId = MarkerId("driver");
      var newMarker = Marker(
        markerId: markerId,
        position: LatLng(
          double.parse(locationServices.currentLatitude.value.toString()),
          double.parse(locationServices.currentLongitude.value.toString()),
        ),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(64, 106)),
          'assets/icons/icon_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: isMarkerDriverVisible.value,
      );
      upsertMarker(markerId: markerId, newMarker: newMarker);
      await updateDriverPositionReducedPolyline();
      await updateDriverPositionReroutingOffRoute();
      await updateCameraAutoFocus();
    }
  }

  Future<void> checkSendInvoice() async {
    if (orderDetail.value.state == 6) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute != Routes.ORDER_PAYMENT_CONFIRMATION &&
            Get.currentRoute != Routes.HOME) {
          Get.back();
          Get.toNamed(
            Routes.ORDER_PAYMENT_CONFIRMATION,
            arguments: {
              "order_id": orderId.value,
              "order_type": orderType.value,
            },
          );
        }
      });
    }

    if (orderDetail.value.state == 7 ||
        orderDetail.value.state == 8 ||
        orderDetail.value.state == 9) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute != Routes.ORDER_PAYMENT_CONFIRMATION &&
            Get.currentRoute != Routes.HOME) {
          Get.back();
          Get.toNamed(
            Routes.ORDER_PAYMENT_PENDING,
            arguments: {
              "order_id": orderId.value,
              "order_type": orderType.value,
            },
          );
        }
      });
    }
  }

  // Chat Room
  Future<void> streamExistingChatRoom() async {
    if (evmotoOrderChatParticipants.value.docId != null) {
      await streamEvmotoOrderChatParticipants?.cancel();
      streamEvmotoOrderChatParticipants = FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(evmotoOrderChatParticipants.value.docId)
          .snapshots()
          .listen((snapshots) {
            evmotoOrderChatParticipants.value =
                EvmotoOrderChatParticipants.fromJson(snapshots.data() ?? {});
            evmotoOrderChatParticipants.value.docId = snapshots.id;
          });
    }
  }

  Future<void> getExistingChatRoom() async {
    var result =
        (await FirebaseFirestore.instance
                .collection('evmoto_order_chat_participants')
                .where(
                  "orderId",
                  isEqualTo: orderDetail.value.orderId.toString(),
                )
                .where("userId", isEqualTo: orderDetail.value.userId.toString())
                .where(
                  "driverId",
                  isEqualTo: orderDetail.value.driverId.toString(),
                )
                .orderBy("createdAt", descending: true)
                .get())
            .docs;

    if (result.isNotEmpty) {
      evmotoOrderChatParticipants.value = EvmotoOrderChatParticipants.fromJson(
        result.first.data(),
      );
      evmotoOrderChatParticipants.value.docId = result.first.id;
    }
  }

  Future<void> userCreateChatRoom() async {
    if (orderDetail.value.userId != null &&
        orderDetail.value.driverId != null &&
        orderDetail.value.driverId != 0 &&
        orderDetail.value.orderId != null) {
      var evmotoOrderChatParticipantsList =
          (await FirebaseFirestore.instance
                  .collection('evmoto_order_chat_participants')
                  .where(
                    "orderId",
                    isEqualTo: orderDetail.value.orderId.toString(),
                  )
                  .where(
                    "userId",
                    isEqualTo: orderDetail.value.userId.toString(),
                  )
                  .where(
                    "driverId",
                    isEqualTo: orderDetail.value.driverId.toString(),
                  )
                  .get())
              .docs;

      if (evmotoOrderChatParticipantsList.isEmpty) {
        var data = {
          "orderId": orderDetail.value.orderId.toString(),
          "userId": orderDetail.value.userId.toString(),
          "userName": orderDetail.value.nickName,
          "userProfileUrl": orderDetail.value.userHeadImg,
          "driverId": orderDetail.value.driverId.toString(),
          "driverName": orderDetail.value.driverName,
          "driverProfileUrl": orderDetail.value.driverAvatar,
          "createdAt": FieldValue.serverTimestamp(),
        };

        // print("[DEBUG CHAT] $data");

        await getExistingChatRoom();
        if (evmotoOrderChatParticipants.value.docId == null) {
          await FirebaseFirestore.instance
              .collection('evmoto_order_chat_participants')
              .add(data);
          await getExistingChatRoom();
        }
      }
    }
  }

  Future<void> setChatOnline() async {
    await setChatOffline();

    if (orderDetail.value.driverId != null && orderDetail.value.driverId != 0) {
      final batch = FirebaseFirestore.instance.batch();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .where('orderId', isEqualTo: orderDetail.value.orderId.toString())
          .where('userId', isEqualTo: orderDetail.value.userId.toString())
          .where('driverId', isEqualTo: orderDetail.value.driverId.toString())
          .get();

      for (var doc in querySnapshot.docs) {
        batch.set(doc.reference, {
          "driverId": orderDetail.value.driverId.toString(),
          "driverName": orderDetail.value.driverName,
          "driverProfileUrl": orderDetail.value.driverAvatar,
          "driverIsOnline": true,
          "driverLastSeen": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
    }
  }

  Future<void> setChatOffline() async {
    final batch = FirebaseFirestore.instance.batch();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .where('orderId', isEqualTo: orderDetail.value.orderId.toString())
        .get();

    for (var doc in querySnapshot.docs) {
      batch.set(doc.reference, {
        "driverId": orderDetail.value.driverId.toString(),
        "driverName": orderDetail.value.driverName,
        "driverProfileUrl": orderDetail.value.driverAvatar,
        "driverIsOnline": false,
        "driverLastSeen": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  Future<void> streamExistingChatList() async {
    await streamEvmotoOrderChatMessages?.cancel();
    streamEvmotoOrderChatMessages = FirebaseFirestore.instance
        .collection('evmoto_order_chat_messages')
        .where(
          'evmotoOrderChatParticipantsDocumentId',
          isEqualTo: evmotoOrderChatParticipants.value.docId,
        )
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshots) async {
          var evmotoOrderChatMessagesList = <EvmotoOrderChatMessages>[];
          for (var doc in snapshots.docs) {
            var evmotoOrderChatMessages = EvmotoOrderChatMessages.fromJson(
              doc.data(),
            );
            evmotoOrderChatMessages.evmotoOrderChatMessagesId = doc.id;
            evmotoOrderChatMessagesList.add(evmotoOrderChatMessages);
          }
          this.evmotoOrderChatMessagesList.value = evmotoOrderChatMessagesList;
        });
  }
}

enum MovementDirection { vertical, horizontal }
