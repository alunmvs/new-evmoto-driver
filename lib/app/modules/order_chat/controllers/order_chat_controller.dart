import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_driver/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/common_helper.dart';

class OrderChatController extends GetxController with WidgetsBindingObserver {
  final UploadImageRepository uploadImageRepository;

  OrderChatController({required this.uploadImageRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final orderDetailController = Get.find<OrderDetailController>();

  final textEditingController = TextEditingController();

  final isAttachmentOptionOpen = false.obs;
  final attachmentUrl = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .doc(orderDetailController.orderDetail.value.orderId.toString())
        .set({
          "driverId": orderDetailController.orderDetail.value.driverId,
          "driverName":
              orderDetailController.homeController.userInfo.value.name,
          "driverIsOnChatScreen": true,
          "driverChatScreenLastSeen": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();

    await FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .doc(orderDetailController.orderDetail.value.orderId.toString())
        .set({
          "driverId": orderDetailController.orderDetail.value.driverId,
          "driverName":
              orderDetailController.homeController.userInfo.value.name,
          "driverIsOnChatScreen": false,
          "driverChatScreenLastSeen": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(orderDetailController.orderDetail.value.orderId.toString())
          .set({
            "driverId": orderDetailController.orderDetail.value.driverId,
            "driverName":
                orderDetailController.homeController.userInfo.value.name,
            "driverIsOnChatScreen": true,
            "driverChatScreenLastSeen": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } else if (state == AppLifecycleState.paused) {
      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(orderDetailController.orderDetail.value.orderId.toString())
          .set({
            "driverId": orderDetailController.orderDetail.value.driverId,
            "driverName":
                orderDetailController.homeController.userInfo.value.name,
            "driverIsOnChatScreen": false,
            "driverChatScreenLastSeen": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    }
  }

  Stream<QuerySnapshot> getMessagesStream({required String roomId}) {
    return FirebaseFirestore.instance
        .collection('evmoto_order_chat_messages')
        .where('evmotoOrderChatParticipantsDocumentId', isEqualTo: roomId)
        .orderBy('createdAt', descending: false)
        .snapshots(includeMetadataChanges: true);
  }

  Future<void> sendMessage({required String message}) async {
    FirebaseFirestore.instance.collection('evmoto_order_chat_messages').add({
      "evmotoOrderChatParticipantsDocumentId": orderDetailController
          .orderDetail
          .value
          .orderId
          .toString(),
      "senderId": orderDetailController.orderDetail.value.userId,
      "senderType": "driver",
      "senderMessage": message,
      "senderAttachmentUrl": attachmentUrl.value == ""
          ? null
          : attachmentUrl.value,
      "sendAt": Timestamp.now(),
      "createdAt": FieldValue.serverTimestamp(),
    }).ignore();

    attachmentUrl.value = "";
    isAttachmentOptionOpen.value = false;
    textEditingController.clear();
  }

  Future<void> uploadAttachmentFromGallery() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      showLoadingDialog();
      attachmentUrl.value = await uploadImageRepository.uploadImage(
        file: image,
      );

      Get.close(1);
    }
  }

  Future<void> uploadAttachmentFromCamera() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      showLoadingDialog();
      attachmentUrl.value = await uploadImageRepository.uploadImage(
        file: image,
      );

      Get.close(1);
    }
  }
}
