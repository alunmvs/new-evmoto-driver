import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_driver/app/modules/chat_list/controllers/chat_list_controller.dart';
import 'package:new_evmoto_driver/app/modules/chat_list/views/chat_list_view.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../../helpers/module_test_helpers.dart';

class TestChatListController extends ChatListController {
  @override
  // ignore: must_call_super
  Future<void> onInit() async {
    isFetch.value = false;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatListView', () {
    late TestChatListController controller;

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

    Future<void> pumpView(
      WidgetTester tester, {
      List<GetPage<dynamic>>? getPages,
    }) async {
      await pumpModuleView(
        tester,
        const ChatListView(),
        getPages: getPages,
      );
      await tester.pump();
    }

    setUp(() async {
      await setupModuleTestEnvironment();
      registerCommonModuleDependencies();
      registerMockUserServices();
      controller = TestChatListController();
      Get.put<ChatListController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders loading indicator while fetching chat list', (
      tester,
    ) async {
      controller.isFetch.value = true;

      await pumpView(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Belum ada pesan'), findsNothing);
    });

    testWidgets('renders chat list title in app bar', (tester) async {
      await pumpView(tester);

      expect(find.text('Pesan'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders empty state when room list is empty', (tester) async {
      controller.roomList.clear();

      await pumpView(tester);

      expect(find.text('Belum ada pesan'), findsOneWidget);
      expect(
        find.text(
          'Percakapan akan ditampilkan di sini setelah Anda mengirim atau menerima pesan.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders chat room items with user name, order id, and last message',
        (tester) async {
      controller.roomList.assignAll([
        sampleRoom(
          userName: 'Alice',
          orderId: 'ORD-100',
          lastMessage: 'Where are you?',
        ),
      ]);

      await pumpView(tester);

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('ORD-100'), findsOneWidget);
      expect(find.text('Where are you?'), findsOneWidget);
    });

    testWidgets('renders default profile avatar when user profile url is empty', (
      tester,
    ) async {
      controller.roomList.assignAll([
        sampleRoom(userProfileUrl: ''),
      ]);

      await pumpView(tester);

      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders unread badge when totalUnreadChatUser is greater than zero',
        (tester) async {
      controller.roomList.assignAll([
        sampleRoom(totalUnreadChatUser: 3),
      ]);

      await pumpView(tester);

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders last message time when lastMessageAt is available', (
      tester,
    ) async {
      controller.roomList.assignAll([
        sampleRoom(lastMessageAt: DateTime(2026, 6, 13, 9, 5)),
      ]);

      await pumpView(tester);

      expect(find.text('09:05'), findsOneWidget);
    });

    testWidgets('disables pull up loading when see more is disabled', (
      tester,
    ) async {
      controller.isSeeMoreRoomList.value = false;

      await pumpView(tester);

      final refresher = tester.widget<SmartRefresher>(find.byType(SmartRefresher));
      expect(refresher.enablePullUp, isFalse);
    });

    testWidgets('enables pull up loading when see more is enabled', (
      tester,
    ) async {
      controller.isSeeMoreRoomList.value = true;

      await pumpView(tester);

      final refresher = tester.widget<SmartRefresher>(find.byType(SmartRefresher));
      expect(refresher.enablePullUp, isTrue);
    });

    testWidgets('navigates to chat detail when chat room is tapped', (
      tester,
    ) async {
      controller.roomList.assignAll([
        sampleRoom(docId: 'chat-doc-99', userName: 'Tap User'),
      ]);

      await pumpView(
        tester,
        getPages: [
          GetPage(
            name: Routes.CHAT_DETAIL,
            page: () => const Scaffold(body: Text('Chat Detail')),
          ),
        ],
      );

      await tester.tap(find.text('Tap User'));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, Routes.CHAT_DETAIL);
      expect(find.text('Chat Detail'), findsOneWidget);
    });
  });
}
