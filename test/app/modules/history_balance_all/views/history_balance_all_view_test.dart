import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/modules/history_balance_all/controllers/history_balance_all_controller.dart';
import 'package:new_evmoto_driver/app/modules/history_balance_all/views/history_balance_all_view.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import '../../../../helpers/module_test_helpers.dart';
import '../history_balance_all_test_helpers.dart';

class MockHistoryBalanceRepository extends Mock
    implements HistoryBalanceRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistoryBalanceAllView', () {
    late HistoryBalanceAllController controller;
    late MockHistoryBalanceRepository mockHistoryBalanceRepository;
    late HomeController homeController;

    Future<void> pumpView(
      WidgetTester tester, {
      List<GetPage<dynamic>>? getPages,
    }) async {
      await tester.binding.setSurfaceSize(const Size(430, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpModuleView(
        tester,
        const HistoryBalanceAllView(),
        getPages: getPages,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      while (tester.takeException() != null) {}
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(language: Language());
      homeController = registerTestableHomeControllerForHistoryBalance(
        balance: 125000,
      );
      mockHistoryBalanceRepository = MockHistoryBalanceRepository();
      controller = HistoryBalanceAllController(
        historyBalanceRepository: mockHistoryBalanceRepository,
      );
      Get.put<HistoryBalanceAllController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders history balance hub content', (tester) async {
      await pumpView(tester);

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Seluruh Riwayat'), findsOneWidget);
      expect(find.text('Saldo Aktif Saya'), findsOneWidget);
      expect(find.text('Rp125.000'), findsOneWidget);
    });

    testWidgets('renders all history menu items', (tester) async {
      await pumpView(tester);

      expect(find.text('Riwayat Pendapatan'), findsOneWidget);
      expect(find.text('Riwayat Penarikan Dana'), findsOneWidget);
      expect(find.text('Riwayat Isi Ulang Saldo'), findsOneWidget);
      expect(find.text('Riwayat Guarantee Income'), findsOneWidget);
    });

    testWidgets('reflects updated balance from home controller', (tester) async {
      await pumpView(tester);

      homeController.userInfo.value = UserInfo(balance: 50000);
      await tester.pump();

      expect(find.text('Rp50.000'), findsOneWidget);
      expect(find.text('Rp125.000'), findsNothing);
    });

    testWidgets('navigates to revenue history when menu item is tapped', (
      tester,
    ) async {
      await pumpView(
        tester,
        getPages: [
          GetPage(
            name: Routes.HISTORY_BALANCE_REVENUE,
            page: () => const Scaffold(body: Text('Revenue History Page')),
          ),
        ],
      );

      await tester.tap(find.text('Riwayat Pendapatan'));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.HISTORY_BALANCE_REVENUE);
      expect(find.text('Revenue History Page'), findsOneWidget);
    });

    testWidgets('navigates to withdraw history when menu item is tapped', (
      tester,
    ) async {
      await pumpView(
        tester,
        getPages: [
          GetPage(
            name: Routes.HISTORY_BALANCE_WITHDRAW,
            page: () => const Scaffold(body: Text('Withdraw History Page')),
          ),
        ],
      );

      await tester.tap(find.text('Riwayat Penarikan Dana'));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.HISTORY_BALANCE_WITHDRAW);
      expect(find.text('Withdraw History Page'), findsOneWidget);
    });

    testWidgets('navigates to recharge history when menu item is tapped', (
      tester,
    ) async {
      await pumpView(
        tester,
        getPages: [
          GetPage(
            name: Routes.HISTORY_BALANCE_RECHARGE,
            page: () => const Scaffold(body: Text('Recharge History Page')),
          ),
        ],
      );

      await tester.tap(find.text('Riwayat Isi Ulang Saldo'));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.HISTORY_BALANCE_RECHARGE);
      expect(find.text('Recharge History Page'), findsOneWidget);
    });

    testWidgets('navigates to guarantee income history when menu item is tapped', (
      tester,
    ) async {
      await pumpView(
        tester,
        getPages: [
          GetPage(
            name: Routes.HISTORY_GUARANTEE_INCOME,
            page: () => const Scaffold(body: Text('Guarantee Income Page')),
          ),
        ],
      );

      await tester.tap(find.text('Riwayat Guarantee Income'));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.HISTORY_GUARANTEE_INCOME);
      expect(find.text('Guarantee Income Page'), findsOneWidget);
    });
  });
}
