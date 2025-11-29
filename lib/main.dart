import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

import 'app/routes/app_pages.dart';

final baseUrl = "http://api-dev.evmotoapp.com:8500";

void main() {
  Get.put(ThemeColorServices(), permanent: true);
  Get.put(TypographyServices(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
