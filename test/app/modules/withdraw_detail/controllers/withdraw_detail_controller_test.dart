import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_withdraw_model.dart';
import 'package:new_evmoto_driver/app/modules/withdraw_detail/controllers/withdraw_detail_controller.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WithdrawDetailController', () {
    late WithdrawDetailController controller;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      Get.testMode = true;
      controller = WithdrawDetailController();
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'initializes with empty withdraw data and isFetch false',
      () {
        expect(controller.historyBalanceWithdraw.value.money, isNull);
        expect(controller.historyBalanceWithdraw.value.state, isNull);
        expect(controller.isFetch.value, isFalse);
      },
    );

    test(
      'onInit loads withdraw detail from arguments',
      () async {
        final withdraw = HistoryBalanceWithdraw(
          money: 100000,
          adminFee: 2500,
          state: 1,
        )..remark = 'Test remark';
        Get.routing.args = {'history_balance_withdraw': withdraw};

        await controller.onInit();

        expect(controller.historyBalanceWithdraw.value.money, 100000);
        expect(controller.historyBalanceWithdraw.value.adminFee, 2500);
        expect(controller.historyBalanceWithdraw.value.state, 1);
        expect(controller.historyBalanceWithdraw.value.remark, 'Test remark');
        expect(controller.isFetch.value, isFalse);
      },
    );

    test(
      'onInit sets isFetch to false after loading',
      () async {
        Get.routing.args = {
          'history_balance_withdraw': HistoryBalanceWithdraw(money: 50000, state: 2),
        };

        await controller.onInit();

        expect(controller.isFetch.value, isFalse);
      },
    );

    test(
      'onInit loads success state from arguments',
      () async {
        Get.routing.args = {
          'history_balance_withdraw': HistoryBalanceWithdraw(
            money: 75000,
            adminFee: 1000,
            state: 2,
          ),
        };

        await controller.onInit();

        expect(controller.historyBalanceWithdraw.value.state, 2);
        expect(controller.historyBalanceWithdraw.value.money, 75000);
      },
    );

    test(
      'onInit loads rejected state with remark from arguments',
      () async {
        Get.routing.args = {
          'history_balance_withdraw': HistoryBalanceWithdraw(
            money: 30000,
            adminFee: 500,
            state: 3,
          )..remark = 'Rekening tidak valid',
        };

        await controller.onInit();

        expect(controller.historyBalanceWithdraw.value.state, 3);
        expect(controller.historyBalanceWithdraw.value.remark, 'Rekening tidak valid');
      },
    );

    test(
      'should clean up controller without error when onClose is called',
      () {
        expect(() => controller.onClose(), returnsNormally);
      },
    );
  });
}
