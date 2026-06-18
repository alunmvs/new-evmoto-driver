import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/photo_viewer/controllers/photo_viewer_controller.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PhotoViewerController', () {
    late PhotoViewerController controller;


    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();

      controller = PhotoViewerController();
    });

    tearDown(() {
      Get.reset();
    });

    test('reads photo URL from Get arguments on init', () {
      Get.routing.args = {'photo_attachment_url': 'https://example.com/photo.jpg'};
      controller.onInit();
      expect(controller.photoAttachmentUrl.value, 'https://example.com/photo.jpg');
    });

    test('defaults photo URL to empty string when argument is missing', () {
      Get.routing.args = null;
      controller.onInit();
      expect(controller.photoAttachmentUrl.value, '');
    });
  });
}
