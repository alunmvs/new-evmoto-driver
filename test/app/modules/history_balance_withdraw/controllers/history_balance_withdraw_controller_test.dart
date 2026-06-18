import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/history_balance_withdraw/controllers/history_balance_withdraw_controller.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockHistoryBalanceRepository extends Mock implements HistoryBalanceRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistoryBalanceWithdrawController', () {
    late HistoryBalanceWithdrawController controller;
    late MockHistoryBalanceRepository mockHistoryBalanceRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockHistoryBalanceRepository = MockHistoryBalanceRepository();
      controller = HistoryBalanceWithdrawController(historyBalanceRepository: mockHistoryBalanceRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test('initializes with isFetch false after manual setup', () {
      expect(controller.isFetch.value, isFalse);
    });
  });
}
