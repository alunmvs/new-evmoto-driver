import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

class AccountController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final socketServices = Get.find<SocketServices>();

  final homeController = Get.find<HomeController>();

  final packageVersion = "".obs;

  final isFetch = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isFetch.value = true;
    await getPackageInfo();
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

  Future<void> getPackageInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    packageVersion.value = packageInfo.version;
  }

  Future<void> onTapShareAppLink() async {
    var shareParams = ShareParams(
      uri: Uri.parse(
        "https://play.google.com/store/apps/details?id=com.driver.evmototrip",
      ),
    );

    await SharePlus.instance.share(shareParams);
  }

  Future<void> onTapLogout() async {
    await Get.dialog(
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
                        "Apakah Anda yakin ingin keluar akun?",
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
                                  "Batal",
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
                                  var storage = FlutterSecureStorage();
                                  await storage.deleteAll();
                                  await socketServices.closeWebsocket();

                                  Get.offAllNamed(Routes.LOGIN);

                                  var snackBar = SnackBar(
                                    behavior: SnackBarBehavior.fixed,
                                    backgroundColor: themeColorServices
                                        .sematicColorGreen400
                                        .value,
                                    content: Text(
                                      "Berhasil keluar akun",
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
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColorServices
                                      .sematicColorRed400
                                      .value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  "Keluar",
                                  style: typographyServices.bodySmallBold.value
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
