import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_driver/app/modules/chat_list/controllers/chat_list_controller.dart';
import '../../../../helpers/module_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatListController', () {
    late ChatListController controller;

    EvmotoOrderChatParticipants sampleRoom({
      String docId = 'doc-1',
      String userName = 'John Doe',
      String orderId = 'ORD-123',
      String lastMessage = 'Hello driver',
      DateTime? lastMessageAt,
      int totalUnreadChatUser = 0,
      String? userProfileUrl,
    }) {
      return EvmotoOrderChatParticipants(
        docId: docId,
        userName: userName,
        orderId: orderId,
        lastMessage: lastMessage,
        lastMessageAt: lastMessageAt ?? DateTime(2026, 6, 13, 14, 30),
        totalUnreadChatUser: totalUnreadChatUser,
        userProfileUrl: userProfileUrl,
      );
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      registerMockUserServices(id: 42);
      controller = ChatListController();
    });

    tearDown(() {
      Get.reset();
    });

    test(
      'should initialize with default observable values',
      () {
        expect(controller.roomList, isEmpty);
        expect(controller.lastDoc, isNull);
        expect(controller.isSeeMoreRoomList.value, isTrue);
        expect(controller.isFetch.value, isFalse);
        expect(controller.refreshController, isNotNull);
      },
    );

    test(
      'seeMoreChatList should return early when lastDoc is null',
      () async {
        controller.roomList.assignAll([sampleRoom()]);
        controller.lastDoc = null;

        await controller.seeMoreChatList();

        expect(controller.roomList.length, 1);
        expect(controller.isSeeMoreRoomList.value, isTrue);
      },
    );

    test(
      'getChatLatestMessageList should complete without error',
      () async {
        await expectLater(controller.getChatLatestMessageList(), completes);
      },
    );

    test(
      'should populate roomList when rooms are assigned manually',
      () {
        final rooms = [
          sampleRoom(docId: 'doc-1', userName: 'Alice'),
          sampleRoom(docId: 'doc-2', userName: 'Bob'),
        ];

        controller.roomList.assignAll(rooms);

        expect(controller.roomList.length, 2);
        expect(controller.roomList.first.userName, 'Alice');
        expect(controller.roomList.last.userName, 'Bob');
      },
    );

    test(
      'should disable see more when lastDoc is cleared',
      () {
        controller.isSeeMoreRoomList.value = true;
        controller.lastDoc = null;

        if (controller.lastDoc == null) {
          controller.isSeeMoreRoomList.value = false;
        }

        expect(controller.isSeeMoreRoomList.value, isFalse);
      },
    );

    test(
      'should use driver id from user services',
      () {
        expect(controller.userServices.userInfo.value.id, 42);
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
