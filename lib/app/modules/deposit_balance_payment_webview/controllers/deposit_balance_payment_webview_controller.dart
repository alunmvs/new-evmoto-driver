import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/payment_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DepositBalancePaymentWebviewController extends GetxController {
  final PaymentRepository paymentRepository;

  DepositBalancePaymentWebviewController({required this.paymentRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final webViewController = WebViewController();

  final redirectUrl = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    redirectUrl.value = Get.arguments['redirect_url'] ?? "";
    await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await webViewController.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) async {
          var uri = Uri.parse(request.url);
          await paymentRepository.redirectUrlDepositBalance(
            orderId: uri.queryParameters['order_id'].toString(),
            statusCode: uri.queryParameters['status_code'].toString(),
            transactionStatus: uri.queryParameters['transaction_status']
                .toString(),
          );
          Get.back();
          Get.back();
          Get.showSnackbar(
            GetSnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: themeColorServices.sematicColorGreen400.value,
              snackPosition: SnackPosition.TOP,
              snackStyle: SnackStyle.GROUNDED,
              messageText: Text(
                "Saldo berhasil ditambah",
                style: typographyServices.bodySmallRegular.value.copyWith(
                  color: themeColorServices.neutralsColorGrey0.value,
                ),
              ),
            ),
          );
          return NavigationDecision.prevent;
        },
      ),
    );

    await webViewController.loadRequest(Uri.parse(redirectUrl.value));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
