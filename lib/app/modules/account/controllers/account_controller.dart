import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/otp_repository.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountController extends GetxController {
  final OtpRepository otpRepository;
  final UserRepository userRepository;

  AccountController({
    required this.otpRepository,
    required this.userRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final socketServices = Get.find<SocketServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final languageServices = Get.find<LanguageServices>();

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

  Future<void> onTapShareAppLink({required BuildContext context}) async {
    final box = context.findRenderObject() as RenderBox?;

    if (Platform.isAndroid) {
      var shareParams = ShareParams(
        uri: Uri.parse(
          firebaseRemoteConfigServices.remoteConfig.getString(
            "driver_playstore_link",
          ),
        ),
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      await SharePlus.instance.share(shareParams);
    } else if (Platform.isIOS) {
      var shareParams = ShareParams(
        uri: Uri.parse(
          firebaseRemoteConfigServices.remoteConfig.getString(
            "driver_appstore_link",
          ),
        ),
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      await SharePlus.instance.share(shareParams);
    }
  }

  Future<void> onTapLogout() async {
    await Get.bottomSheet(
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: Container(
                padding: EdgeInsets.all(16),
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Color(0XFFD7EAFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_account_logout.svg",
                            width: 26,
                            height: 26,
                            color: Color(0XFF0573EA),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Yakin Ingin Keluar Dari Akun?",
                      style: typographyServices.bodyLargeBold.value,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Anda akan keluar dari akun ini dan perlu masuk kembali untuk menggunakan layanan.",
                      style: typographyServices.bodySmallRegular.value.copyWith(
                        color: Color(0XFFB3B3B3),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
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
                            backgroundColor:
                                themeColorServices.sematicColorGreen400.value,
                            content: Text(
                              "Berhasil keluar akun",
                              style: typographyServices.bodySmallRegular.value
                                  .copyWith(
                                    color: themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                  ),
                            ),
                          );
                          rootScaffoldMessengerKey.currentState?.showSnackBar(
                            snackBar,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColorServices.primaryBlue.value,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Keluar Sekarang",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(
                                color:
                                    themeColorServices.neutralsColorGrey0.value,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: Get.width,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.close(1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Batalkan",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(
                                color: themeColorServices.textColor.value,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      isDismissible: true,
    );
  }

  Future<void> onTapDeleteAccount() async {
    await Get.bottomSheet(
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: Container(
                padding: EdgeInsets.all(16),
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Color(0XFFFFEAE9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_delete_filled.svg",
                            width: 26,
                            height: 26,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Yakin Ingin Mengajukan Penghapusan Akun?",
                      style: typographyServices.bodyLargeBold.value,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Penghapusan akun driver akan diproses setelah seluruh kewajiban diselesaikan dan proses verifikasi selesai. Selama proses ini, akun tidak dapat digunakan untuk menerima order.",
                      style: typographyServices.bodySmallRegular.value.copyWith(
                        color: Color(0XFFB3B3B3),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: Get.width,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.close(1);
                          await onTapValidateOtpDeleteAccount();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              themeColorServices.sematicColorRed400.value,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Hapus Sekarang",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(
                                color:
                                    themeColorServices.neutralsColorGrey0.value,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: Get.width,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.close(1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Batalkan",
                          style: typographyServices.bodyLargeBold.value
                              .copyWith(
                                color: themeColorServices.textColor.value,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      isDismissible: true,
    );
  }

  Future<void> onTapContactCs() async {
    var driverCsWhatsapp = firebaseRemoteConfigServices.remoteConfig.getString(
      "driver_cs_whatsapp",
    );
    final Uri url = Uri.parse("https://wa.me/$driverCsWhatsapp");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      final SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: themeColorServices.sematicColorRed400.value,
        content: Text(
          "Tidak dapat membuka whatsapp",
          style: typographyServices.bodySmallRegular.value.copyWith(
            color: themeColorServices.neutralsColorGrey0.value,
          ),
        ),
      );
      rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }

  Future<void> onTapManageAccount() async {
    await Get.bottomSheet(
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: Container(
                padding: EdgeInsets.all(16),
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kelola Akun",
                      style: typographyServices.bodyLargeBold.value,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Kelola akses akun driver, keluar dari aplikasi, atau ajukan penghapusan akun.",
                      style: typographyServices.bodySmallRegular.value.copyWith(
                        color: Color(0XFFB3B3B3),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0XFFE8E8E8)),
                      ),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: GestureDetector(
                              onTap: () async {
                                Get.close(1);
                                await onTapLogout();
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_account_logout.svg",
                                          width: 22,
                                          height: 22,
                                          color: Color(0XFF0573EA),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Keluar dari Akun",
                                            style: typographyServices
                                                .bodySmallBold
                                                .value,
                                          ),
                                          Text(
                                            "Keluar dari akun driver untuk mengamankan akses di perangkat ini.",
                                            style: typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFFB3B3B3),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 6,
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          IntrinsicHeight(
                            child: GestureDetector(
                              onTap: () async {
                                Get.close(1);
                                await onTapDeleteAccount();
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_delete_filled.svg",
                                          width: 22,
                                          height: 22,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hapus Akun",
                                            style: typographyServices
                                                .bodySmallBold
                                                .value,
                                          ),
                                          Text(
                                            "Ajukan penghapusan akun driver setelah seluruh kewajiban dan proses verifikasi diselesaikan.",
                                            style: typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFFB3B3B3),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_arrow_right.svg",
                                            width: 6,
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      isDismissible: true,
    );
  }

  Future<void> onTapValidateOtpDeleteAccount() async {
    final otpCode = "".obs;
    final errorMessage = "".obs;
    final isButtonResendEnable = false.obs;

    await otpRepository.requestOTP(
      phone: homeController.userInfo.value.phone,
      language: languageServices.languageCodeSystem.value,
      type: 6,
    );

    await Get.bottomSheet(
      Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Color(0XFFDEEEFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_security_lock.svg",
                                width: 36,
                                height: 36,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Masukkan Kode OTP",
                        style: typographyServices.bodyLargeBold.value,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Untuk mengonfirmasi penghapusan akun Anda",
                        style: typographyServices.bodySmallRegular.value
                            .copyWith(color: Color(0XFFB3B3B3)),
                      ),
                      SizedBox(height: 16),
                      Pinput(
                        defaultPinTheme: PinTheme(
                          textStyle: typographyServices.headingMediumBold.value
                              .copyWith(
                                color: themeColorServices.primaryBlue.value,
                              ),
                          width: Get.width * (83 / 375),
                          height: 52 + 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: themeColorServices.primaryBlue.value,
                            ),
                          ),
                        ),
                        onCompleted: (pin) async {
                          otpCode.value = pin;
                        },
                      ),
                      if (errorMessage.value != "") ...[
                        SizedBox(height: 16),
                        Text(
                          errorMessage.value,
                          style: typographyServices.bodySmallRegular.value
                              .copyWith(
                                color:
                                    themeColorServices.sematicColorRed400.value,
                              ),
                        ),
                      ],
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isButtonResendEnable.value == false) ...[
                            SlideCountdown(
                              duration: Duration(minutes: 1),
                              countUp: false,
                              separatorStyle: typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color:
                                        themeColorServices.forthTextColor.value,
                                  ),
                              shouldShowMinutes: (value) {
                                return true;
                              },
                              onDone: () {
                                isButtonResendEnable.value = true;
                              },
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.all(0),
                              style: typographyServices.bodySmallRegular.value
                                  .copyWith(
                                    color:
                                        themeColorServices.forthTextColor.value,
                                  ),
                            ),
                          ],
                          SizedBox(width: 10),
                          SizedBox(
                            height: 34,
                            child: ElevatedButton(
                              onPressed: isButtonResendEnable.value
                                  ? () async {
                                      await otpRepository.requestOTP(
                                        phone:
                                            homeController.userInfo.value.phone,
                                        language: languageServices
                                            .languageCodeSystem
                                            .value,
                                        type: 6,
                                      );
                                      isButtonResendEnable.value = false;
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                backgroundColor:
                                    themeColorServices.primaryBlue.value,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                languageServices
                                        .language
                                        .value
                                        .resendVerificationCode ??
                                    "-",
                                style: typographyServices.bodySmallBold.value
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16 * 3),
                      SizedBox(
                        width: Get.width,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: otpCode.value.length != 4
                              ? null
                              : () async {
                                  Get.close(1);
                                  try {
                                    await userRepository.deleteAccount(
                                      otpCode: otpCode.value,
                                    );
                                  } catch (e) {
                                    final SnackBar snackBar = SnackBar(
                                      behavior: SnackBarBehavior.fixed,
                                      backgroundColor: themeColorServices
                                          .sematicColorRed400
                                          .value,
                                      content: Text(
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
                                    );
                                    rootScaffoldMessengerKey.currentState
                                        ?.showSnackBar(snackBar);
                                    return;
                                  }
                                  await onTapSuccessDeleteAccountDialog();

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
                                      "Berhasil menghapus akun",
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
                            backgroundColor:
                                themeColorServices.primaryBlue.value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Konfirmasi OTP",
                            style: typographyServices.bodyLargeBold.value
                                .copyWith(
                                  color: themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: Get.width,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () async {
                            Get.close(1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Batalkan",
                            style: typographyServices.bodyLargeBold.value
                                .copyWith(
                                  color: themeColorServices.textColor.value,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isDismissible: true,
    );
  }

  Future<void> onTapSuccessDeleteAccountDialog() async {
    Get.dialog(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Color(0XFFDDFFE6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_checkmark_circle.svg",
                              width: 36,
                              height: 36,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Akun Anda telah berhasil dihapus.",
                        style: typographyServices.bodyLargeBold.value,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Terima kasih telah menggunakan EVMoto.",
                        style: typographyServices.bodySmallRegular.value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(Duration(seconds: 3)).then((value) {
      Get.close(1);
    });
  }
}
