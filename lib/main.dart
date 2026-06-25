import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/services/api_services.dart';
import 'package:new_evmoto_driver/app/services/auth_service.dart';
import 'package:new_evmoto_driver/app/services/chat_room_services.dart';
import 'package:new_evmoto_driver/app/services/app_lifecycle_services.dart';
import 'package:new_evmoto_driver/app/services/background_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:new_evmoto_driver/app/services/socket_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:native_flutter_proxy/native_flutter_proxy.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import 'package:new_evmoto_driver/app/services/voice_services.dart';
import 'package:new_evmoto_driver/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> applyProxy(ProxySetting settings) async {
  if (!settings.enabled || settings.host == null) {
    HttpOverrides.global = null;
    return;
  }

  CustomProxy(ipAddress: settings.host!, port: settings.port).enable();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final settings = await NativeProxyReader.proxySetting;
    await applyProxy(settings);
  } catch (e) {}

  NativeProxyReader.setProxyChangedCallback((settings) async {
    await applyProxy(settings);
  });

  DartPluginRegistrant.ensureInitialized();
  tz.initializeTimeZones();

  await initializeDateFormatting('id_ID', null);

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
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordError(
      errorDetails.exception,
      errorDetails.stack,
      fatal: true,
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Get.put(ThemeColorServices(), permanent: true);
  Get.put(TypographyServices(), permanent: true);
  Get.put(LanguageServices(), permanent: true);
  Get.put(ApiServices(), permanent: true);
  Get.put(AuthService(), permanent: true);
  Get.put(FirebaseRemoteConfigServices(), permanent: true);
  await Get.find<FirebaseRemoteConfigServices>().manualOnInit();
  Get.put(FirebasePushNotificationServices(), permanent: true);
  Get.put(UserServices(), permanent: true);
  Get.put(ChatRoomServices(), permanent: true);
  Get.put(VoiceServices(), permanent: true);
  Get.put(BackgroundServices(), permanent: true);
  Get.put(AppLifecycleController(), permanent: true);
  Get.put(LocationServices(), permanent: true);
  Get.put(SocketServices(), permanent: true);

  runApp(
    GetMaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [FlutterSmartDialog.observer],
      title: "Evmoto Driver",
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
        Locale('zh', 'CN'),
      ],
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Get.find<ThemeColorServices>().primaryBlue.value,
          selectionColor: Get.find<ThemeColorServices>().primaryBlue.value
              .withValues(alpha: 0.2),
          selectionHandleColor:
              Get.find<ThemeColorServices>().primaryBlue.value,
        ),
      ),

      routingCallback: (routing) async {
        if (routing?.current == Routes.HOME) {
          var userServices = Get.find<UserServices>();
          userServices.isLoadingRefreshHome.value = true;
          var prefs = await SharedPreferences.getInstance();
          var processList = <Future>[];
          if (prefs.getBool('home_controller_registered') == true) {
            var homeController = Get.find<HomeController>();
            processList.add(homeController.refreshAll());
          }
          await Future.wait(processList);
          userServices.isLoadingRefreshHome.value = false;
        }
      },
      builder: FlutterSmartDialog.init(
        builder: (context, child) {
          return env == "dev"
            ? Banner(
                message: "Dev",
                location: BannerLocation.topEnd,
                color: Color(0XFF0060C6),
                shadow: BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                ),
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                child: SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  bottom: true,
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Stack(
                      children: [
                        child!,
                        Align(
                          alignment: Alignment.centerRight,
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Obx(
                                () => Text(
                                  Get.find<SocketServices>().isSocketClose.value
                                      ? "Ping : Disconnected"
                                      : "Ping : Connected",
                                  style: Get.find<TypographyServices>()
                                      .captionSmallRegular
                                      .value
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: true,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: child!,
                ),
              );
        },
      ),
    ),
  );
}
