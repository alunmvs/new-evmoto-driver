import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';
import 'package:new_evmoto_driver/app/modules/my_order_v2/controllers/my_order_v2_controller.dart';
import 'package:new_evmoto_driver/main.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MyOrderV2Controller', () {
    late MyOrderV2Controller controller;
    late MockOrderRepository mockOrderRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(cancel: 'Batalkan'),
      );
      mockOrderRepository = MockOrderRepository();
      controller = MyOrderV2Controller(orderRepository: mockOrderRepository);
      Get.put<MyOrderV2Controller>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with default observable values',
      () {
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
      },
    );

    test(
      'onInit should create tabController with 3 tabs and finish loading',
      () async {
        await controller.onInit();

        expect(controller.tabController, isNotNull);
        expect(controller.tabController!.length, 3);
        expect(controller.isFetch.value, isFalse);
      },
    );

    test(
      'onClose should dispose without error',
      () {
        expect(() => controller.onClose(), returnsNormally);
      },
    );

    testWidgets(
      'onTapCancelOrder should show cancellation confirmation dialog',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: SizedBox()),
          ),
        );

        await controller.onTapCancelOrder();
        await tester.pumpAndSettle();

        expect(
          find.text('Apakah Anda yakin ingin membatalkan pesanan?'),
          findsOneWidget,
        );
        expect(find.text('Tutup'), findsOneWidget);
        expect(find.text('Batalkan'), findsOneWidget);
      },
    );

    testWidgets(
      'onTapCancelOrder close button should dismiss dialog',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: SizedBox()),
          ),
        );

        await controller.onTapCancelOrder();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Tutup'));
        await tester.pumpAndSettle();

        expect(
          find.text('Apakah Anda yakin ingin membatalkan pesanan?'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'showDialogAdvancedBookingConfirmation should show booking dialog',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          GetMaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: SizedBox()),
          ),
        );

        final dialogFuture = controller.showDialogAdvancedBookingConfirmation(
          socketOrderStatusData: SocketOrderStatusData(time: 30),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Konfirmasi Pesanan Terjadwal'), findsOneWidget);
        expect(find.text('Swipe untuk mendapatkan orderan'), findsOneWidget);

        await tester.tap(find.byType(GestureDetector).first);
        await tester.pumpAndSettle();
        await dialogFuture;
      },
      skip: true, // Requires Google Maps platform view in test environment
    );
  });
}
