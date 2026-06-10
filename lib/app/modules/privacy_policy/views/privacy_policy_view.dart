import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';

import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Kebijakan Privasi",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        // body: controller.isFetch.value
        //     ? Center(
        //         child: SizedBox(
        //           width: 25,
        //           height: 25,
        //           child: CircularProgressIndicator(
        //             color: controller.themeColorServices.primaryBlue.value,
        //           ),
        //         ),
        //       )
        //     : Html(data: controller.agreement.value.content),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(controller.privacyPolicyUrl.value),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            useOnDownloadStart: true,
          ),
          shouldOverrideUrlLoading:
              (webviewController, navigationAction) async {
                final requestedUrl =
                    navigationAction.request.url?.toString() ?? '';

                final allowedUrl = controller.privacyPolicyUrl.value;

                // Hanya izinkan URL awal
                if (requestedUrl == allowedUrl) {
                  return NavigationActionPolicy.ALLOW;
                }

                return NavigationActionPolicy.CANCEL;
              },
          onLoadStart: (webviewController, url) async {
            if (url?.toString() != controller.privacyPolicyUrl.value) {
              await webviewController.stopLoading();

              await webviewController.loadUrl(
                urlRequest: URLRequest(
                  url: WebUri(controller.privacyPolicyUrl.value),
                ),
              );
            }
          },
          onUpdateVisitedHistory: (webviewController, url, isReload) async {
            if (url?.toString() != controller.privacyPolicyUrl.value) {
              await webviewController.loadUrl(
                urlRequest: URLRequest(
                  url: WebUri(controller.privacyPolicyUrl.value),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
