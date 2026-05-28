import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/socket_order_status_data_model.dart';

import '../controllers/my_order_v2_controller.dart';

class MyOrderV2View extends GetView<MyOrderV2Controller> {
  const MyOrderV2View({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Saya",
          style: controller.typographyServices.bodyLargeBold.value,
        ),
        centerTitle: false,
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
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
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    child: TabBar(
                      labelColor: controller.themeColorServices.textColor.value,
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
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
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
                          child: Text(
                            "Reguler",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value,
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Booking",
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
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Text(
                                  "Total Orderan : 6",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value,
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0XFFE8E8E8),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0XFF0573EA),
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                            ),
                                            child: Text(
                                              "Reguler",
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeBold
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey0
                                                        .value,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                              border: Border.all(
                                                color: Color(0XFF0573EA),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                            ),
                                            child: Text(
                                              "Dalam Layanan",
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFF0573EA),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Lokasi Tujuan",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value
                                            .copyWith(color: Color(0XFFB3B3B3)),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Jl. Bumi No.10, Gunung, Kebayoran Baru, Ja...",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () async {
                                    await controller
                                        .showDialogAdvancedBookingConfirmation(
                                          socketOrderStatusData:
                                              SocketOrderStatusData(),
                                        );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0XFFE8E8E8),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0XFFEA7405),
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                              ),
                                              child: Text(
                                                "Booking",
                                                style: controller
                                                    .typographyServices
                                                    .captionLargeBold
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey0
                                                          .value,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                                border: Border.all(
                                                  color: Color(0XFFEA7405),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                              ),
                                              child: Text(
                                                "Sedang Menunggu",
                                                style: controller
                                                    .typographyServices
                                                    .captionLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: Color(0XFFEA7405),
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Tanggal dan Waktu",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: Color(0XFFB3B3B3),
                                              ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Kamis, 21 Mei 2026 · 10:05 .",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Dijemput",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: Color(0XFFB3B3B3),
                                              ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Jl. Wijaya I No.67, RT.6/RW.4, Petogogan...",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(),
                        Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
