import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/history_balance_revenue_model.dart';
import 'package:new_evmoto_driver/app/modules/history_balance_revenue/controllers/history_balance_revenue_controller.dart';
import 'package:new_evmoto_driver/app/repositories/history_balance_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockHistoryBalanceRepository extends Mock
    implements HistoryBalanceRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HistoryBalanceRevenueController', () {
    late HistoryBalanceRevenueController controller;
    late MockHistoryBalanceRepository mockHistoryBalanceRepository;

    void stubHistoryRevenueList(HistoryBalanceRevenue response) {
      when(
        () => mockHistoryBalanceRepository.getHistoryRevenueList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => response);
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockHistoryBalanceRepository = MockHistoryBalanceRepository();
      stubHistoryRevenueList(HistoryBalanceRevenue());
      controller = HistoryBalanceRevenueController(
        historyBalanceRepository: mockHistoryBalanceRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test('initializes with today selected and seven recommendation dates', () {
      expect(controller.recommendationDateTimeList.length, 7);
      expect(controller.isDateSelected(DateTime.now()), isTrue);
      expect(controller.historyBalanceRevenue.value.revenue, isNull);
      expect(controller.historyBalancePageNum.value, 1);
      expect(controller.isSeeMoreHistoryBalance.value, isTrue);
      expect(controller.indexBanner.value, 0.0);
      expect(controller.isFetch.value, isFalse);
    });

    test('isDateSelected returns true only for the same calendar day', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      controller.selectedDateTime.value = today;

      expect(controller.isDateSelected(today), isTrue);
      expect(controller.isDateSelected(yesterday), isFalse);
    });

    test(
      'getHistoryBalanceRevenue hides see more when repository returns empty revenue',
      () async {
        controller.isSeeMoreHistoryBalance.value = true;
        controller.historyBalancePageNum.value = 3;

        await controller.getHistoryBalanceRevenue();

        expect(controller.historyBalancePageNum.value, 1);
        expect(controller.isSeeMoreHistoryBalance.value, isFalse);
        expect(controller.historyBalanceRevenue.value.revenue, isNull);
        verify(
          () => mockHistoryBalanceRepository.getHistoryRevenueList(
            size: 10,
            pageNum: 1,
            language: Get.find<LanguageServices>().languageCodeSystem.value,
            startTime: DateFormat('yyyy-MM-dd').format(
              controller.selectedDateTime.value,
            ),
            endTime: DateFormat('yyyy-MM-dd').format(
              controller.selectedDateTime.value,
            ),
            type: null,
          ),
        ).called(1);
      },
    );

    test(
      'getHistoryBalanceRevenue keeps see more when repository returns revenue items',
      () async {
        stubHistoryRevenueList(
          HistoryBalanceRevenue(
            income: 150000,
            flow: 200000,
            revenue: [
              Revenue(
                orderId: 1,
                orderType: 1,
                payTime: '2026-06-13 10:00',
                payMoney: 50000,
              ),
            ],
          ),
        );

        await controller.getHistoryBalanceRevenue();

        expect(controller.isSeeMoreHistoryBalance.value, isTrue);
        expect(controller.historyBalanceRevenue.value.income, 150000);
        expect(controller.historyBalanceRevenue.value.flow, 200000);
        expect(controller.historyBalanceRevenue.value.revenue?.length, 1);
        expect(controller.historyBalanceRevenue.value.revenue?.first.payMoney, 50000);
      },
    );

    test('onInit fetches revenue history and stops loading', () async {
      stubHistoryRevenueList(
        HistoryBalanceRevenue(
          income: 75000,
          flow: 90000,
          revenue: [
            Revenue(
              orderId: 10,
              orderType: 2,
              payTime: '2026-06-12 08:30',
              payMoney: 75000,
            ),
          ],
        ),
      );

      await controller.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(controller.isFetch.value, isFalse);
      expect(controller.historyBalanceRevenue.value.income, 75000);
      expect(controller.historyBalanceRevenue.value.revenue?.length, 1);
      verify(
        () => mockHistoryBalanceRepository.getHistoryRevenueList(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          type: any(named: 'type'),
        ),
      ).called(1);
    });

    test('should clean up controller without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
