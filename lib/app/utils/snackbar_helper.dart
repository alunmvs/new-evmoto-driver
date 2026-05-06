import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/main.dart';

class SnackbarHelper {
  static showSnackbarSuccess({required String text}) {
    final themeColorServices = Get.find<ThemeColorServices>();
    final typographyServices = Get.find<TypographyServices>();

    Get.snackbar(
      "",
      "",
      padding: EdgeInsets.all(16),
      snackStyle: SnackStyle.GROUNDED,
      titleText: const SizedBox(),
      messageText: Text(
        text,
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: themeColorServices.sematicColorGreen400.value,

      margin: const EdgeInsets.all(0),
    );
  }

  static showSnackbarError({required String text}) {
    final themeColorServices = Get.find<ThemeColorServices>();
    final typographyServices = Get.find<TypographyServices>();

    var snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: themeColorServices.sematicColorRed400.value,
      content: Text(
        text,
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
    );

    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  static showSnackbarWarning({required String text}) {
    final themeColorServices = Get.find<ThemeColorServices>();
    final typographyServices = Get.find<TypographyServices>();

    var snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: themeColorServices.sematicColorYellow400.value,
      content: Text(
        text,
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
    );

    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
