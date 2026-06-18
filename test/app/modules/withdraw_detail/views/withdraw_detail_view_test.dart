import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_withdraw_model.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/withdraw_detail/controllers/withdraw_detail_controller.dart';
import 'package:new_evmoto_driver/app/modules/withdraw_detail/views/withdraw_detail_view.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WithdrawDetailView', () {
    late WithdrawDetailController controller;

    Future<void> pumpView(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpModuleView(tester, const WithdrawDetailView());
      await tester.pump();
    }

    Future<void> setupController({
      required HistoryBalanceWithdraw withdraw,
    }) async {
      Get.testMode = true;
      Get.routing.args = {'history_balance_withdraw': withdraw};
      if (Get.isRegistered<WithdrawDetailController>()) {
        Get.delete<WithdrawDetailController>(force: true);
      }
      controller = WithdrawDetailController();
      Get.put<WithdrawDetailController>(controller);
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(),
      );
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders app bar with title Tarik Dana', (tester) async {
      await setupController(
        withdraw: HistoryBalanceWithdraw(money: 50000, adminFee: 2500, state: 1),
      );

      await pumpView(tester);

      expect(find.text('Tarik Dana'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('shows processing state content when state is 1', (tester) async {
      await setupController(
        withdraw: HistoryBalanceWithdraw(money: 50000, adminFee: 2500, state: 1),
      );

      await pumpView(tester);

      expect(
        find.text('Penarikan Dana Anda Sedang Diproses'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Penarikan dana kamu sedang diproses oleh Admin. Mohon ditunggu!',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows success state content when state is 2', (tester) async {
      await setupController(
        withdraw: HistoryBalanceWithdraw(money: 100000, adminFee: 2500, state: 2),
      );

      await pumpView(tester);

      expect(find.text('Selamat!\nPenarikan Dana berhasil'), findsOneWidget);
      expect(
        find.text('Penarikan Dana Anda Sedang Diproses'),
        findsNothing,
      );
    });

    testWidgets('shows rejected state content when state is 3', (tester) async {
      await setupController(
        withdraw: HistoryBalanceWithdraw(
          money: 80000,
          adminFee: 2500,
          state: 3,
        )..remark = 'Rekening tidak valid',
      );

      await pumpView(tester);

      expect(find.text('Penarikan Dana Anda\nGagal Diproses'), findsOneWidget);
      expect(find.text('Rekening tidak valid'), findsOneWidget);
    });

    testWidgets('displays formatted withdrawal amounts', (tester) async {
      await setupController(
        withdraw: HistoryBalanceWithdraw(money: 100000, adminFee: 2500, state: 2),
      );

      await pumpView(tester);

      expect(find.text('Total Penarikan Dana'), findsOneWidget);
      expect(find.text('Rincian Biaya'), findsOneWidget);
      expect(find.text('Nominal Penarikan'), findsOneWidget);
      expect(find.text('Biaya Admin'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Rp100.000'), findsNWidgets(2));
      expect(find.text('Rp2.500'), findsOneWidget);
      expect(find.text('Rp97.500'), findsOneWidget);
    });

    testWidgets('renders Kembali button in bottom bar', (tester) async {
      await setupController(
        withdraw: HistoryBalanceWithdraw(money: 50000, adminFee: 2500, state: 1),
      );

      await pumpView(tester);

      expect(find.text('Kembali'), findsOneWidget);
      expect(find.byType(LoaderElevatedButton), findsOneWidget);
    });

    testWidgets('Kembali button navigates back', (tester) async {
      await setupController(
        withdraw: HistoryBalanceWithdraw(money: 50000, adminFee: 2500, state: 1),
      );

      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => const Scaffold(body: Text('Previous Screen')),
            ),
            GetPage(
              name: '/detail',
              page: () => const WithdrawDetailView(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      Get.toNamed('/detail');
      await tester.pumpAndSettle();

      expect(find.text('Previous Screen'), findsNothing);

      await tester.tap(find.text('Kembali'));
      await tester.pumpAndSettle();

      expect(find.text('Previous Screen'), findsOneWidget);
    });

    testWidgets('shows loading indicator in body while isFetch is true', (
      tester,
    ) async {
      await setupController(
        withdraw: HistoryBalanceWithdraw(money: 50000, adminFee: 2500, state: 1),
      );
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Tarik Dana'), findsOneWidget);
      expect(find.text('Kembali'), findsNothing);
    });
  });
}
