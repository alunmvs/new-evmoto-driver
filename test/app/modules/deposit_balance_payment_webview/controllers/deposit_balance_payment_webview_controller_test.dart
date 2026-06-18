import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/deposit_balance_payment_webview/controllers/deposit_balance_payment_webview_controller.dart';
import 'package:new_evmoto_driver/app/repositories/payment_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DepositBalancePaymentWebviewController', () {
    late DepositBalancePaymentWebviewController controller;
    late MockPaymentRepository mockPaymentRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      registerStubHomeController();
      mockPaymentRepository = MockPaymentRepository();
      controller = DepositBalancePaymentWebviewController(paymentRepository: mockPaymentRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'can be instantiated',
      () {
        expect(controller, isA<DepositBalancePaymentWebviewController>());
      }
    );
  });
}
