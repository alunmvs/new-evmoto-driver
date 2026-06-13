import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/data/models/bank_model.dart';
import 'package:new_evmoto_driver/app/modules/add_edit_withdraw_bank_account/controllers/add_edit_withdraw_bank_account_controller.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/modules/withdraw/controllers/withdraw_controller.dart';
import 'package:new_evmoto_driver/app/repositories/bank_account_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockBankAccountRepository extends Mock implements BankAccountRepository {}

class TestableHomeController extends HomeController {
  TestableHomeController({
    required super.vehicleRepository,
    required super.orderRepository,
    required super.userRepository,
    required super.accountRepository,
    required super.versioningServerRepository,
    required super.guaranteeIncomeRepository,
    required super.advanceBookingRepository,
  });

  @override
  // ignore: must_call_super
  Future<void> onInit() async {
    isFetch.value = false;
  }
}

List<Bank> sampleBankList() => [
  Bank(code: '014', name: 'BCA'),
  Bank(code: '008', name: 'Mandiri'),
];

BankAccount sampleBankAccount() => BankAccount(
  id: 1,
  bank: 'BCA',
  bankCode: '014',
  name: 'John Doe',
  code: '1234567890',
);

void stubGetBankList(MockBankAccountRepository mockBankAccountRepository) {
  when(
    () => mockBankAccountRepository.getBankList(
      language: any(named: 'language'),
    ),
  ).thenAnswer((_) async => sampleBankList());
}

void stubGetBankAccountList(MockBankAccountRepository mockBankAccountRepository) {
  when(
    () => mockBankAccountRepository.getBankAccountList(
      language: any(named: 'language'),
      size: any(named: 'size'),
      pageNum: any(named: 'pageNum'),
    ),
  ).thenAnswer((_) async => []);
}

Future<void> registerStubWithdrawController(
  MockBankAccountRepository mockBankAccountRepository,
) async {
  stubGetBankAccountList(mockBankAccountRepository);
  registerHomeControllerDependencies();
  registerMockUserServices();
  Get.put<HomeController>(
    TestableHomeController(
      vehicleRepository: MockVehicleRepository(),
      orderRepository: MockOrderRepository(),
      userRepository: MockUserRepository(),
      accountRepository: MockAccountRepository(),
      versioningServerRepository: MockVersioningServerRepository(),
      guaranteeIncomeRepository: MockGuaranteeIncomeRepository(),
      advanceBookingRepository: MockAdvanceBookingRepository(),
    ),
  );
  Get.put<WithdrawController>(
    WithdrawController(bankAccountRepository: mockBankAccountRepository),
  );
  final withdrawController = Get.find<WithdrawController>();
  for (var i = 0; i < 50 && withdrawController.isFetch.value; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void stubInsertBankAccount(MockBankAccountRepository mockBankAccountRepository) {
  when(
    () => mockBankAccountRepository.insertBankAccount(
      bank: any(named: 'bank'),
      bankCode: any(named: 'bankCode'),
      code: any(named: 'code'),
      language: any(named: 'language'),
      name: any(named: 'name'),
    ),
  ).thenAnswer((_) async {});
}

void stubUpdateBankAccount(MockBankAccountRepository mockBankAccountRepository) {
  when(
    () => mockBankAccountRepository.updateBankAccount(
      id: any(named: 'id'),
      bank: any(named: 'bank'),
      bankCode: any(named: 'bankCode'),
      code: any(named: 'code'),
      language: any(named: 'language'),
      name: any(named: 'name'),
    ),
  ).thenAnswer((_) async {});
}

void fillValidBankAccountForm(AddEditWithdrawBankAccountController controller) {
  controller.bankList.value = sampleBankList();
  controller.formGroup.control('name').value = 'John Doe';
  controller.formGroup.control('bank').value = sampleBankList().first;
  controller.formGroup.control('code').value = '1234567890';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddEditWithdrawBankAccountController', () {
    late AddEditWithdrawBankAccountController controller;
    late MockBankAccountRepository mockBankAccountRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockBankAccountRepository = MockBankAccountRepository();
      stubGetBankList(mockBankAccountRepository);
      controller = AddEditWithdrawBankAccountController(
        bankAccountRepository: mockBankAccountRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with empty form and add mode defaults',
      () {
        expect(controller.isEdit.value, isFalse);
        expect(controller.isFetch.value, isFalse);
        expect(controller.bankList, isEmpty);
        expect(controller.bankAccount.value.id, isNull);
        expect(controller.formGroup.valid, isFalse);
        expect(controller.formGroup.control('name').value, isNull);
        expect(controller.formGroup.control('bank').value, isNull);
        expect(controller.formGroup.control('code').value, isNull);
      },
    );

    test(
      'getBankList should populate bankList from repository',
      () async {
        await controller.getBankList();

        expect(controller.bankList.length, 2);
        expect(controller.bankList.first.name, 'BCA');
        verify(
          () => mockBankAccountRepository.getBankList(language: 2),
        ).called(1);
      },
    );

    test(
      'onInit should fetch bank list in add mode when is_edit is false',
      () async {
        Get.testMode = true;
        Get.routing.args = {'is_edit': false};

        await controller.onInit();

        expect(controller.isEdit.value, isFalse);
        expect(controller.isFetch.value, isFalse);
        expect(controller.bankList.length, 2);
        verify(
          () => mockBankAccountRepository.getBankList(language: 2),
        ).called(1);
      },
    );

    test(
      'onInit should prefill form when is_edit is true',
      () async {
        Get.testMode = true;
        Get.routing.args = {
          'is_edit': true,
          'bank_account': sampleBankAccount(),
        };

        await controller.onInit();

        expect(controller.isEdit.value, isTrue);
        expect(controller.isFetch.value, isFalse);
        expect(controller.bankAccount.value.id, 1);
        expect(controller.formGroup.control('name').value, 'John Doe');
        expect(controller.formGroup.control('code').value, '1234567890');
        expect(
          (controller.formGroup.control('bank').value as Bank).code,
          '014',
        );
      },
    );

    test(
      'onInit should default to add mode when arguments are missing',
      () async {
        Get.testMode = true;
        Get.routing.args = <String, dynamic>{};

        await controller.onInit();

        expect(controller.isEdit.value, isFalse);
        expect(controller.isFetch.value, isFalse);
        expect(controller.bankList.length, 2);
      },
    );

    test(
      'onTapSubmit should not call repository when form is invalid',
      () async {
        await controller.onTapSubmit();

        verifyNever(
          () => mockBankAccountRepository.insertBankAccount(
            bank: any(named: 'bank'),
            bankCode: any(named: 'bankCode'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            name: any(named: 'name'),
          ),
        );
        verifyNever(
          () => mockBankAccountRepository.updateBankAccount(
            id: any(named: 'id'),
            bank: any(named: 'bank'),
            bankCode: any(named: 'bankCode'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            name: any(named: 'name'),
          ),
        );
      },
    );

    testWidgets(
      'onTapSubmit should insert bank account and navigate back in add mode',
      (WidgetTester tester) async {
        stubInsertBankAccount(mockBankAccountRepository);
        fillValidBankAccountForm(controller);

        await tester.pumpWidget(
          GetMaterialApp(
            home: const Scaffold(body: SizedBox()),
          ),
        );

        await controller.onTapSubmit();
        await tester.pump();

        verify(
          () => mockBankAccountRepository.insertBankAccount(
            bank: 'BCA',
            bankCode: '014',
            code: '1234567890',
            language: 2,
            name: 'John Doe',
          ),
        ).called(1);
        verifyNever(
          () => mockBankAccountRepository.updateBankAccount(
            id: any(named: 'id'),
            bank: any(named: 'bank'),
            bankCode: any(named: 'bankCode'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            name: any(named: 'name'),
          ),
        );
      },
    );

    test(
      'onTapSubmit should update bank account and reset edit mode in edit mode',
      () async {
        stubUpdateBankAccount(mockBankAccountRepository);
        await registerStubWithdrawController(mockBankAccountRepository);
        controller.isEdit.value = true;
        controller.bankAccount.value = sampleBankAccount();
        fillValidBankAccountForm(controller);
        Get.find<WithdrawController>().isEditDeleteActive.value = true;

        await controller.onTapSubmit();

        verify(
          () => mockBankAccountRepository.updateBankAccount(
            id: 1,
            bank: 'BCA',
            bankCode: '014',
            code: '1234567890',
            language: 2,
            name: 'John Doe',
          ),
        ).called(1);
        expect(Get.find<WithdrawController>().isEditDeleteActive.value, isFalse);
      },
    );

    test(
      'onTapSubmit should not throw when insert fails',
      () async {
        when(
          () => mockBankAccountRepository.insertBankAccount(
            bank: any(named: 'bank'),
            bankCode: any(named: 'bankCode'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            name: any(named: 'name'),
          ),
        ).thenThrow(Exception('Insert failed'));
        fillValidBankAccountForm(controller);

        await expectLater(controller.onTapSubmit(), completes);
      },
    );

    test(
      'onTapSubmit should not throw when update fails',
      () async {
        when(
          () => mockBankAccountRepository.updateBankAccount(
            id: any(named: 'id'),
            bank: any(named: 'bank'),
            bankCode: any(named: 'bankCode'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            name: any(named: 'name'),
          ),
        ).thenThrow(Exception('Update failed'));
        await registerStubWithdrawController(mockBankAccountRepository);
        controller.isEdit.value = true;
        controller.bankAccount.value = sampleBankAccount();
        fillValidBankAccountForm(controller);

        await expectLater(controller.onTapSubmit(), completes);
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
