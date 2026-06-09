import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';

import '../controllers/withdraw_controller.dart';

class WithdrawView extends GetView<WithdrawController> {
  const WithdrawView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Tarik Dana",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: Color(0XFFF7F7F7),
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: controller
                                    .themeColorServices
                                    .overlayDark200
                                    .value
                                    .withValues(alpha: 0.05),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  top: 16,
                                  left: 16,
                                  right: 16,
                                  bottom: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0XFF0573EA),
                                      Color(0XFF034184),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Saldo Aktif Saya",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey0
                                                .value,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_wallet.svg",
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          width: 16,
                                          height: 15,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp',
                                            decimalDigits: 0,
                                          ).format(
                                            controller
                                                    .homeController
                                                    .userInfo
                                                    .value
                                                    .balance ??
                                                0.0,
                                          ),
                                          style: controller
                                              .typographyServices
                                              .headingMediumBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        controller.isInfoExpanded.value =
                                            !controller.isInfoExpanded.value;
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        width: 24,
                                        height: 24,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              controller.isInfoExpanded.value
                                                  ? "assets/icons/icon_arrow_up.svg"
                                                  : "assets/icons/icon_arrow_down.svg",
                                              width: 24,
                                              height: 24,
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (controller.isInfoExpanded.value) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF0F0F0),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "* ",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .redColor
                                                      .value,
                                                ),
                                          ),
                                          Text(
                                            "Minimal penarikan ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(controller.firebaseRemoteConfigServices.remoteConfig.getInt("driver_withdraw_min"))}",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFF7D7D7D),
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            "* ",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .redColor
                                                      .value,
                                                ),
                                          ),
                                          Text(
                                            "Biaya admin mengikuti kebijakan bank",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFF7D7D7D),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.HISTORY_BALANCE_WITHDRAW);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Riwayat Tarik Dana",
                                          style: controller
                                              .typographyServices
                                              .bodySmallRegular
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .textColor
                                                    .value,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0XFFF0F0F0),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Color(0XFFE7E7E7)),
                            boxShadow: [
                              BoxShadow(
                                color: controller
                                    .themeColorServices
                                    .overlayDark200
                                    .value
                                    .withValues(alpha: 0.05),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  top: 16,
                                  left: 16,
                                  right: 16,
                                  bottom: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0XFF0573EA),
                                      Color(0XFF034184),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Saldo Aktif Saya",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey0
                                                .value,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/icon_wallet.svg",
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                          width: 16,
                                          height: 15,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: 'Rp',
                                            decimalDigits: 0,
                                          ).format(
                                            controller
                                                    .homeController
                                                    .userInfo
                                                    .value
                                                    .balance ??
                                                0.0,
                                          ),
                                          style: controller
                                              .typographyServices
                                              .headingMediumBold
                                              .value
                                              .copyWith(
                                                color: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        controller.isInfoExpanded.value =
                                            !controller.isInfoExpanded.value;
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        width: 24,
                                        height: 24,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              controller.isInfoExpanded.value
                                                  ? "assets/icons/icon_arrow_up.svg"
                                                  : "assets/icons/icon_arrow_down.svg",
                                              width: 24,
                                              height: 24,
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (controller.isInfoExpanded.value) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF0F0F0),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "* ",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .redColor
                                                      .value,
                                                ),
                                          ),
                                          Text(
                                            "Minimal penarikan ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(controller.firebaseRemoteConfigServices.remoteConfig.getInt("driver_withdraw_min"))}",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFF7D7D7D),
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            "* ",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .redColor
                                                      .value,
                                                ),
                                          ),
                                          Text(
                                            "Biaya admin mengikuti kebijakan bank",
                                            style: controller
                                                .typographyServices
                                                .captionLargeRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFF7D7D7D),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            top: 16,
                            left: 16,
                            right: 16,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0XFF0573EA), Color(0XFF034184)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Saldo Aktif Saya",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_wallet.svg",
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                    width: 16,
                                    height: 15,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller
                                              .homeController
                                              .userInfo
                                              .value
                                              .balance ??
                                          0.0,
                                    ),
                                    style: controller
                                        .typographyServices
                                        .headingMediumBold
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  controller.isInfoExpanded.value =
                                      !controller.isInfoExpanded.value;
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: 24,
                                  height: 24,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        controller.isInfoExpanded.value
                                            ? "assets/icons/icon_arrow_up.svg"
                                            : "assets/icons/icon_arrow_down.svg",
                                        width: 24,
                                        height: 24,
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
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
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () async {
                        await Get.toNamed(
                          Routes.ADD_EDIT_WITHDRAW_BANK_ACCOUNT,
                          arguments: {"is_edit": false},
                        );
                        await controller.getBankAccountList();
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          border: Border.all(color: Color(0XFFD9D9D9)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_add_circle.svg",
                              width: 18,
                              height: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Tambahkan Nomor Rekening Baru",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 0, color: Color(0XFFD9D9D9)),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nomor Rekening Tersimpan",
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
                        ),
                        if (controller.bankAccountList.isNotEmpty) ...[
                          GestureDetector(
                            onTap: () {
                              controller.isEditDeleteActive.value =
                                  !controller.isEditDeleteActive.value;
                            },
                            child: SvgPicture.asset(
                              "assets/icons/icon_three_dots_vertical.svg",
                              width: 22,
                              height: 22,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            if (controller.bankAccountList.isEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16 * 4,
                                ),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/img_history_activity_not_found.svg",
                                      height: 80,
                                      width: 80,
                                    ),
                                    SizedBox(height: 16),
                                    Center(
                                      child: Text(
                                        "Belum Ada Nomor Rekening",
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
                                        "Tambahkan nomor rekening untuk memudahkan kamu dalam aktivitas Tarik Dana.",
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
                              ),
                            ],
                            if (controller.bankAccountList.isNotEmpty) ...[
                              for (var bankAccount
                                  in controller.bankAccountList) ...[
                                GestureDetector(
                                  onTap: () {
                                    if (controller.isEditDeleteActive.value ==
                                        false) {
                                      Get.toNamed(
                                        Routes.WITHDRAW_AMOUNT,
                                        arguments: {
                                          "selected_bank_account": bankAccount,
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                      border: Border.all(
                                        color:
                                            controller.isEditDeleteActive.value
                                            ? Color(0XFFE5E5E5)
                                            : Color(0XFFB3B3B3),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // SizedBox(
                                            //   height: 35,
                                            //   width: 35,
                                            //   child: Placeholder(),
                                            // ),
                                            // SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    bankAccount.name ?? "-",
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallRegular
                                                        .value
                                                        .copyWith(
                                                          color:
                                                              controller
                                                                  .isEditDeleteActive
                                                                  .value
                                                              ? Color(
                                                                  0XFFB3B3B3,
                                                                )
                                                              : controller
                                                                    .themeColorServices
                                                                    .textColor
                                                                    .value,
                                                        ),
                                                  ),
                                                  Text(
                                                    bankAccount.code!.length < 5
                                                        ? "*****"
                                                        : bankAccount.code!
                                                              .replaceRange(
                                                                0,
                                                                5,
                                                                "***** ",
                                                              ),
                                                    style: controller
                                                        .typographyServices
                                                        .bodySmallRegular
                                                        .value
                                                        .copyWith(
                                                          color:
                                                              controller
                                                                  .isEditDeleteActive
                                                                  .value
                                                              ? Color(
                                                                  0XFFB3B3B3,
                                                                )
                                                              : controller
                                                                    .themeColorServices
                                                                    .textColor
                                                                    .value,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            SizedBox(
                                              height: 19,
                                              width: 19,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_arrow_right.svg",
                                                    width: 9.5 * 2.5,
                                                    height: 4.75 * 2.5,
                                                    color:
                                                        controller
                                                            .isEditDeleteActive
                                                            .value
                                                        ? Color(0XFFB3B3B3)
                                                        : controller
                                                              .themeColorServices
                                                              .textColor
                                                              .value,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (controller.isEditDeleteActive.value) ...[
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await Get.toNamed(
                                            Routes
                                                .ADD_EDIT_WITHDRAW_BANK_ACCOUNT,
                                            arguments: {
                                              "is_edit": true,
                                              "bank_account": bankAccount,
                                            },
                                          );
                                          await controller.getBankAccountList();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFEEEEEE),
                                            border: Border.all(
                                              color: Color(0XFFD1D1D1),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Edit",
                                                style: controller
                                                    .typographyServices
                                                    .captionLargeRegular
                                                    .value,
                                              ),
                                              SizedBox(width: 4),
                                              SvgPicture.asset(
                                                "assets/icons/icon_edit.svg",
                                                width: 16,
                                                height: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () async {
                                          await controller
                                              .onTapDeleteBankAccount(
                                                bankAccount: bankAccount,
                                              );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFEEEEEE),
                                            border: Border.all(
                                              color: Color(0XFFD1D1D1),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Hapus",
                                                style: controller
                                                    .typographyServices
                                                    .captionLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .redColor
                                                          .value,
                                                    ),
                                              ),
                                              SizedBox(width: 4),
                                              SvgPicture.asset(
                                                "assets/icons/icon_delete_filled.svg",
                                                width: 16,
                                                height: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                SizedBox(height: 16),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
      ),
    );
  }
}
