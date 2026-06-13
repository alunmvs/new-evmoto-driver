import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/modules/my_order/controllers/my_order_controller.dart';
import 'package:new_evmoto_driver/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

class MockAdvanceBookingRepository extends Mock
    implements AdvanceBookingRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MyOrderController', () {
    late MyOrderController controller;
    late MockOrderRepository mockOrderRepository;
    late MockAdvanceBookingRepository mockAdvanceBookingRepository;

    Order sampleOrder({int id = 1, int state = 10}) => Order(
          id: id,
          type: 1,
          state: state,
          startAddress: 'Jl. Sudirman',
          endAddress: 'Jl. Thamrin',
        );

    void stubEmptyOrderLists() {
      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: any(named: 'state'),
        ),
      ).thenAnswer((_) async => []);
    }

    void stubOrderListByState({
      List<Order>? allOrders,
      List<Order>? toBePaidOrders,
      List<Order>? cancelOrders,
    }) {
      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: 1,
        ),
      ).thenAnswer((_) async => allOrders ?? []);
      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: 2,
        ),
      ).thenAnswer((_) async => toBePaidOrders ?? []);
      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: 3,
        ),
      ).thenAnswer((_) async => cancelOrders ?? []);
    }

    Future<void> waitForFetch() async {
      for (var i = 0; i < 20 && controller.isFetch.value; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockOrderRepository = MockOrderRepository();
      mockAdvanceBookingRepository = MockAdvanceBookingRepository();
      controller = MyOrderController(
        orderRepository: mockOrderRepository,
        advanceBookingRepository: mockAdvanceBookingRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test('should initialize with empty order lists and default pagination', () {
      expect(controller.allOrderList, isEmpty);
      expect(controller.toBePaidList, isEmpty);
      expect(controller.cancelOrderList, isEmpty);
      expect(controller.allOrderPageNum.value, 1);
      expect(controller.toBePaidPageNum.value, 1);
      expect(controller.cancelOrderPageNum.value, 1);
      expect(controller.isSeeMoreAllOrder.value, isTrue);
      expect(controller.isSeeMoreToBePaid.value, isTrue);
      expect(controller.isSeeMoreCancelOrder.value, isTrue);
      expect(controller.isFetch.value, isFalse);
    });

    test('getAllOrderList should fetch state 1 orders and disable see more when empty',
        () async {
      stubOrderListByState(allOrders: []);

      await controller.getAllOrderList();

      verify(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: 10,
          pageNum: 1,
          language: any(named: 'language'),
          state: 1,
        ),
      ).called(1);
      expect(controller.allOrderList, isEmpty);
      expect(controller.allOrderPageNum.value, 1);
      expect(controller.isSeeMoreAllOrder.value, isFalse);
    });

    test('getAllOrderList should populate list when orders are returned', () async {
      final orders = [sampleOrder(id: 101), sampleOrder(id: 102)];
      stubOrderListByState(allOrders: orders);

      await controller.getAllOrderList();

      expect(controller.allOrderList.length, 2);
      expect(controller.allOrderList.first.id, 101);
      expect(controller.isSeeMoreAllOrder.value, isTrue);
    });

    test('getToBePaidList should fetch state 2 orders', () async {
      final orders = [sampleOrder(id: 201, state: 5)];
      stubOrderListByState(toBePaidOrders: orders);

      await controller.getToBePaidList();

      verify(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: 10,
          pageNum: 1,
          language: any(named: 'language'),
          state: 2,
        ),
      ).called(1);
      expect(controller.toBePaidList.length, 1);
      expect(controller.toBePaidList.first.id, 201);
    });

    test('getCancelOrderList should fetch state 3 orders', () async {
      final orders = [sampleOrder(id: 301, state: 13)];
      stubOrderListByState(cancelOrders: orders);

      await controller.getCancelOrderList();

      verify(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: 10,
          pageNum: 1,
          language: any(named: 'language'),
          state: 3,
        ),
      ).called(1);
      expect(controller.cancelOrderList.length, 1);
      expect(controller.cancelOrderList.first.id, 301);
    });

    test('seeMoreAllOrderList should append next page and disable see more when empty',
        () async {
      controller.allOrderList.assignAll([sampleOrder(id: 1)]);
      controller.isSeeMoreAllOrder.value = true;
      controller.allOrderPageNum.value = 1;

      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: 2,
          language: any(named: 'language'),
          state: 1,
        ),
      ).thenAnswer((_) async => []);

      await controller.seeMoreAllOrderList();

      expect(controller.allOrderPageNum.value, 2);
      expect(controller.allOrderList.length, 1);
      expect(controller.isSeeMoreAllOrder.value, isFalse);
    });

    test('seeMoreAllOrderList should append orders from next page', () async {
      controller.allOrderList.assignAll([sampleOrder(id: 1)]);
      controller.isSeeMoreAllOrder.value = true;

      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: 2,
          language: any(named: 'language'),
          state: 1,
        ),
      ).thenAnswer((_) async => [sampleOrder(id: 2)]);

      await controller.seeMoreAllOrderList();

      expect(controller.allOrderList.length, 2);
      expect(controller.allOrderList.last.id, 2);
      expect(controller.isSeeMoreAllOrder.value, isTrue);
    });

    test('seeMoreAllOrderList should not fetch when see more is disabled', () async {
      controller.isSeeMoreAllOrder.value = false;

      await controller.seeMoreAllOrderList();

      verifyNever(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: any(named: 'state'),
        ),
      );
    });

    test('seeMoreToBePaidList should append next page orders', () async {
      controller.toBePaidList.assignAll([sampleOrder(id: 1)]);
      controller.isSeeMoreToBePaid.value = true;

      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: 2,
          language: any(named: 'language'),
          state: 2,
        ),
      ).thenAnswer((_) async => [sampleOrder(id: 2)]);

      await controller.seeMoreToBePaidList();

      expect(controller.toBePaidList.length, 2);
      expect(controller.toBePaidPageNum.value, 2);
    });

    test('seeMoreCancelOrderList should append next page orders', () async {
      controller.cancelOrderList.assignAll([sampleOrder(id: 1)]);
      controller.isSeeMoreCancelOrder.value = true;

      when(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: 2,
          language: any(named: 'language'),
          state: 3,
        ),
      ).thenAnswer((_) async => [sampleOrder(id: 2)]);

      await controller.seeMoreCancelOrderList();

      expect(controller.cancelOrderList.length, 2);
      expect(controller.cancelOrderPageNum.value, 2);
    });

    test('refreshAll should fetch all three order tabs', () async {
      stubOrderListByState(
        allOrders: [sampleOrder(id: 1)],
        toBePaidOrders: [sampleOrder(id: 2)],
        cancelOrders: [sampleOrder(id: 3)],
      );

      await controller.refreshAll();

      verify(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: 10,
          pageNum: 1,
          language: any(named: 'language'),
          state: 1,
        ),
      ).called(1);
      verify(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: 10,
          pageNum: 1,
          language: any(named: 'language'),
          state: 2,
        ),
      ).called(1);
      verify(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: 10,
          pageNum: 1,
          language: any(named: 'language'),
          state: 3,
        ),
      ).called(1);
      expect(controller.allOrderList.length, 1);
      expect(controller.toBePaidList.length, 1);
      expect(controller.cancelOrderList.length, 1);
    });

    testWidgets('onInit should load all order lists and finish fetching', (
      tester,
    ) async {
      stubEmptyOrderLists();
      Get.put<MyOrderController>(controller);
      await tester.pump();
      await waitForFetch();

      expect(controller.tabController, isNotNull);
      expect(controller.isFetch.value, isFalse);
      verify(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: 1,
        ),
      ).called(1);
      verify(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: 2,
        ),
      ).called(1);
      verify(
        () => mockOrderRepository.getHistoryOrderListV2(
          size: any(named: 'size'),
          pageNum: any(named: 'pageNum'),
          language: any(named: 'language'),
          state: 3,
        ),
      ).called(1);
    });

    testWidgets(
      'onSlideAdvanceBookingConfirmation should confirm and navigate to order detail',
      (tester) async {
        stubEmptyOrderLists();
        when(
          () => mockAdvanceBookingRepository.advanceBookingSecondConfirm(
            orderId: any(named: 'orderId'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const SizedBox()),
              GetPage(
                name: Routes.ORDER_DETAIL,
                page: () => const Scaffold(body: Text('Order Detail')),
              ),
            ],
          ),
        );

        final selectedOrder = sampleOrder(id: 99);
        final actionController = ActionSliderController();

        await controller.onSlideAdvanceBookingConfirmation(
          actionController: actionController,
          selectedOrder: selectedOrder,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        verify(
          () => mockAdvanceBookingRepository.advanceBookingSecondConfirm(
            orderId: '99',
          ),
        ).called(1);
        expect(Get.currentRoute, Routes.ORDER_DETAIL);
      },
    );

    testWidgets(
      'onSlideAdvanceBookingConfirmation should not throw when confirm fails',
      (tester) async {
        Get.testMode = true;
        stubEmptyOrderLists();
        when(
          () => mockAdvanceBookingRepository.advanceBookingSecondConfirm(
            orderId: any(named: 'orderId'),
          ),
        ).thenThrow(Exception('Confirm failed'));

        await tester.pumpWidget(
          GetMaterialApp(
            initialRoute: Routes.HOME,
            getPages: [
              GetPage(
                name: Routes.HOME,
                page: () => const Scaffold(body: Text('Home')),
              ),
            ],
          ),
        );

        final actionController = ActionSliderController();

        await expectLater(
          controller.onSlideAdvanceBookingConfirmation(
            actionController: actionController,
            selectedOrder: sampleOrder(id: 99),
          ),
          completes,
        );
      },
    );

    testWidgets('onTapCancelAdvanceBooking should show cancel dialog', (
      tester,
    ) async {
      when(
        () => mockAdvanceBookingRepository.advanceBookingCancel(
          orderId: any(named: 'orderId'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        GetMaterialApp(home: const Scaffold(body: SizedBox())),
      );

      await controller.onTapCancelAdvanceBooking(
        selectedOrder: sampleOrder(id: 55),
      );
      await tester.pump();

      expect(
        find.text('Anda Ingin Membatalkan Orderan Ini?'),
        findsOneWidget,
      );
    });

    test('should clean up controller without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
