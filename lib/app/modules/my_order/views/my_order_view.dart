import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/my_order/views/my_order_view/my_order_all_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/my_order/views/my_order_view/my_order_cancelled_sub_view.dart';
import 'package:new_evmoto_driver/app/modules/my_order/views/my_order_view/my_order_pending_payment_sub_view.dart';

import '../controllers/my_order_controller.dart';

class MyOrderView extends GetView<MyOrderController> {
  const MyOrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Order Saya",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.backgroundColor.value,
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Container(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      child: TabBar(
                        labelColor:
                            controller.themeColorServices.textColor.value,
                        indicatorColor:
                            controller.themeColorServices.primaryBlue.value,
                        unselectedLabelColor:
                            controller.themeColorServices.textColor.value,
                        dividerColor: controller
                            .themeColorServices
                            .neutralsColorGrey200
                            .value,
                        labelStyle:
                            controller.typographyServices.bodySmallBold.value,
                        unselectedLabelStyle:
                            controller.typographyServices.bodySmallBold.value,
                        isScrollable: true,
                        controller: controller.tabController,
                        tabAlignment: TabAlignment.start,
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        tabs: [
                          Tab(
                            child: Text(
                              controller.languageServices.language.value.all ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                            ),
                          ),
                          Tab(
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .toBePaid ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallBold
                                          .value,
                                    ),
                                    if (controller.toBePaidList.isNotEmpty) ...[
                                      SizedBox(width: 10),
                                    ],
                                  ],
                                ),
                                if (controller.toBePaidList.isNotEmpty) ...[
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .redColor
                                            .value,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 5,
                                        minHeight: 5,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Tab(
                            child: Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .cancelOrder ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          MyOrderAllSubView(),
                          MyOrderPendingPaymentSubView(),
                          MyOrderCancelledSubView(),
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
