import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../routes/app_pages.dart';
import '../controllers/history_balance_withdraw_controller.dart';

class HistoryBalanceWithdrawView
    extends GetView<HistoryBalanceWithdrawController> {
  const HistoryBalanceWithdrawView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Riwayat Penarikan Dana",
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
            : SmartRefresher(
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
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                  canLoadingIcon: null,
                  loadingIcon: null,
                  idleIcon: null,
                  noMoreIcon: null,
                  failedIcon: null,
                ),
                enablePullDown: true,
                enablePullUp:
                    controller.isSeeMoreHistoryBalanceWithdrawList.value,
                onRefresh: () async {
                  await Future.wait([
                    controller.getHistoryBalanceWithdrawList(),
                  ]);
                  controller.refreshController.refreshCompleted();
                },
                onLoading: () async {
                  await Future.wait([
                    controller.seeMoreHistoryBalanceWithdrawList(),
                  ]);
                  controller.refreshController.loadComplete();
                },
                controller: controller.refreshController,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        if (controller.historyBalanceWithdrawList.isEmpty) ...[
                          Column(
                            children: [
                              SizedBox(height: 16 * 2),
                              SvgPicture.asset(
                                "assets/images/img_history_activity_not_found.svg",
                                height: 80,
                                width: 80,
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: Text(
                                  "Tidak Memiliki Riwayat Penarikan Dana",
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .textColor
                                            .value,
                                      ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: Text(
                                  "Anda belum pernah melakukan penarikan dana.",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value
                                      .copyWith(
                                        color: controller
                                            .themeColorServices
                                            .textColor
                                            .value,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                        for (var historyBalanceWithdraw
                            in controller.historyBalanceWithdrawList) ...[
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.WITHDRAW_DETAIL,
                                arguments: {
                                  "history_balance_withdraw":
                                      historyBalanceWithdraw,
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                                border: Border.all(color: Color(0XFFEEEEEE)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // SizedBox(
                                      //   width: 30,
                                      //   height: 30,
                                      //   child: Placeholder(),
                                      // ),
                                      // SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              historyBalanceWithdraw
                                                      .accountHolderName ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallBold
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFF272727),
                                                  ),
                                            ),
                                            Text(
                                              controller.maskFirst6(
                                                historyBalanceWithdraw
                                                    .accountNumber!,
                                              ),
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallRegular
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFFB3B3B3),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'id_ID',
                                              symbol: '-  Rp',
                                              decimalDigits: 0,
                                            ).format(
                                              historyBalanceWithdraw.money,
                                            ),
                                            style: controller
                                                .typographyServices
                                                .bodySmallBold
                                                .value
                                                .copyWith(
                                                  color: Color(0XFFE11C0B),
                                                ),
                                          ),
                                          Text(
                                            historyBalanceWithdraw.createTime!,
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFFB3B3B3),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Divider(height: 0, color: Color(0XFFEEEEEE)),
                                  SizedBox(height: 8),
                                  if (historyBalanceWithdraw.state == 1) ...[
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_withdraw_in_progress.svg",
                                                width: 11.67,
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Masih dalam proses admin",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: Color(0XFFB3B3B3),
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (historyBalanceWithdraw.state == 2) ...[
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_withdraw_success.svg",
                                                width: 18,
                                                height: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Dana telah berhasil ditarik",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: Color(0XFF34A853),
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (historyBalanceWithdraw.state == 3) ...[
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_withdraw_rejected.svg",
                                                width: 18,
                                                height: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Penarikan dana gagal",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: Color(0XFFE11C0B),
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          if (historyBalanceWithdraw !=
                              controller.historyBalanceWithdrawList.last) ...[
                            Divider(height: 0),
                            SizedBox(height: 16),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
