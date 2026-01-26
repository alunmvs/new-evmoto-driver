import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/order_model.dart';
import 'package:new_evmoto_driver/app/repositories/order_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/utils/error_helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final OrderRepository orderRepository;

  ActivityController({required this.orderRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  TabController? tabController;

  final allOrderRefreshController = RefreshController();
  final allOrderList = <Order>[].obs;
  final allOrderPageNum = 1.obs;
  final isSeeMoreAllOrder = true.obs;

  final toBePaidRefreshController = RefreshController();
  final toBePaidList = <Order>[].obs;
  final toBePaidPageNum = 1.obs;
  final isSeeMoreToBePaid = true.obs;

  final cancelOrderRefreshController = RefreshController();
  final cancelOrderList = <Order>[].obs;
  final cancelOrderPageNum = 1.obs;
  final isSeeMoreCancelOrder = true.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController ??= TabController(length: 3, vsync: this);
    try {
      await refreshAll();
      isFetch.value = false;
    } catch (e) {
      await showNoConnectivityInternetDialog(
        onRetry: () async {
          await onInit();
        },
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshAll() async {
    await Future.wait([
      getAllOrderList(),
      getToBePaidList(),
      getCancelOrderList(),
    ]);
  }

  Future<void> getAllOrderList() async {
    isSeeMoreAllOrder.value = true;
    allOrderPageNum.value = 1;

    allOrderList.value = (await orderRepository.getHistoryOrderList(
      size: 10,
      language: 2,
      state: 1,
      pageNum: allOrderPageNum.value,
    ));

    if (allOrderList.isEmpty) {
      isSeeMoreAllOrder.value = false;
    }
  }

  Future<void> seeMoreAllOrderList() async {
    if (isSeeMoreAllOrder.value == true) {
      allOrderPageNum.value += 1;

      var allOrderList = (await orderRepository.getHistoryOrderList(
        size: 10,
        language: 2,
        state: 1,
        pageNum: allOrderPageNum.value,
      ));

      this.allOrderList.addAll(allOrderList);

      if (allOrderList.isEmpty) {
        isSeeMoreAllOrder.value = false;
      }
    }
  }

  Future<void> getToBePaidList() async {
    isSeeMoreToBePaid.value = true;
    toBePaidPageNum.value = 1;

    toBePaidList.value = (await orderRepository.getHistoryOrderList(
      size: 10,
      language: 2,
      state: 2,
      pageNum: toBePaidPageNum.value,
    ));

    if (toBePaidList.isEmpty) {
      isSeeMoreToBePaid.value = false;
    }
  }

  Future<void> seeMoreToBePaidList() async {
    if (isSeeMoreToBePaid.value == true) {
      toBePaidPageNum.value += 1;

      var toBePaidList = (await orderRepository.getHistoryOrderList(
        size: 10,
        language: 2,
        state: 2,
        pageNum: toBePaidPageNum.value,
      ));

      this.toBePaidList.addAll(toBePaidList);

      if (toBePaidList.isEmpty) {
        isSeeMoreToBePaid.value = false;
      }
    }
  }

  Future<void> getCancelOrderList() async {
    isSeeMoreCancelOrder.value = true;
    cancelOrderPageNum.value = 1;

    cancelOrderList.value = (await orderRepository.getHistoryOrderList(
      size: 10,
      language: 2,
      state: 3,
      pageNum: cancelOrderPageNum.value,
    ));

    if (cancelOrderList.isEmpty) {
      isSeeMoreCancelOrder.value = false;
    }
  }

  Future<void> seeMoreCancelOrderList() async {
    if (isSeeMoreCancelOrder.value == true) {
      cancelOrderPageNum.value += 1;

      var cancelOrderList = (await orderRepository.getHistoryOrderList(
        size: 10,
        language: 2,
        state: 3,
        pageNum: cancelOrderPageNum.value,
      ));

      this.cancelOrderList.addAll(cancelOrderList);

      if (cancelOrderList.isEmpty) {
        isSeeMoreCancelOrder.value = false;
      }
    }
  }
}
