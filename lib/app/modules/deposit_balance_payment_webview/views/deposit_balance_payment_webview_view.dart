import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/deposit_balance_payment_webview_controller.dart';

class DepositBalancePaymentWebviewView
    extends GetView<DepositBalancePaymentWebviewController> {
  const DepositBalancePaymentWebviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop == false) {
          await controller.showDialogBackButton();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.showDialogBackButton();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: controller
                            .themeColorServices
                            .overlayDark200
                            .value
                            .withValues(alpha: 0.15),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_arrow_left.svg",
                        width: 22,
                        height: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: WebViewWidget(controller: controller.webViewController),
      ),
    );
  }
}
