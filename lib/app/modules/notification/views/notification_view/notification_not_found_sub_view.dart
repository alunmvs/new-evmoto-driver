import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/notification/controllers/notification_controller.dart';

class NotificationNotFoundSubView extends GetView<NotificationController> {
  const NotificationNotFoundSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 120),
          Image.asset(
            "assets/images/img_notification_empty.png",
            width: 100,
            height: 100,
          ),
          SizedBox(height: 16),
          Text(
            "Saat Ini Belum Terdapat Notifikasi",
            textAlign: TextAlign.center,
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          SizedBox(height: 8),
          Text(
            "Tidak ada notifikasi saat ini. Silakan cek kembali nanti untuk informasi terbaru.",
            textAlign: TextAlign.center,
            style: controller.typographyServices.bodySmallRegular.value,
          ),
        ],
      ),
    );
  }
}
