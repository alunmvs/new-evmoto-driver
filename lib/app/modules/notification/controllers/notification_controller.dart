import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/notification_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/app/data/models/notification_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class NotificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final NotificationRepository notificationRepository;

  NotificationController({required this.notificationRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  TabController? tabController;

  final systemNotificationRefreshController = RefreshController();
  final systemNotificationList = <Notification>[].obs;
  final systemNotificationPageNum = 1.obs;
  final systemNotificationSize = 10.obs;
  final isSeeMoreSystemNotification = true.obs;

  final platformAnnoucementRefreshController = RefreshController();
  final platformAnnoucementList = <Notification>[].obs;
  final platformAnnoucementPageNum = 1.obs;
  final platformAnnoucementSize = 10.obs;
  final isSeeMorePlatformAnnoucement = true.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController ??= TabController(length: 2, vsync: this);
    await Future.wait([
      getSystemNotificationList(),
      getPlatformAnnoucementList(),
    ]);
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getSystemNotificationList() async {
    isSeeMoreSystemNotification.value = true;
    systemNotificationPageNum.value = 1;

    systemNotificationList.value = await notificationRepository
        .getNotificationList(
          type: 2,
          pageNum: systemNotificationPageNum.value,
          size: systemNotificationSize.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (systemNotificationList.isEmpty) {
      isSeeMoreSystemNotification.value = false;
    }
  }

  Future<void> seeMoreSystemNotificationList() async {
    systemNotificationPageNum.value += 1;

    var systemNotificationList = await notificationRepository
        .getNotificationList(
          type: 2,
          pageNum: systemNotificationPageNum.value,
          size: systemNotificationSize.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (systemNotificationList.isEmpty) {
      isSeeMoreSystemNotification.value = false;
    } else {
      this.systemNotificationList.value = systemNotificationList;
    }
  }

  Future<void> getPlatformAnnoucementList() async {
    isSeeMorePlatformAnnoucement.value = true;
    platformAnnoucementPageNum.value = 1;

    platformAnnoucementList.value = await notificationRepository
        .getNotificationList(
          type: 1,
          pageNum: platformAnnoucementPageNum.value,
          size: platformAnnoucementSize.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (platformAnnoucementList.isEmpty) {
      isSeeMorePlatformAnnoucement.value = false;
    }
  }

  Future<void> seeMorePlatformAnnoucementList() async {
    platformAnnoucementPageNum.value += 1;

    var platformAnnoucementList = await notificationRepository
        .getNotificationList(
          type: 2,
          pageNum: platformAnnoucementPageNum.value,
          size: platformAnnoucementSize.value,
          language: languageServices.languageCodeSystem.value,
        );

    if (platformAnnoucementList.isEmpty) {
      isSeeMorePlatformAnnoucement.value = false;
    } else {
      this.platformAnnoucementList.value = platformAnnoucementList;
    }
  }
}
