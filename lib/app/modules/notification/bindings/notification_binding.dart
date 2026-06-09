import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/notification_repository.dart';

import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        notificationRepository: NotificationRepository(),
      ),
    );
  }
}
