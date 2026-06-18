import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/register_form_completed/controllers/register_form_completed_controller.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RegisterFormCompletedController', () {
    late RegisterFormCompletedController controller;


    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();

      controller = RegisterFormCompletedController();
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('navigates to login page on submit', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const SizedBox()),
            GetPage(name: Routes.LOGIN, page: () => const Scaffold(body: Text('Login'))),
          ],
        ),
      );
      await controller.onTapSubmit();
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.LOGIN);
    });
  });
}
