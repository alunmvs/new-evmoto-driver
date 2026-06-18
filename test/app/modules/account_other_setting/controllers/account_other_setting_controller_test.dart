import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/account_other_setting/controllers/account_other_setting_controller.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../account_other_setting_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountOtherSettingController', () {
    late AccountOtherSettingController controller;
    late TestableHomeController homeController;

    setUp(() async {
      await setupModuleTestEnvironment();
      mockOtherSettingPlatformChannels();
      registerCommonModuleDependencies();
      homeController = registerTestableHomeController();
      controller = AccountOtherSettingController();
    });

    tearDown(() {
      Get.reset();
    });

    test('can be instantiated', () {
      expect(controller, isA<AccountOtherSettingController>());
    });

    test('loads package info and cache size on init', () async {
      controller.onInit();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(controller.isFetch.value, isFalse);
      expect(controller.packageVersion.value, '1.9.5');
      expect(controller.cacheSizeInBytes.value, greaterThanOrEqualTo(0));
    });

    test('getStringSize returns formatted byte size', () {
      expect(controller.getStringSize(512), '512 B');
      expect(controller.getStringSize(1023), '1023 B');
      expect(controller.getStringSize(1024), '1 KB');
      expect(controller.getStringSize(2048), '2 KB');
      expect(controller.getStringSize(1048576), '1.0 MB');
      expect(controller.getStringSize(1073741824), '1.00 GB');
    });

    test(
      'onTapUpdateVersion delegates to homeController.checkAppVersioning',
      () async {
        await controller.onTapUpdateVersion();

        expect(homeController.checkAppVersioningCalled, isTrue);
        expect(
          homeController.lastIsShowVersionNewestConfirmationDialog,
          isTrue,
        );
      },
    );
  });
}
