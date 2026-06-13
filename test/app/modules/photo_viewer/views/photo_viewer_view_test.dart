import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/photo_viewer/controllers/photo_viewer_controller.dart';
import 'package:new_evmoto_driver/app/modules/photo_viewer/views/photo_viewer_view.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PhotoViewerView', () {
    late PhotoViewerController controller;


    Future<void> pumpView(WidgetTester tester) async {
      await pumpModuleView(tester, const PhotoViewerView());
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(selectLanguage: 'Select Language', save: 'Save'),
      );

      controller = PhotoViewerController();
      Get.put<PhotoViewerController>(controller);

      Get.routing.args = {'photo_attachment_url': 'https://example.com/photo.jpg'};
      controller.onInit();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders photo viewer scaffold', (tester) async {
      await pumpView(tester);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
