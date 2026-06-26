import 'dart:async';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WakeLockServices extends GetxService {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkAndUpdate(),
    );
  }

  @override
  Future<void> onClose() async {
    _timer?.cancel();
    await WakelockPlus.disable();
    super.onClose();
  }

  Future<void> _checkAndUpdate() async {
    var prefs = await SharedPreferences.getInstance();
    var isRegistered = prefs.getBool('home_controller_registered') ?? false;

    if (!isRegistered) {
      await WakelockPlus.disable();
      return;
    }

    var homeController = Get.find<HomeController>();
    var isOnline = homeController.workStatus.value == 1;
    await WakelockPlus.toggle(enable: isOnline);
  }
}
