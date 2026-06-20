import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class OrderPaymentPendingFeeDetailController extends GetxController {
  final OrderRepository orderRepository;

  OrderPaymentPendingFeeDetailController({required this.orderRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final orderDetail = OrderDetail().obs;

  final orderId = "".obs;
  final orderType = 0.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;

    orderId.value = Get.arguments['order_id'].toString();
    orderType.value = Get.arguments['order_type'];

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

  Future<void> getOrderDetail() async {
    orderDetail.value = await orderRepository.getOrderDetail(
      orderType: orderType.value,
      orderId: orderId.value,
      language: languageServices.languageCodeSystem.value,
    );
  }

  String formatCurrency(double? amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount ?? 0);
  }

  String formatKm(double? value) {
    if (value == null) return '0';
    final formatted = value.toStringAsFixed(2);
    if (formatted.endsWith('.00')) {
      return value.toStringAsFixed(0);
    }
    if (formatted.endsWith('0')) {
      return value.toStringAsFixed(1);
    }
    return formatted;
  }

  int get driverSharePercentage {
    final platformFee = orderDetail.value.platformFeePercentage ?? 0;
    return (100 - platformFee).round();
  }

  String getPaymentMethodName() {
    if (orderDetail.value.payType == 3) {
      return 'Cash';
    } else if (orderDetail.value.payType == 2) {
      return 'Saldo EVMoto';
    } else if (orderDetail.value.payType == 4) {
      return 'GoPay';
    }
    return '-';
  }

  String? get surchargeSubLabel {
    final description = orderDetail.value.surchargeFeeDescription;
    if (description == null || description.isEmpty) return null;
    return '($description)';
  }
}
