import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/services/background_services.dart';

class AppLifecycleController extends GetxController
    with WidgetsBindingObserver {
  final isForeground = true.obs;
  final backgroundServices = Get.find<BackgroundServices>();

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        isForeground.value = true;
        await backgroundServices.refreshState();
        onAppForeground();
        break;

      case AppLifecycleState.paused:
        isForeground.value = false;
        await backgroundServices.refreshState();
        onAppBackground();
        break;

      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.detached:
        FlutterBackgroundService().invoke("stopService");
        break;

      case AppLifecycleState.hidden:
        break;
    }
  }

  void onAppForeground() {}

  void onAppBackground() {}
}
