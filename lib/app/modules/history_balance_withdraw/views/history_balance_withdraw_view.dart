import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
                        for (var historyBalanceWithdraw
                            in controller.historyBalanceWithdrawList) ...[
                          Container(
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
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Placeholder(),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Andrew Setia Kawan"),
                                          Text("****** 50373"),
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
                                            symbol: '-Rp',
                                            decimalDigits: 0,
                                          ).format(
                                            historyBalanceWithdraw.money,
                                          ),
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                        ),
                                        Text(
                                          historyBalanceWithdraw.createTime!,
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Divider(height: 0, color: Color(0XFFEEEEEE)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      historyBalanceWithdraw.state.toString(),
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                    ),
                                  ],
                                ),
                              ],
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
