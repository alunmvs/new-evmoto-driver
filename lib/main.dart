import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/push_notification_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

import 'app/routes/app_pages.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  Get.put(ThemeColorServices(), permanent: true);
  Get.put(TypographyServices(), permanent: true);
  Get.put(ApiServices(), permanent: true);
  Get.put(PushNotificationServices(), permanent: true);
  Get.put(SocketServices(), permanent: true);
  Get.put(FirebaseRemoteConfigServices(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Evmoto Driver",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Get.find<ThemeColorServices>().primaryBlue.value,
          selectionColor: Get.find<ThemeColorServices>().primaryBlue.value
              .withValues(alpha: 0.2),
          selectionHandleColor:
              Get.find<ThemeColorServices>().primaryBlue.value,
        ),
      ),
      builder: (context, child) {
        return SafeArea(
          top: false,
          bottom: true,
          left: false,
          right: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: child!,
          ),
        );
      },
    ),
  );
}
