import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/order_pending_dispatch_model.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/services/background_services.dart';

class AppLifecycleController extends GetxController
    with WidgetsBindingObserver {
  final isForeground = true.obs;
  final backgroundServices = Get.find<BackgroundServices>();
  final orderPendingDispatch = OrderPendingDispatch().obs;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        isForeground.value = true;
        await backgroundServices.refreshState();
        onAppForeground();
        await getOrderPendingDispatch();
        break;

      case AppLifecycleState.paused:
        isForeground.value = false;
        await backgroundServices.refreshState();
        onAppBackground();
        break;

      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.detached:
        FlutterBackgroundService().invoke("stopService");
        break;

      case AppLifecycleState.hidden:
        break;
    }
  }

  void onAppForeground() {}

  void onAppBackground() {}

  Future<void> getOrderPendingDispatch() async {
    var orderRepository = OrderRepository();
    var homeController = Get.find<HomeController>();

    print("[DEBUG PENDING DISPATCH] start");

    orderPendingDispatch.value =
        (await orderRepository.getOrderPendingDispatch()) ??
        OrderPendingDispatch();

    if (orderPendingDispatch.value.order?.orderId != null) {
      print(
        "[DEBUG PENDING DISPATCH] start-1 ini reservation ${orderPendingDispatch.value.order?.reservation}",
      );
      if (orderPendingDispatch.value.order?.reservation == 1) {
        print("[DEBUG PENDING DISPATCH] start-2.1");
        await Future.wait([
          homeController.refreshAll(),
          homeController.showDialogOrderConfirmation(
            socketOrderStatusData: SocketOrderStatusData(
              orderId: orderPendingDispatch.value.order?.orderId,
              orderType: orderPendingDispatch.value.order?.orderType,
              state: orderPendingDispatch.value.order?.state,
              time:
                  DateTime.fromMillisecondsSinceEpoch(
                        orderPendingDispatch.value.endTime!,
                      )
                      .difference(
                        DateTime.fromMillisecondsSinceEpoch(
                          orderPendingDispatch.value.startTime!,
                        ),
                      )
                      .inSeconds,
              travelTime: orderPendingDispatch.value.order?.travelTime,
            ),
          ),
        ]);
      } else {
        print("[DEBUG PENDING DISPATCH] start-2.2");
        await Future.wait([
          homeController.refreshAll(),
          homeController.showDialogAdvancedBookingConfirmation(
            socketOrderStatusData: SocketOrderStatusData(
              orderId: orderPendingDispatch.value.order?.orderId,
              orderType: orderPendingDispatch.value.order?.orderType,
              state: orderPendingDispatch.value.order?.state,
              time:
                  DateTime.fromMillisecondsSinceEpoch(
                        orderPendingDispatch.value.endTime!,
                      )
                      .difference(
                        DateTime.fromMillisecondsSinceEpoch(
                          orderPendingDispatch.value.startTime!,
                        ),
                      )
                      .inSeconds,
              travelTime: orderPendingDispatch.value.order?.travelTime,
            ),
          ),
        ]);
      }
    }

    print("[DEBUG PENDING DISPATCH] end");
  }
}
