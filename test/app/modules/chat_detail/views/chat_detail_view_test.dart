import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_driver/app/data/models/evmoto_order_chat_messages_model.dart';
import 'package:new_evmoto_driver/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_driver/app/data/models/language_model.dart';
import 'package:new_evmoto_driver/app/modules/chat_detail/controllers/chat_detail_controller.dart';
import 'package:new_evmoto_driver/app/modules/chat_detail/views/chat_detail_view.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';
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

class TestableChatDetailController extends ChatDetailController {
  TestableChatDetailController({required super.uploadImageRepository});

  @override
  // ignore: must_call_super
  Future<void> onInit() async {
    isFetch.value = false;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatDetailView', () {
    late TestableChatDetailController controller;
    late MockUploadImageRepository mockUploadImageRepository;

    Future<void> pumpView(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await pumpModuleView(tester, const ChatDetailView());
      await tester.pump();
      while (tester.takeException() != null) {}
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies(
        language: Language(
          noMessagesYet: 'No messages yet',
          typeMessage: 'Type a message',
          gallery: 'Gallery',
          camera: 'Camera',
        ),
      );
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
      mockUploadImageRepository = MockUploadImageRepository();
      controller = TestableChatDetailController(
        uploadImageRepository: mockUploadImageRepository,
      );
      controller.isFetch.value = false;
      Get.put<ChatDetailController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders loading indicator while fetching chat data', (
      tester,
    ) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders participant name in app bar', (tester) async {
      controller.evmotoOrderChatParticipants.value =
          EvmotoOrderChatParticipants(userName: 'John Doe');

      await pumpView(tester);

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders dash when participant name is empty', (tester) async {
      controller.evmotoOrderChatParticipants.value =
          EvmotoOrderChatParticipants(userName: '');

      await pumpView(tester);

      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('renders empty state when there are no messages', (
      tester,
    ) async {
      controller.evmotoOrderChatMessagesList.clear();

      await pumpView(tester);

      expect(find.text('No messages yet'), findsOneWidget);
    });

    testWidgets('renders user and driver chat messages', (tester) async {
      final now = DateTime(2026, 6, 13, 14, 30);
      controller.evmotoOrderChatMessagesList.assignAll([
        EvmotoOrderChatMessages(
          senderType: 'user',
          senderMessage: 'Hello driver',
          createdAt: now,
        ),
        EvmotoOrderChatMessages(
          senderType: 'driver',
          senderMessage: 'On my way',
          sendAt: now,
          isRead: true,
        ),
      ]);

      await pumpView(tester);

      expect(find.text('Hello driver'), findsOneWidget);
      expect(find.text('On my way'), findsOneWidget);
      expect(find.text('14:30'), findsNWidgets(2));
    });

    testWidgets('shows trip ended banner when trip has ended', (tester) async {
      controller.isTripHasEnded.value = true;

      await pumpView(tester);

      expect(
        find.text(
          'Anda tidak dapat mengirim pesan setelah perjalanan sudah selesai.',
        ),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('shows message input when trip is still active', (tester) async {
      controller.isTripHasEnded.value = false;

      await pumpView(tester);

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Type a message'), findsOneWidget);
    });

    testWidgets('shows attachment options when attachment menu is open', (
      tester,
    ) async {
      controller.isTripHasEnded.value = false;
      controller.isAttachmentOptionOpen.value = true;

      await pumpView(tester);

      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);
    });

    testWidgets('hides attachment options when attachment menu is closed', (
      tester,
    ) async {
      controller.isTripHasEnded.value = false;
      controller.isAttachmentOptionOpen.value = false;

      await pumpView(tester);

      expect(find.text('Gallery'), findsNothing);
      expect(find.text('Camera'), findsNothing);
    });

    testWidgets('updates message field when user types', (tester) async {
      controller.isTripHasEnded.value = false;

      await pumpView(tester);

      await tester.enterText(find.byType(TextField), 'Need help');
      await tester.pump();

      expect(controller.message.value, 'Need help');
      expect(find.text('Need help'), findsOneWidget);
    });
  });
}
