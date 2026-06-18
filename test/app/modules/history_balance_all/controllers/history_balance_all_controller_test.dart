import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/modules/history_balance_all/controllers/history_balance_all_controller.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../history_balance_all_test_helpers.dart';

class MockHistoryBalanceRepository extends Mock
    implements HistoryBalanceRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistoryBalanceAllController', () {
    late HistoryBalanceAllController controller;
    late MockHistoryBalanceRepository mockHistoryBalanceRepository;
    late HomeController homeController;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      homeController = registerTestableHomeControllerForHistoryBalance(
        balance: 125000,
      );
      mockHistoryBalanceRepository = MockHistoryBalanceRepository();
      controller = HistoryBalanceAllController(
        historyBalanceRepository: mockHistoryBalanceRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test('can be instantiated', () {
      expect(controller, isA<HistoryBalanceAllController>());
    });

    test('resolves required GetX dependencies', () {
      expect(controller.themeColorServices, isA<ThemeColorServices>());
      expect(controller.typographyServices, isA<TypographyServices>());
      expect(controller.homeController, isA<HomeController>());
      expect(controller.homeController, same(homeController));
    });

    test('exposes active balance from home controller', () {
      expect(controller.homeController.userInfo.value.balance, 125000);
    });

    test('reflects updated balance from home controller', () {
      homeController.userInfo.value = UserInfo(balance: 75000);

      expect(controller.homeController.userInfo.value.balance, 75000);
    });

    test('onInit and onReady complete without error', () {
      expect(() => controller.onInit(), returnsNormally);
      expect(() => controller.onReady(), returnsNormally);
    });

    test('should clean up controller without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
