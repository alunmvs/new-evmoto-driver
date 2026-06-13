import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/bank_account_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/bank_account_repository.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import '../../../helpers/module_test_helpers.dart';

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

List<BankAccount> sampleBankAccountList() => [
  BankAccount(
    id: 1,
    bank: 'BCA',
    bankCode: '014',
    name: 'John Doe',
    code: '1234567890',
  ),
  BankAccount(
    id: 2,
    bank: 'Mandiri',
    bankCode: '008',
    name: 'Jane Doe',
    code: '9876543210',
  ),
];

BankAccount sampleBankAccount() => sampleBankAccountList().first;

void stubGetBankAccountList(
  MockBankAccountRepository mockBankAccountRepository, {
  List<BankAccount>? accounts,
}) {
  when(
    () => mockBankAccountRepository.getBankAccountList(
      pageNum: any(named: 'pageNum'),
      language: any(named: 'language'),
      size: any(named: 'size'),
    ),
  ).thenAnswer((_) async => accounts ?? sampleBankAccountList());
}

void stubDeleteBankAccount(
  MockBankAccountRepository mockBankAccountRepository,
) {
  when(
    () => mockBankAccountRepository.deleteBankAccountById(
      id: any(named: 'id'),
      language: any(named: 'language'),
    ),
  ).thenAnswer((_) async {});
}

HomeController registerTestableHomeController({double balance = 50000}) {
  registerHomeControllerDependencies();
  if (!Get.isRegistered<UserServices>()) {
    registerMockUserServices(balance: balance);
  }
  final homeController = TestableHomeController(
    vehicleRepository: MockVehicleRepository(),
    orderRepository: MockOrderRepository(),
    userRepository: MockUserRepository(),
    accountRepository: MockAccountRepository(),
    versioningServerRepository: MockVersioningServerRepository(),
    guaranteeIncomeRepository: MockGuaranteeIncomeRepository(),
    advanceBookingRepository: MockAdvanceBookingRepository(),
  );
  homeController.userInfo.value = UserInfo(balance: balance);
  Get.put<HomeController>(homeController);
  return homeController;
}
