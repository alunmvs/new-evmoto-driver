import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight [TypographyServices] for unit/widget tests.
/// Avoids [google_fonts] network fetches that fail in the test environment.
class TestTypographyServices extends GetxService implements TypographyServices {
  @override
  final headingLargeBold = const TextStyle(fontSize: 32).obs;

  @override
  final headingMediumBold = const TextStyle(fontSize: 24).obs;

  @override
  final headingSmallBold = const TextStyle(fontSize: 20).obs;

  @override
  final bodyLargeBold = const TextStyle(fontSize: 16).obs;

  @override
  final bodyLargeRegular = const TextStyle(fontSize: 16).obs;

  @override
  final bodySmallRegular = const TextStyle(fontSize: 14).obs;

  @override
  final bodySmallBold = const TextStyle(fontSize: 14).obs;

  @override
  final captionLargeBold = const TextStyle(fontSize: 12).obs;

  @override
  final captionLargeRegular = const TextStyle(fontSize: 12).obs;

  @override
  final captionSmallBold = const TextStyle(fontSize: 10).obs;

  @override
  final captionSmallRegular = const TextStyle(fontSize: 10).obs;
}

class TestLanguageServices extends LanguageServices {
  @override
  Future<void> onInit() async {}
}

class FakeFirebaseRemoteConfigServices extends FirebaseRemoteConfigServices {
  @override
  Future<void> onInit() async {}

  @override
  Future<void> manualOnInit() async {}
}

Future<void> setupLoginTestEnvironment() async {
  setupFirebaseCoreMocks();
  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});
}

void registerTestTypographyServices() {
  Get.put<TypographyServices>(TestTypographyServices());
}
