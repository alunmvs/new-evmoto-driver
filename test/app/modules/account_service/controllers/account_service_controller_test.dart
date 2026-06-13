import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/account_service/controllers/account_service_controller.dart';
import 'package:new_evmoto_driver/app/repositories/account_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountServiceController', () {
    late AccountServiceController controller;
    late MockAccountRepository mockAccountRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockAccountRepository = MockAccountRepository();
      controller = AccountServiceController(accountRepository: mockAccountRepository);
    });

    tearDown(() {
      Get.reset();
    });

    test('initializes with isFetch false after manual setup', () {
      expect(controller.isFetch.value, isFalse);
    });
  });
}
