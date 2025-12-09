import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/bitmap_descriptor_helper.dart';
import 'package:new_evmoto_driver/app/utils/google_maps_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailController extends GetxController {
  final OrderRepository orderRepository;
  final GoogleMapsRepository googleMapsRepository;

  OrderDetailController({
    required this.orderRepository,
    required this.googleMapsRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
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

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'].toString();
    orderType.value = Get.arguments['order_type'];
    await requestLocation();
    await getOrderDetail();
    isFetch.value = false;

    if (orderDetail.value.state == 2 || orderDetail.value.state == 3) {
      await setupGoogleMapsPickUpCustomer();
    }

    if (orderDetail.value.state == 4 || orderDetail.value.state == 5) {
      await setupGoogleMapOriginToDestination();
    }

    await Future.wait([setupSchedulerDriverCurrentLocation()]);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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

    var googleDirectionList = await googleMapsRepository.getDirection(
      originLatitude: currentLatitude.value,
      originLongitude: currentLongitude.value,
      destinationLatitude: orderDetail.value.startLat.toString(),
      destinationLongitude: orderDetail.value.startLon.toString(),
      region: "en",
    );

    var result = PolylinePoints.decodePolyline(
      googleDirectionList.first.overviewPolyline!.points!,
    );
    var polylineCoordinates = result
        .map((p) => LatLng(p.latitude, p.longitude))
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
      CameraUpdate.newLatLngBounds(bounds, 200),
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
        double.parse(currentLatitude.value),
        double.parse(currentLongitude.value),
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

    var googleDirectionList = await googleMapsRepository.getDirection(
      originLatitude: orderDetail.value.startLat.toString(),
      originLongitude: orderDetail.value.startLon.toString(),
      destinationLatitude: orderDetail.value.endLat.toString(),
      destinationLongitude: orderDetail.value.endLon.toString(),
      region: "en",
    );

    var result = PolylinePoints.decodePolyline(
      googleDirectionList.first.overviewPolyline!.points!,
    );
    var polylineCoordinates = result
        .map((p) => LatLng(p.latitude, p.longitude))
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

        var googleDirectionList = await googleMapsRepository.getDirection(
          originLatitude: currentLatitude.value,
          originLongitude: currentLongitude.value,
          destinationLatitude: orderDetail.value.startLat.toString(),
          destinationLongitude: orderDetail.value.startLon.toString(),
          region: "en",
        );

        var result = PolylinePoints.decodePolyline(
          googleDirectionList.first.overviewPolyline!.points!,
        );
        var polylineCoordinates = result
            .map((p) => LatLng(p.latitude, p.longitude))
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
          CameraUpdate.newLatLngBounds(bounds, 200),
        );
      }

      if (orderDetail.value.state == 5) {
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

        var googleDirectionList = await googleMapsRepository.getDirection(
          originLatitude: currentLatitude.value,
          originLongitude: currentLongitude.value,
          destinationLatitude: orderDetail.value.endLat.toString(),
          destinationLongitude: orderDetail.value.endLon.toString(),
          region: "en",
        );

        var result = PolylinePoints.decodePolyline(
          googleDirectionList.first.overviewPolyline!.points!,
        );
        var polylineCoordinates = result
            .map((p) => LatLng(p.latitude, p.longitude))
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
          CameraUpdate.newLatLngBounds(bounds, 200),
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
          color: Colors.blue,
          width: 5,
          points: polylinesCoordinate,
        ),
      );
    }
  }

  Future<void> updateStateStartOrderTrip() async {
    var locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    var position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    await orderRepository.setOrderState(
      orderType: orderType.value,
      orderId: orderId.value,
      lat: position.latitude.toString(),
      lon: position.longitude.toString(),
      language: 2,
      state: 3,
    );

    await getOrderDetail();

    await setupGoogleMapsPickUpCustomer();
  }

  Future<void> updateStateArrivedOrigin() async {
    var locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    var position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    await orderRepository.setOrderState(
      orderType: orderType.value,
      orderId: orderId.value,
      lat: position.latitude.toString(),
      lon: position.longitude.toString(),
      language: 2,
      state: 4,
    );

    await getOrderDetail();
    await setupGoogleMapOriginToDestination();
  }

  Future<void> updateStateOnProgress() async {
    var locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    var position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    await orderRepository.setOrderState(
      orderType: orderType.value,
      orderId: orderId.value,
      lat: position.latitude.toString(),
      lon: position.longitude.toString(),
      language: 2,
      state: 5,
    );

    await getOrderDetail();
    await setupGoogleMapOriginToDestination();
  }

  Future<void> updateStateArrivedAtDestination() async {
    var locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    var position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    await orderRepository.setOrderState(
      orderType: orderType.value,
      orderId: orderId.value,
      lat: position.latitude.toString(),
      lon: position.longitude.toString(),
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

      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 200),
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
      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 200),
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
                                    Get.showSnackbar(
                                      GetSnackBar(
                                        duration: Duration(seconds: 2),
                                        backgroundColor: themeColorServices
                                            .sematicColorGreen400
                                            .value,
                                        snackPosition: SnackPosition.TOP,
                                        snackStyle: SnackStyle.GROUNDED,
                                        messageText: Text(
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
                                      ),
                                    );
                                  } catch (e) {
                                    Get.showSnackbar(
                                      GetSnackBar(
                                        duration: Duration(seconds: 2),
                                        backgroundColor: themeColorServices
                                            .sematicColorRed400
                                            .value,
                                        snackPosition: SnackPosition.TOP,
                                        snackStyle: SnackStyle.GROUNDED,
                                        messageText: Text(
                                          e.toString(),
                                          style: typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                              ),
                                        ),
                                      ),
                                    );
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
