import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/consts/order_state_const.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
import 'package:new_evmoto_driver/app/data/models/vehicle_statistics_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/services/location_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeController', () {
    late HomeController controller;
    late MockVehicleRepository mockVehicleRepository;
    late MockOrderRepository mockOrderRepository;
    late MockUserRepository mockUserRepository;
    late MockAccountRepository mockAccountRepository;
    late MockVersioningServerRepository mockVersioningServerRepository;
    late MockGuaranteeIncomeRepository mockGuaranteeIncomeRepository;
    late MockAdvanceBookingRepository mockAdvanceBookingRepository;

    Language homeLanguage() {
      return Language(
        orderStateWaitingList: 'Waiting List',
        orderStateToBeStarted: 'To Be Started',
        orderStateScheduledArrivalPlace: 'Scheduled Arrival',
        orderStateWaitForPassengersToBoard: 'Wait For Boarding',
        orderStateServing: 'Serving',
        orderStateCompletionService: 'Completion Service',
        orderStateToBePaid: 'To Be Paid',
        orderStateToBeEvaluated: 'To Be Evaluated',
        orderStateCompleted: 'Completed',
        orderStateCancelled: 'Cancelled',
        orderStateBeingReassigned: 'Being Reassigned',
        orderStateCancelPendingPayment: 'Cancel Pending Payment',
      );
    }

    void stubVehicleStatistics({int work = 2}) {
      when(
        () => mockVehicleRepository.getVehicleStatisticsDetail(
          language: any(named: 'language'),
        ),
      ).thenAnswer(
        (_) async => VehicleStatistics(work: work, dayNum: 0, mouthNum: 0),
      );
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(language: homeLanguage());
      registerHomeControllerDependencies();
      registerMockUserServices();

      mockVehicleRepository = MockVehicleRepository();
      mockOrderRepository = MockOrderRepository();
      mockUserRepository = MockUserRepository();
      mockAccountRepository = MockAccountRepository();
      mockVersioningServerRepository = MockVersioningServerRepository();
      mockGuaranteeIncomeRepository = MockGuaranteeIncomeRepository();
      mockAdvanceBookingRepository = MockAdvanceBookingRepository();

      controller = HomeController(
        vehicleRepository: mockVehicleRepository,
        orderRepository: mockOrderRepository,
        userRepository: mockUserRepository,
        accountRepository: mockAccountRepository,
        versioningServerRepository: mockVersioningServerRepository,
        guaranteeIncomeRepository: mockGuaranteeIncomeRepository,
        advanceBookingRepository: mockAdvanceBookingRepository,
      );
      controller.userInfo.value = UserInfo(balance: 50000, name: 'Test Driver');
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with default observable values',
      () {
        expect(controller.selectedIndex.value, 0);
        expect(controller.workStatus.value, 2);
        expect(controller.isFetch.value, false);
        expect(controller.orderGrabbingHallList, isEmpty);
        expect(controller.orderInServiceList, isEmpty);
        expect(controller.orderToBeServedList, isEmpty);
        expect(controller.userInfo.value.balance, 50000);
      },
    );

    test(
      'getStringOrderState should return localized order state labels',
      () {
        expect(
          controller.getStringOrderState(state: OrderState.WAITING_LIST),
          'Waiting List',
        );
        expect(
          controller.getStringOrderState(state: OrderState.SERVING),
          'Serving',
        );
        expect(
          controller.getStringOrderState(state: OrderState.COMPLETED),
          'Completed',
        );
        expect(controller.getStringOrderState(state: 999), '-');
      },
    );

    test(
      'getBackgroundColorOrderState should return expected colors',
      () {
        expect(
          controller.getBackgroundColorOrderState(
            state: OrderState.WAITING_LIST,
          ),
          const Color(0XFFFFA3A3),
        );
        expect(
          controller.getBackgroundColorOrderState(
            state: OrderState.TO_BE_STARTED,
          ),
          const Color(0XFFD7EAFF),
        );
        expect(
          controller.getBackgroundColorOrderState(state: 999),
          const Color(0XFFFFA3A3),
        );
      },
    );

    test(
      'isSameDay should compare dates by year month and day only',
      () {
        final morning = DateTime(2026, 6, 13, 8);
        final evening = DateTime(2026, 6, 13, 20);
        final nextDay = DateTime(2026, 6, 14, 8);

        expect(controller.isSameDay(morning, evening), isTrue);
        expect(controller.isSameDay(morning, nextDay), isFalse);
      },
    );

    test(
      'setInitialLatitudeLongitude should copy current location values',
      () {
        final locationServices = Get.find<LocationServices>();
        locationServices.currentLatitude.value = -6.2;
        locationServices.currentLongitude.value = 106.8;

        controller.setInitialLatitudeLongitude();

        expect(controller.initialLatitude.value, -6.2);
        expect(controller.initialLongitude.value, 106.8);
      },
    );

    test(
      'getOrderGrabbingHallList should load orders and update pagination flags',
      () async {
        when(
          () => mockOrderRepository.getOrderList(
            size: any(named: 'size'),
            language: any(named: 'language'),
            state: any(named: 'state'),
            pageNum: any(named: 'pageNum'),
          ),
        ).thenAnswer(
          (_) async => [Order(id: 1, type: 1), Order(id: 2, type: 1)],
        );

        await controller.getOrderGrabbingHallList();

        expect(controller.orderGrabbingHallList.length, 2);
        expect(controller.orderGrabbingHallPageNum.value, 1);
        expect(controller.isOrderToBeServedListNotEmpty.value, isTrue);
        expect(controller.isSeeMoreOrderGrabbingHall.value, isTrue);
        verify(
          () => mockOrderRepository.getOrderList(
            size: 10,
            language: any(named: 'language'),
            state: 3,
            pageNum: 1,
          ),
        ).called(1);
      },
    );

    test(
      'getOrderGrabbingHallList should disable see more when list is empty',
      () async {
        when(
          () => mockOrderRepository.getOrderList(
            size: any(named: 'size'),
            language: any(named: 'language'),
            state: any(named: 'state'),
            pageNum: any(named: 'pageNum'),
          ),
        ).thenAnswer((_) async => <Order>[]);

        await controller.getOrderGrabbingHallList();

        expect(controller.orderGrabbingHallList, isEmpty);
        expect(controller.isOrderToBeServedListNotEmpty.value, isFalse);
        expect(controller.isSeeMoreOrderGrabbingHall.value, isFalse);
      },
    );

    test(
      'onSwitchStatusWork should start work when driver is offline',
      () async {
        controller.vehicleStatistics.value = VehicleStatistics(work: 2);
        stubVehicleStatistics(work: 1);
        when(
          () => mockUserRepository.startWork(
            language: any(named: 'language'),
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) async {});

        await controller.onSwitchStatusWork();

        expect(controller.workStatus.value, 1);
        expect(controller.onlineAt.value, isNotNull);
        verify(
          () => mockUserRepository.startWork(
            language: any(named: 'language'),
            type: 1,
          ),
        ).called(1);
        verify(
          () => mockVehicleRepository.getVehicleStatisticsDetail(
            language: any(named: 'language'),
          ),
        ).called(1);
      },
    );

    test(
      'onSwitchStatusWork should stop work when driver is online',
      () async {
        controller.vehicleStatistics.value = VehicleStatistics(work: 1);
        stubVehicleStatistics(work: 2);
        when(
          () => mockUserRepository.stopWork(language: any(named: 'language')),
        ).thenAnswer((_) async {});

        await controller.onSwitchStatusWork();

        expect(controller.workStatus.value, 2);
        verify(() => mockUserRepository.stopWork(language: 2)).called(1);
        verify(
          () => mockVehicleRepository.getVehicleStatisticsDetail(
            language: any(named: 'language'),
          ),
        ).called(1);
      },
    );

    test(
      'setHomeControllerRegistered should persist registration flag',
      () async {
        await controller.setHomeControllerRegistered();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('home_controller_registered'), isTrue);
      },
    );

    test(
      'should clean up controller without error when onClose is called',
      () async {
        await expectLater(controller.onClose(), completes);
      },
    );
  });
}
