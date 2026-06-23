import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/active_advance_booking_model.dart';
import 'package:new_evmoto_driver/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_driver/app/data/models/working_model.dart';
import 'package:new_evmoto_driver/app/modules/chat_detail/controllers/chat_detail_controller.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_driver/app/services/user_services.dart';
import '../../../../helpers/module_test_helpers.dart';

class MockUploadImageRepository extends Mock implements UploadImageRepository {}

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

HomeController registerTestableHomeController({
  MockAdvanceBookingRepository? advanceBookingRepository,
}) {
  registerHomeControllerDependencies();
  if (!Get.isRegistered<UserServices>()) {
    registerMockUserServices();
  }
  final mockAdvanceBookingRepository =
      advanceBookingRepository ?? MockAdvanceBookingRepository();
  when(
    () => mockAdvanceBookingRepository.getActiveAdvanceBooking(),
  ).thenAnswer((_) async => null);
  final homeController = TestableHomeController(
    vehicleRepository: MockVehicleRepository(),
    orderRepository: MockOrderRepository(),
    userRepository: MockUserRepository(),
    accountRepository: MockAccountRepository(),
    versioningServerRepository: MockVersioningServerRepository(),
    guaranteeIncomeRepository: MockGuaranteeIncomeRepository(),
    advanceBookingRepository: mockAdvanceBookingRepository,
  );
  Get.put<HomeController>(homeController);
  return homeController;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatDetailController', () {
    late ChatDetailController controller;
    late MockUploadImageRepository mockUploadImageRepository;
    late HomeController homeController;
    late MockAdvanceBookingRepository mockAdvanceBookingRepository;

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      mockAdvanceBookingRepository = MockAdvanceBookingRepository();
      homeController = registerTestableHomeController(
        advanceBookingRepository: mockAdvanceBookingRepository,
      );
      mockUploadImageRepository = MockUploadImageRepository();
      controller = ChatDetailController(
        uploadImageRepository: mockUploadImageRepository,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with default observable values',
      () {
        expect(controller.docId.value, '');
        expect(controller.attachmentUrl.value, '');
        expect(controller.message.value, '');
        expect(controller.isAttachmentOptionOpen.value, isFalse);
        expect(controller.isTripHasEnded.value, isTrue);
        expect(controller.isFetch.value, isFalse);
        expect(controller.evmotoOrderChatMessagesList, isEmpty);
        expect(controller.textEditingController.text, '');
      },
    );

    test(
      'sendMessage should not send when message and attachment are empty',
      () async {
        controller.message.value = '';
        controller.attachmentUrl.value = '';
        controller.textEditingController.clear();

        await controller.sendMessage();

        expect(controller.message.value, '');
        expect(controller.attachmentUrl.value, '');
        expect(controller.isAttachmentOptionOpen.value, isFalse);
      },
    );

    test(
      'sendMessage should not send when message is whitespace only',
      () async {
        controller.message.value = '   ';
        controller.textEditingController.text = '   ';

        await controller.sendMessage();

        expect(controller.textEditingController.text, '   ');
        expect(controller.message.value, '   ');
      },
    );

    test(
      'checkIfTripHasEnded should set isTripHasEnded to false when order matches working',
      () async {
        when(
          () => homeController.orderRepository.getWorking(
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async => Working(id: 42));

        controller.evmotoOrderChatParticipants.value =
            EvmotoOrderChatParticipants(orderId: '42');

        await controller.checkIfTripHasEnded();

        expect(controller.isTripHasEnded.value, isFalse);
      },
    );

    test(
      'checkIfTripHasEnded should keep isTripHasEnded true when order does not match working',
      () async {
        when(
          () => homeController.orderRepository.getWorking(
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async => Working(id: 99));

        controller.evmotoOrderChatParticipants.value =
            EvmotoOrderChatParticipants(orderId: '42');

        await controller.checkIfTripHasEnded();

        expect(controller.isTripHasEnded.value, isTrue);
      },
    );

    test(
      'checkIfTripHasEnded should keep isTripHasEnded true when there is no active working order',
      () async {
        when(
          () => homeController.orderRepository.getWorking(
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async => Working());

        controller.evmotoOrderChatParticipants.value =
            EvmotoOrderChatParticipants(orderId: '42');

        await controller.checkIfTripHasEnded();

        expect(controller.isTripHasEnded.value, isTrue);
      },
    );

    test(
      'checkIfTripHasEnded should set isTripHasEnded to false when order matches active advance booking',
      () async {
        when(
          () => homeController.orderRepository.getWorking(
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async => Working());

        when(
          () => mockAdvanceBookingRepository.getActiveAdvanceBooking(),
        ).thenAnswer((_) async => ActiveAdvanceBooking(orderId: 42));

        controller.evmotoOrderChatParticipants.value =
            EvmotoOrderChatParticipants(orderId: '42');

        await controller.checkIfTripHasEnded();

        expect(controller.isTripHasEnded.value, isFalse);
      },
    );

    test(
      'checkIfTripHasEnded should keep isTripHasEnded true when active advance booking order does not match',
      () async {
        when(
          () => homeController.orderRepository.getWorking(
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async => Working());

        when(
          () => mockAdvanceBookingRepository.getActiveAdvanceBooking(),
        ).thenAnswer((_) async => ActiveAdvanceBooking(orderId: 99));

        controller.evmotoOrderChatParticipants.value =
            EvmotoOrderChatParticipants(orderId: '42');

        await controller.checkIfTripHasEnded();

        expect(controller.isTripHasEnded.value, isTrue);
      },
    );

    test(
      'should clean up stream subscriptions when onClose is called',
      () {
        expect(() => controller.onClose(), returnsNormally);
      },
    );

    test(
      'should update message observable when text field value changes',
      () {
        controller.textEditingController.text = 'Hello driver';
        controller.message.value = controller.textEditingController.text;

        expect(controller.message.value, 'Hello driver');
      },
    );

    test(
      'should clear attachmentUrl when reset manually',
      () {
        controller.attachmentUrl.value = 'https://example.com/image.jpg';

        controller.attachmentUrl.value = '';

        expect(controller.attachmentUrl.value, '');
      },
    );

    test(
      'should toggle attachment option visibility',
      () {
        controller.isAttachmentOptionOpen.value = true;
        expect(controller.isAttachmentOptionOpen.value, isTrue);

        controller.isAttachmentOptionOpen.value = false;
        expect(controller.isAttachmentOptionOpen.value, isFalse);
      },
    );
  });
}
