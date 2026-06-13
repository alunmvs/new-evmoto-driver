import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/guarantee_income_approval_model.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/controllers/history_guarantee_income_controller.dart';
import 'package:new_evmoto_driver/app/repositories/guarantee_income_repository.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockGuaranteeIncomeRepository extends Mock
    implements GuaranteeIncomeRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistoryGuaranteeIncomeController', () {
    late HistoryGuaranteeIncomeController controller;
    late MockGuaranteeIncomeRepository mockGuaranteeIncomeRepository;

    void stubGuaranteeIncomeApprovalList(List<GuaranteeIncomeApproval> items) {
      when(
        () => mockGuaranteeIncomeRepository.getGuaranteeIncomeApprovalList(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => items);
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockGuaranteeIncomeRepository = MockGuaranteeIncomeRepository();
      stubGuaranteeIncomeApprovalList([]);
      controller = HistoryGuaranteeIncomeController(
        guaranteeIncomeRepository: mockGuaranteeIncomeRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test('initializes with today selected and seven recommendation dates', () {
      expect(controller.recommendationDateTimeList.length, 7);
      expect(controller.isDateSelected(DateTime.now()), isTrue);
      expect(controller.guaranteeIncomeApprovalList, isEmpty);
      expect(controller.totalSubsidyAmount.value, 0.0);
      expect(controller.selectedGuaranteeIncomeApproval.value.id, isNull);
      expect(controller.isFetch.value, isFalse);
      expect(controller.isFetchDate.value, isFalse);
    });

    test('isDateSelected returns true only for the same calendar day', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      controller.selectedDateTime.value = today;

      expect(controller.isDateSelected(today), isTrue);
      expect(controller.isDateSelected(yesterday), isFalse);
    });

    test('getGuaranteeIncomeApprovalList clears state when repository returns empty', () async {
      controller.totalSubsidyAmount.value = 1000;
      controller.selectedGuaranteeIncomeApproval.value = GuaranteeIncomeApproval(
        id: 99,
        subsidyAmount: 1000,
      );

      await controller.getGuaranteeIncomeApprovalList();

      expect(controller.isFetchDate.value, isFalse);
      expect(controller.guaranteeIncomeApprovalList, isEmpty);
      expect(controller.totalSubsidyAmount.value, 0.0);
      expect(controller.selectedGuaranteeIncomeApproval.value.id, isNull);
      verify(
        () => mockGuaranteeIncomeRepository.getGuaranteeIncomeApprovalList(
          startDate: DateFormat('yyyy-MM-dd').format(controller.selectedDateTime.value),
          endDate: DateFormat('yyyy-MM-dd').format(controller.selectedDateTime.value),
        ),
      ).called(1);
    });

    test('getGuaranteeIncomeApprovalList sums subsidy and selects first item', () async {
      stubGuaranteeIncomeApprovalList([
        GuaranteeIncomeApproval(
          id: 1,
          subsidyAmount: 25000,
          approvalStatus: 1,
        ),
        GuaranteeIncomeApproval(
          id: 2,
          subsidyAmount: 15000,
          approvalStatus: 0,
        ),
      ]);

      await controller.getGuaranteeIncomeApprovalList();

      expect(controller.guaranteeIncomeApprovalList.length, 2);
      expect(controller.totalSubsidyAmount.value, 40000);
      expect(controller.selectedGuaranteeIncomeApproval.value.id, 1);
      expect(controller.isFetchDate.value, isFalse);
    });

    test('onInit fetches guarantee income history and stops loading', () async {
      stubGuaranteeIncomeApprovalList([
        GuaranteeIncomeApproval(
          id: 10,
          subsidyAmount: 50000,
        ),
      ]);

      await controller.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(controller.isFetch.value, isFalse);
      expect(controller.totalSubsidyAmount.value, 50000);
      expect(controller.selectedGuaranteeIncomeApproval.value.id, 10);
      verify(
        () => mockGuaranteeIncomeRepository.getGuaranteeIncomeApprovalList(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).called(1);
    });

    test('should clean up controller without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
