import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/account_other_setting/controllers/account_other_setting_controller.dart';
import 'package:new_evmoto_driver/app/modules/account_other_setting/views/account_other_setting_view.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../account_other_setting_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountOtherSettingView', () {
    late AccountOtherSettingController controller;

    Future<void> pumpView(
      WidgetTester tester, {
      List<GetPage<dynamic>>? getPages,
    }) async {
      await pumpModuleView(
        tester,
        const AccountOtherSettingView(),
        getPages: getPages,
      );
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      mockOtherSettingPlatformChannels();
      registerCommonModuleDependencies(
        language: Language(
          otherSetting: 'Other Settings',
          userGuide: 'User Guide',
          legalTermsAndApplicationRules: 'Terms & Policy',
          aboutUs: 'About Us',
          clearCache: 'Clear Cache',
          currentVersion: 'Current Version',
          versionUpdate: 'Update Version',
        ),
      );
      registerTestableHomeController();

      controller = AccountOtherSettingController();
      Get.put<AccountOtherSettingController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders other settings app bar', (tester) async {
      await pumpView(tester);

      expect(find.text('Other Settings'), findsOneWidget);
    });

    testWidgets('renders menu items', (tester) async {
      await pumpView(tester);

      expect(find.text('User Guide'), findsOneWidget);
      expect(find.text('Terms & Policy'), findsOneWidget);
      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('Clear Cache'), findsOneWidget);
      expect(find.text('Current Version'), findsOneWidget);
      expect(find.text('Update Version'), findsOneWidget);
    });

    testWidgets('displays package version when loaded', (tester) async {
      controller.packageVersion.value = '1.9.5';
      await pumpView(tester);

      expect(find.text('1.9.5'), findsOneWidget);
    });

    testWidgets('navigates to user guide when menu item is tapped', (
      tester,
    ) async {
      await pumpView(
        tester,
        getPages: [
          GetPage(
            name: Routes.ACCOUNT_USER_GUIDE,
            page: () => const Scaffold(body: Text('User Guide Page')),
          ),
        ],
      );

      await tester.tap(find.text('User Guide'));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.ACCOUNT_USER_GUIDE);
      expect(find.text('User Guide Page'), findsOneWidget);
    });

    testWidgets('navigates to terms and policy when menu item is tapped', (
      tester,
    ) async {
      await pumpView(
        tester,
        getPages: [
          GetPage(
            name: Routes.ACCOUNT_LEGAL_TERMS_AND_PLATFORM_RULES,
            page: () => const Scaffold(body: Text('Terms Page')),
          ),
        ],
      );

      await tester.tap(find.text('Terms & Policy'));
      await tester.pumpAndSettle();

      expect(
        Get.currentRoute,
        Routes.ACCOUNT_LEGAL_TERMS_AND_PLATFORM_RULES,
      );
      expect(find.text('Terms Page'), findsOneWidget);
    });

    testWidgets('navigates to about us when menu item is tapped', (
      tester,
    ) async {
      await pumpView(
        tester,
        getPages: [
          GetPage(
            name: Routes.ACCOUNT_ABOUT_US,
            page: () => const Scaffold(body: Text('About Us Page')),
          ),
        ],
      );

      await tester.tap(find.text('About Us'));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.ACCOUNT_ABOUT_US);
      expect(find.text('About Us Page'), findsOneWidget);
    });

    testWidgets('calls onTapUpdateVersion when update version is tapped', (
      tester,
    ) async {
      final homeController = Get.find<HomeController>() as TestableHomeController;

      await pumpView(tester);

      await tester.tap(find.text('Update Version'));
      await tester.pumpAndSettle();

      expect(homeController.checkAppVersioningCalled, isTrue);
    });
  });
}
