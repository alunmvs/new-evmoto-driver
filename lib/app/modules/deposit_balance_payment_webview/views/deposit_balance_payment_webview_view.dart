import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/deposit_balance_payment_webview_controller.dart';

class DepositBalancePaymentWebviewView
    extends GetView<DepositBalancePaymentWebviewController> {
  const DepositBalancePaymentWebviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: controller.rechargeStatusCompleted.value,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop == false &&
              controller.rechargeStatusCompleted.value == false) {
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      border: Border.all(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey300
                            .value,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: controller
                              .themeColorServices
                              .overlayDark200
                              .value
                              .withValues(alpha: 0.3),
                          blurRadius: 32,
                          spreadRadius: -6,
                          offset: Offset(0, -1),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_back.svg",
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          body: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(controller.redirectUrl.value),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useOnDownloadStart: true,
            ),
            onWebViewCreated: (controller) {
              this.controller.webViewController = controller;

              controller.addJavaScriptHandler(
                handlerName: 'saveBlob',
                callback: (args) async {
                  final base64Data = args[0];
                  final mimeType = args[1];
                  await _saveFile(base64Data, mimeType);
                },
              );
            },
            onDownloadStartRequest:
                (localController, downloadStartRequest) async {
                  final url = downloadStartRequest.url.toString();

                  if (url.startsWith("data:image")) {
                    if (controller.isLoadingDownloadBlob.value == false) {
                      controller.isLoadingDownloadBlob.value = true;
                      try {
                        final base64Data = url.split(",").last;

                        final bytes = base64Decode(base64Data);

                        final dir = await getApplicationDocumentsDirectory();
                        final file = File("${dir.path}/download.png");

                        await file.writeAsBytes(bytes);

                        final success = await GallerySaver.saveImage(file.path);

                        if (success == true) {
                          SnackbarHelper.showSnackbarSuccess(
                            text: "Berhasil menyimpan gambar pada gallery",
                          );
                        }

                        await file.delete();
                      } catch (e) {}
                    } else {
                      SnackbarHelper.showSnackbarError(
                        text:
                            "Tidak memiliki akses menyimpan gambar ke gallery",
                      );
                    }
                  }
                },
            onLoadStop: (controller, url) async {
              await controller.evaluateJavascript(
                source: '''
    (function () {
      document.addEventListener('click', function (e) {
    const a = e.target.closest('a');
    if (!a) return;
    
    if (a.href.startsWith('blob:')) {
      e.preventDefault();
    
      fetch(a.href)
        .then(res => res.blob())
        .then(blob => {
          const reader = new FileReader();
          reader.onloadend = function () {
            window.flutter_inappwebview
              .callHandler('saveBlob', reader.result, blob.type);
          };
          reader.readAsDataURL(blob);
        });
    }
      }, true);
    })();
    ''',
              );
            },
            shouldOverrideUrlLoading:
                (webviewController, navigationAction) async {
                  final uri = navigationAction.request.url!;

                  if (uri.scheme == "intent" ||
                      !["http", "https"].contains(uri.scheme)) {
                    await controller.handleIntent(uri.toString());
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (uri.queryParameters['action'].toString() == "back") {
                    await controller.showDialogBackButton();
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (uri.queryParameters['transaction_status'].toString() ==
                      "settlement") {
                    Get.back();
                    Get.back();
                    SnackbarHelper.showSnackbarSuccess(
                      text: "Saldo berhasil ditambah",
                    );
                    return NavigationActionPolicy.CANCEL;
                  } else if (uri.queryParameters['action'].toString() ==
                      "abandoned") {
                    Get.back();
                    SnackbarHelper.showSnackbarError(
                      text: "Transaksi kedaluwarsa",
                    );
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
          ),
          bottomNavigationBar: controller.rechargeStatusCompleted.value == false
              ? null
              : BottomAppBar(
                  height: 78,
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoaderElevatedButton(
                        onPressed: () async {
                          Get.back();
                        },
                        child: Text(
                          "OK",
                          style: controller
                              .typographyServices
                              .bodySmallBold
                              .value
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _saveFile(String base64, String mime) async {
    if (controller.isLoadingDownloadBlob.value == false) {
      controller.isLoadingDownloadBlob.value = true;
      var granted = await requestGalleryPermission();
      if (granted) {
        final bytes = base64Decode(base64.split(',').last);
        final dir = await getApplicationDocumentsDirectory();

        final extension = mime.split('/').last;
        final file = File('${dir.path}/temp_download.$extension');

        await file.writeAsBytes(bytes);

        final success = await GallerySaver.saveImage(file.path);

        if (success == true) {
          SnackbarHelper.showSnackbarSuccess(
            text: "Berhasil menyimpan gambar pada gallery",
          );
        }

        await file.delete();
      } else {
        SnackbarHelper.showSnackbarError(
          text: "Tidak memiliki akses menyimpan gambar ke gallery",
        );
      }
      controller.isLoadingDownloadBlob.value = false;
    }
  }
}

Future<bool> requestGalleryPermission() async {
  if (Platform.isIOS) {
    final status = await Permission.photos.request();
    return status.isGranted || status.isLimited;
  }

  if (Platform.isAndroid) {
    if (await Permission.photos.isGranted) {
      return true;
    }

    if (await Permission.storage.isGranted) {
      return true;
    }

    // Request sesuai versi
    final status = await Permission.photos.request();
    if (status.isGranted) return true;

    final legacy = await Permission.storage.request();
    return legacy.isGranted;
  }

  return false;
}
