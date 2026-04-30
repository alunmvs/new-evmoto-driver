import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/sendbird_chat_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_driver/app/widgets/loading_dialog.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:uuid/uuid.dart';

import '../../../routes/app_pages.dart';

class MyGroupChannelHandler extends GroupChannelHandler {
  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    Get.find<SendbirdChatDetailController>().messageList.add(message);

    if (Get.currentRoute == Routes.SENDBIRD_CHAT_DETAIL) {
      Get.find<SendbirdChatDetailController>().groupChannel.value!.markAsRead();
    }
  }

  @override
  void onReadStatusUpdated(GroupChannel channel) {
    Get.find<SendbirdChatDetailController>().getMemberReadStatus();
  }
}

class SendbirdChatDetailController extends GetxController {
  final homeController = Get.find<HomeController>();
  final sendbirdChatServices = Get.find<SendbirdChatServices>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final textEditingController = TextEditingController();
  final refreshController = RefreshController();
  final isAttachmentOptionOpen = false.obs;

  final userId = Rx<String?>(null);
  final userName = Rx<String?>(null);
  final userProfileUrl = Rx<String?>(null);

  final groupChannelUrl = Rx<String?>(null);
  final groupChannel = Rx<GroupChannel?>(null);

  final membersReadStatus = {}.obs;

  final messageList = <RootMessage>[].obs;
  final isSeeMoreMessageList = true.obs;
  final uniqueHandlerUuid = "".obs;

  final isTripHasEnded = true.obs;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    isCriticalError.value = false;

    if (sendbirdChatServices.isSuccessInitialize.value == false) {
      await sendbirdChatServices.isSuccessInitialize.stream.firstWhere(
        (value) => value == true,
      );
    }

    try {
      groupChannelUrl.value = Get.arguments['group_channel_url'];
      await getGroupChannel();
      await getMessageList();
      await groupChannel.value!.markAsRead();
      getMemberReadStatus();

      getUserProfileUrl();
      getUserName();
      getUserId();

      var uuid = Uuid();
      uniqueHandlerUuid.value = uuid.v4();

      SendbirdChat.addChannelHandler(
        uniqueHandlerUuid.value,
        MyGroupChannelHandler(),
      );

      await checkIfTripHasEnded();
    } on RequestFailedException catch (e) {
      SnackbarHelper.showSnackbarError(
        text: "Terjadi kesalahan dari server (${e.code})",
      );
      isCriticalError.value = true;
    }

    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    SendbirdChat.removeChannelHandler(uniqueHandlerUuid.value);
  }

  void getMemberReadStatus() {
    final membersReadStatus = groupChannel.value!.getReadStatus(true);
    this.membersReadStatus.value = membersReadStatus;
    this.membersReadStatus.refresh();
  }

  Future<void> getGroupChannel() async {
    groupChannel.value = await GroupChannel.getChannel(groupChannelUrl.value!);
  }

  Future<void> getMessageList() async {
    final params = MessageListParams()
      ..previousResultSize = 10
      ..nextResultSize = 0
      ..includeReactions = true
      ..includeMetaArray = true;

    messageList.value = await groupChannel.value!.getMessagesByTimestamp(
      DateTime.now().millisecondsSinceEpoch,
      params,
    );
  }

  Future<void> seeMoreMessageList() async {
    final params = MessageListParams()
      ..previousResultSize = 10
      ..nextResultSize = 0
      ..includeReactions = true
      ..includeMetaArray = true;

    var messageList = await groupChannel.value!.getMessagesByTimestamp(
      this.messageList.first.createdAt,
      params,
    );

    isSeeMoreMessageList.value = messageList.isEmpty;

    for (var message in messageList.reversed) {
      this.messageList.insert(0, message);
    }
  }

  Future<void> sendMessage({required String message}) async {
    final userMessage = groupChannel.value!.sendUserMessage(
      UserMessageCreateParams(message: message),
    );

    messageList.add(userMessage);
    textEditingController.clear();
  }

  void getUserProfileUrl() {
    for (var member in groupChannel.value!.members) {
      if (member.userId.contains("user_")) {
        userProfileUrl.value = member.profileUrl;
      }
    }
  }

  void getUserName() {
    for (var member in groupChannel.value!.members) {
      if (member.userId.contains("user_")) {
        userName.value = member.nickname;
      }
    }
  }

  void getUserId() {
    for (var member in groupChannel.value!.members) {
      if (member.userId.contains("user_")) {
        userId.value = member.userId;
      }
    }
  }

  Future<void> sendAttachmentFromGallery() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      var fileMessageCreateParams = FileMessageCreateParams.withFile(
        File(image.path),
      );

      groupChannel.value!.sendFileMessage(
        fileMessageCreateParams,
        handler: (message, e) {
          messageList.add(message);
        },
        progressHandler: (sentBytes, totalBytes) {
          if (sentBytes < totalBytes) {
            if (Get.isDialogOpen == false) {
              Get.dialog(LoadingDialog(), barrierDismissible: false);
            }
          } else {
            if (Get.isDialogOpen == true) {
              Get.close(1);
            }
          }
        },
      );

      isAttachmentOptionOpen.value = false;
      textEditingController.clear();
    }
  }

  Future<void> sendAttachmentFromCamera() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      Get.dialog(LoadingDialog(), barrierDismissible: false);

      var fileMessageCreateParams = FileMessageCreateParams.withFile(
        File(image.path),
      );

      groupChannel.value!.sendFileMessage(
        fileMessageCreateParams,
        handler: (message, e) {
          messageList.add(message);
        },
        progressHandler: (sentBytes, totalBytes) {
          if (sentBytes < totalBytes) {
            if (Get.isDialogOpen == false) {
              Get.dialog(LoadingDialog(), barrierDismissible: false);
            }
          } else {
            if (Get.isDialogOpen == true) {
              Get.close(1);
            }
          }
        },
      );

      // messageList.add(userMessage);
      isAttachmentOptionOpen.value = false;
      textEditingController.clear();

      Get.close(1);
    }
  }

  bool isChatRead({
    required DateTime messageCreatedAt,
    required DateTime userLastSeenAt,
  }) {
    return userLastSeenAt.isAfter(messageCreatedAt) ||
        userLastSeenAt.isAtSameMomentAs(messageCreatedAt);
  }

  Future<void> checkIfTripHasEnded() async {
    isTripHasEnded.value = true;

    // TODO
    await homeController.getWorking();

    //     if (userId.value != null) {

    //         if (int.parse(userId.value!.replaceAll("user_id", "")) ==
    // homeController.working.value.) {
    //           isTripHasEnded.value = false;
    //         }

    //     }
  }
}
