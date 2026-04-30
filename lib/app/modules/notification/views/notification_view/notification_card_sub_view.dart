import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/notification/controllers/notification_controller.dart';
import 'package:new_evmoto_driver/app/data/models/notification_model.dart';

class NotificationCardSubView extends GetView<NotificationController> {
  final Notification notification;

  const NotificationCardSubView({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notification.type == 2 ? "Informasi Sistem" : "Pengumuman",
                style: controller.typographyServices.bodyLargeRegular.value
                    .copyWith(color: Color(0XFF696969)),
              ),
              Text(
                notification.time ?? "-",
                style: controller.typographyServices.bodyLargeRegular.value
                    .copyWith(color: Color(0XFF696969)),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            notification.content ?? "-",
            style: controller.typographyServices.bodySmallRegular.value
                .copyWith(color: Color(0XFFB3B3B3)),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
