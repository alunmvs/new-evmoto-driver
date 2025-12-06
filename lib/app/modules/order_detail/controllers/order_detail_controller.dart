import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_driver/app/data/order_detail_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class OrderDetailController extends GetxController {
  final OrderRepository orderRepository;

  OrderDetailController({required this.orderRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  ).obs;
  late GoogleMapController googleMapController;

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;

  final currentLatitude = "".obs;
  final currentLongitude = "".obs;

  final orderId = "".obs;
  final orderType = 0.obs;
  final orderDetail = OrderDetail().obs;

  final isInformationShow = false.obs;

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
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> requestLocation() async {
    var isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.requestPermission();

    if (isLocationServiceEnabled == false ||
        (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever)) {
      return;
    }
  }

  Future<void> getOrderDetail() async {
    orderDetail.value = await orderRepository.getOrderDetail(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
    );
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
}
