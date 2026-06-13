import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/notification/controllers/notification_controller.dart';
import 'package:new_evmoto_driver/app/repositories/notification_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationController', () {
    late NotificationController controller;
    late MockNotificationRepository mockNotificationRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockNotificationRepository = MockNotificationRepository();
      controller = NotificationController(notificationRepository: mockNotificationRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test('initializes with isFetch false after manual setup', () {
      expect(controller.isFetch.value, isFalse);
    });
  });
}
