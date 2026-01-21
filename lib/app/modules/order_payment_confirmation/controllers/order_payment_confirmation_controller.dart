import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_payment_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:reactive_forms/reactive_forms.dart';

class OrderPaymentConfirmationController extends GetxController {
  final OrderRepository orderRepository;

  OrderPaymentConfirmationController({required this.orderRepository});

  final formGroup = FormGroup({
    "additional_charge": FormControl<String>(validators: <Validator>[]),
    "surcharge_description": FormControl<String>(validators: <Validator>[]),
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final refreshController = RefreshController();

  final orderId = "".obs;
  final orderType = 0.obs;
  final orderDetail = OrderDetail().obs;
  final orderPayment = OrderPayment().obs;

  final subcharge = 0.obs;

  final isInformationShow = false.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'].toString();
    orderType.value = Get.arguments['order_type'];
    await getOrderDetail();
    await getOrderPayment();
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

  Future<void> refreshAll() async {
    await getOrderDetail();
    await getOrderPayment();
  }

  Future<void> getOrderDetail() async {
    orderDetail.value = await orderRepository.getOrderDetail(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
    );
  }

  Future<void> getOrderPayment() async {
    orderPayment.value = await orderRepository.getOrderPayment(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
      payManner: orderDetail.value.payManner!,
    );
  }

  Future<void> confirmCashReceived() async {
    await orderRepository.confirmCashReceived(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
    );
  }

  Future<void> onTapConfirmPayment() async {
    await orderRepository.confirmOrderPayment(
      orderType: orderType.value,
      orderId: orderId.value,
      language: 2,
      payManner: orderDetail.value.payManner!,
      additionalCharge: formGroup.control("additional_charge").value == null
          ? 0
          : int.tryParse(
                  formGroup
                      .control("additional_charge")
                      .value
                      .toString()
                      .replaceAll("Rp", "")
                      .replaceAll(".", ""),
                ) ??
                0,
      surchargeDescription: formGroup.control("surcharge_description").value,
    );

    await refreshAll();
  }

  Future<void> onTapConfirmCashReceived() async {
    try {
      await orderRepository.confirmCashReceived(
        orderType: orderType.value,
        orderId: orderId.value,
        language: 2,
      );

      Get.back();
      Get.back();
      Get.find<HomeController>().refreshAll();

      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorGreen400.value,
        content: Text(
          "Pesanan berhasil diselesaikan",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
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
    }
  }

  Future<void> onTapCompleteOrderDirect() async {
    try {
      await orderRepository.completeOrderDirect(
        orderType: orderType.value,
        orderId: orderId.value,
        language: languageServices.languageCodeSystem.value,
        payType: orderDetail.value.payType!,
        additionalCharge: formGroup.control("additional_charge").value == null
            ? 0
            : int.tryParse(
                    formGroup
                        .control("additional_charge")
                        .value
                        .toString()
                        .replaceAll("Rp", "")
                        .replaceAll(".", ""),
                  ) ??
                  0,
        surchargeDescription: formGroup.control("surcharge_description").value,
      );

      Get.back();
      Get.back();
      Get.find<HomeController>().refreshAll();

      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorGreen400.value,
        content: Text(
          "Pesanan berhasil diselesaikan",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
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
    }
  }

  String getPaymentMethodName() {
    if (orderDetail.value.payType == 3) {
      return 'Cash';
    } else if (orderDetail.value.payType == 2) {
      return 'Saldo EVMoto';
    }
    return '';
  }
}
