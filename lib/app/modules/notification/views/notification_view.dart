import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/notification/views/notification_view/notification_card_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/notification/views/notification_view/notification_not_found_sub_view.dart';
import 'package:new_evmoto_driver/app/widgets/global_body_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Notifikasi",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.backgroundColor.value,
        body: GlobalBodyHandler(
          isFetch: controller.isFetch.value,
          isCriticalError: false,
          onInit: () {},
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 1, color: Color(0XFFD5D5D5), thickness: 0),
              Container(
                color: controller.themeColorServices.neutralsColorGrey0.value,
                child: TabBar(
                  controller: controller.tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor:
                      controller.themeColorServices.primaryBlue.value,
                  labelColor: controller.themeColorServices.textColor.value,
                  labelStyle:
                      controller.typographyServices.bodyLargeRegular.value,
                  unselectedLabelStyle: controller
                      .typographyServices
                      .bodyLargeRegular
                      .value
                      .copyWith(color: Color(0XFFB3B3B3)),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: "Informasi Sistem"),
                    Tab(text: "Pengumuman"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    SmartRefresher(
                      header: MaterialClassicHeader(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                      footer: ClassicFooter(
                        loadStyle: LoadStyle.HideAlways,
                        textStyle: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                        canLoadingIcon: null,
                        loadingIcon: null,
                        idleIcon: null,
                        noMoreIcon: null,
                        failedIcon: null,
                      ),
                      enablePullDown: true,
                      enablePullUp:
                          controller.isSeeMoreSystemNotification.value,
                      onRefresh: () async {
                        await Future.wait([
                          controller.getSystemNotificationList(),
                        ]);
                        controller.systemNotificationRefreshController
                            .refreshCompleted();
                      },
                      onLoading: () async {
                        await Future.wait([
                          controller.seeMoreSystemNotificationList(),
                        ]);
                        controller.systemNotificationRefreshController
                            .loadComplete();
                      },
                      controller:
                          controller.systemNotificationRefreshController,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.systemNotificationList.isEmpty) ...[
                              NotificationNotFoundSubView(),
                            ],
                            for (var systemNotification
                                in controller.systemNotificationList) ...[
                              NotificationCardSubView(
                                notification: systemNotification,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  height: 0,
                                  color: Color(0XFFD5D5D5),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SmartRefresher(
                      header: MaterialClassicHeader(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                      footer: ClassicFooter(
                        loadStyle: LoadStyle.HideAlways,
                        textStyle: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                        canLoadingIcon: null,
                        loadingIcon: null,
                        idleIcon: null,
                        noMoreIcon: null,
                        failedIcon: null,
                      ),
                      enablePullDown: true,
                      enablePullUp:
                          controller.isSeeMorePlatformAnnoucement.value,
                      onRefresh: () async {
                        await Future.wait([
                          controller.getPlatformAnnoucementList(),
                        ]);
                        controller.platformAnnoucementRefreshController
                            .refreshCompleted();
                      },
                      onLoading: () async {
                        await Future.wait([
                          controller.seeMorePlatformAnnoucementList(),
                        ]);
                        controller.platformAnnoucementRefreshController
                            .loadComplete();
                      },
                      controller:
                          controller.platformAnnoucementRefreshController,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.platformAnnoucementList.isEmpty) ...[
                              NotificationNotFoundSubView(),
                            ],
                            for (var platformAnnoucement
                                in controller.platformAnnoucementList) ...[
                              NotificationCardSubView(
                                notification: platformAnnoucement,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  height: 0,
                                  color: Color(0XFFD5D5D5),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
