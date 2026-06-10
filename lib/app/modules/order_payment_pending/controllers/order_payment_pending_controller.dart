import 'dart:async';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_user_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';

class OrderPaymentPendingController extends GetxController {
  final OrderRepository orderRepository;

  OrderPaymentPendingController({required this.orderRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final orderDetail = OrderDetail().obs;
  final orderUser = OrderUser().obs;

  final orderId = "".obs;
  final orderType = 0.obs;

  Timer? refreshOrderStateTimer;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;

    orderId.value = Get.arguments['order_id'].toString();
    orderType.value = Get.arguments['order_type'];

    await getOrderDetail();
    await getOrderUserDetail();

    refreshOrderStateTimer = Timer.periodic(Duration(seconds: 3), (
      timer,
    ) async {
      await getOrderDetail();
    });

    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    refreshOrderStateTimer?.cancel();
  }

  Future<void> getOrderUserDetail() async {
    orderUser.value = await orderRepository.getOrderUserDetail(
      orderType: orderType.value,
      orderId: orderId.value,
    );
  }

  Future<void> getOrderDetail() async {
    orderDetail.value = await orderRepository.getOrderDetail(
      orderType: orderType.value,
      orderId: orderId.value,
      language: languageServices.languageCodeSystem.value,
    );
  }

  Future<void> onTapCashCollected() async {
    await orderRepository.cashCollected(
      language: languageServices.languageCodeSystem.value,
      orderId: orderId.value,
    );
    await getOrderDetail();
    Get.back();
    SnackbarHelper.showSnackbarSuccess(
      text: "Anda telah menyelesaikan perjalanan ini.",
    );
  }
}
