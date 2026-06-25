import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_driver/app/data/models/order_detail_model.dart';

class ChatRoomServices extends GetxService {
  static const _collection = 'evmoto_order_chat_participants';

  Future<EvmotoOrderChatParticipants?> getExistingChatRoom({
    required String orderId,
    required String userId,
    required String driverId,
  }) async {
    var result =
        (await FirebaseFirestore.instance
                .collection(_collection)
                .where("orderId", isEqualTo: orderId)
                .where("userId", isEqualTo: userId)
                .where("driverId", isEqualTo: driverId)
                .orderBy("createdAt", descending: true)
                .get())
            .docs;

    if (result.isEmpty) return null;

    var participant = EvmotoOrderChatParticipants.fromJson(result.first.data());
    participant.docId = result.first.id;
    return participant;
  }

  Future<EvmotoOrderChatParticipants?> ensureChatRoomExists({
    required String orderId,
    required String userId,
    required String driverId,
    String? userName,
    String? userProfileUrl,
    required String driverName,
    String? driverProfileUrl,
  }) async {
    if (orderId.isEmpty ||
        userId.isEmpty ||
        driverId.isEmpty ||
        driverId == '0') {
      return null;
    }

    var existing = await getExistingChatRoom(
      orderId: orderId,
      userId: userId,
      driverId: driverId,
    );
    if (existing != null) return existing;

    var duplicateCheck =
        (await FirebaseFirestore.instance
                .collection(_collection)
                .where("orderId", isEqualTo: orderId)
                .where("userId", isEqualTo: userId)
                .where("driverId", isEqualTo: driverId)
                .get())
            .docs;

    if (duplicateCheck.isNotEmpty) {
      var participant = EvmotoOrderChatParticipants.fromJson(
        duplicateCheck.first.data(),
      );
      participant.docId = duplicateCheck.first.id;
      return participant;
    }

    existing = await getExistingChatRoom(
      orderId: orderId,
      userId: userId,
      driverId: driverId,
    );
    if (existing != null) return existing;

    await FirebaseFirestore.instance.collection(_collection).add({
      "orderId": orderId,
      "userId": userId,
      "userName": userName,
      "userProfileUrl": userProfileUrl,
      "driverId": driverId,
      "driverName": driverName,
      "driverProfileUrl": driverProfileUrl,
      "createdAt": FieldValue.serverTimestamp(),
    });

    return getExistingChatRoom(
      orderId: orderId,
      userId: userId,
      driverId: driverId,
    );
  }

  Future<EvmotoOrderChatParticipants?> ensureChatRoomFromOrderDetail({
    required OrderDetail orderDetail,
    required String driverName,
    String? driverProfileUrl,
  }) async {
    if (orderDetail.userId == null ||
        orderDetail.driverId == null ||
        orderDetail.driverId == 0 ||
        orderDetail.orderId == null) {
      return null;
    }

    return ensureChatRoomExists(
      orderId: orderDetail.orderId.toString(),
      userId: orderDetail.userId.toString(),
      driverId: orderDetail.driverId.toString(),
      userName: orderDetail.nickName,
      userProfileUrl: orderDetail.userHeadImg,
      driverName: driverName,
      driverProfileUrl: driverProfileUrl,
    );
  }
}
