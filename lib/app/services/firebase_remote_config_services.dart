import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

class FirebaseRemoteConfigServices extends GetxService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 30),
        minimumFetchInterval: Duration(hours: 12),
      ),
    );

    await remoteConfig.setDefaults({
      "driver_base_url": "https://api-dev.evmotoapp.com",
      "driver_cs_whatsapp": "6285167020937",
      "driver_appstore_link": "https://apps.apple.com/id/app/id6757465813",
      "driver_playstore_link":
          "https://play.google.com/store/apps/details?id=com.evmoto.driver.app",
    });

    await remoteConfig.fetchAndActivate();

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  }
}
