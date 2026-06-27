import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import 'package:new_evmoto_driver/app/widgets/dashed_line.dart';

import '../controllers/order_payment_pending_fee_detail_controller.dart';

class OrderPaymentPendingFeeDetailView
    extends GetView<OrderPaymentPendingFeeDetailController> {
  const OrderPaymentPendingFeeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.paymentDetails ??
                "Detail Pembayaran",
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
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0XFFE1E1E1)),
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          boxShadow: [
                            BoxShadow(
                              color: controller
                                  .themeColorServices
                                  .overlayDark200
                                  .value
                                  .withValues(alpha: 0.15),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDriverSection(context),
                            SizedBox(height: 16),
                            Divider(height: 0, color: Color(0XFFD7D7D7)),
                            SizedBox(height: 16),
                            _buildPassengerSection(context),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDriverSection(BuildContext context) {
    final detail = controller.orderDetail.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Yang didapatkan driver",
          style: controller.typographyServices.bodySmallRegular.value,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          controller.formatCurrency(
            (controller.orderDetail.value.orderMoney ?? 0.0) -
                (controller.orderDetail.value.platformFee ?? 0.0) +
                (controller.orderDetail.value.waitMoney ?? 0.0) +
                (controller.orderDetail.value.additionalCharge ?? 0.0),
          ),
          style: controller.typographyServices.headingLargeBold.value.copyWith(
            color: Color(0XFF34A853),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        _buildSectionDivider(
          controller.languageServices.language.value.expenseDetail ??
              "Expense Detail",
        ),
        SizedBox(height: 16),
        _buildFeeRow(
          label: "Pendapatan driver",
          subLabel:
              "(${controller.driverSharePercentage}% dari total biaya jarak tempuh)",
          value: controller.formatCurrency(detail.netIncome),
        ),
        SizedBox(height: 12),
        _buildFeeRow(
          label:
              controller.languageServices.language.value.surcharge ??
              "Biaya tambahan",
          subLabel: controller.surchargeSubLabel,
          value: controller.formatCurrency(detail.additionalCharge),
        ),
        SizedBox(height: 12),
        _buildFeeRow(
          label:
              controller.languageServices.language.value.waitFee ??
              "Biaya tunggu",
          value: controller.formatCurrency(detail.waitMoney),
        ),
        SizedBox(height: 16),
        DashedLine(color: Color(0XFFD5D5D5)),
        SizedBox(height: 8),
        _buildTotalRow(
          label: "Total pendapatan driver",
          value: controller.formatCurrency(
            (controller.orderDetail.value.orderMoney ?? 0.0) -
                (controller.orderDetail.value.platformFee ?? 0.0) +
                (controller.orderDetail.value.waitMoney ?? 0.0) +
                (controller.orderDetail.value.additionalCharge ?? 0.0),
          ),
          valueStyle: controller.typographyServices.bodySmallBold.value
              .copyWith(color: controller.themeColorServices.textColor.value),
        ),
      ],
    );
  }

  Widget _buildPassengerSection(BuildContext context) {
    final detail = controller.orderDetail.value;
    final startMileage = detail.startMileage ?? 0;
    final mileageKm = detail.driverMileageKilometers ?? detail.mileage ?? 0;
    final totalMileage = detail.mileage ?? 0;
    final couponMoney = detail.couponMoney ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dibayarkan penumpang",
          style: controller.typographyServices.bodySmallBold.value.copyWith(
            color: controller.themeColorServices.textColor.value,
          ),
        ),
        SizedBox(height: 12),
        _buildFeeRow(
          label:
              "Total biaya jarak tempuh (${controller.orderDetail.value.mileage} ${controller.languageServices.language.value.km})",
          value: controller.formatCurrency(
            controller.orderDetail.value.orderMoney ?? 0.0,
          ),
        ),
        SizedBox(height: 12),
        _buildFeeRow(
          label:
              controller.languageServices.language.value.surcharge ??
              "Biaya tambahan",
          subLabel: controller.surchargeSubLabel,
          value: controller.formatCurrency(detail.additionalCharge),
        ),
        SizedBox(height: 12),
        _buildFeeRow(
          label:
              controller.languageServices.language.value.waitFee ??
              "Biaya Tunggu",
          value: controller.formatCurrency(detail.waitMoney),
        ),
        if ((controller.orderDetail.value.couponMoney ?? 0) > 0) ...[
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kupon",
                style: controller.typographyServices.captionLargeRegular.value
                    .copyWith(
                      color: Color(0XFF7D7D7D),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                "-${controller.formatCurrency(couponMoney)}",
                style: controller.typographyServices.captionLargeRegular.value
                    .copyWith(
                      color: Color(0XFFE53935),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Metode Pembayaran",
              style: controller.typographyServices.captionLargeRegular.value
                  .copyWith(
                    color: controller.themeColorServices.thirdTextColor.value,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            _buildPaymentMethodWidget(),
          ],
        ),
        SizedBox(height: 16),
        DashedLine(color: Color(0XFFD5D5D5)),
        SizedBox(height: 16),
        _buildTotalRow(
          label: "Total yang dibayarkan",
          value: controller.formatCurrency(
            (detail.orderMoney ?? 0.0) +
                (detail.additionalCharge ?? 0.0) +
                (detail.waitMoney ?? 0.0) -
                (detail.couponMoney ?? 0.0),
          ),
          valueStyle: controller.typographyServices.bodyLargeBold.value
              .copyWith(color: controller.themeColorServices.textColor.value),
        ),
      ],
    );
  }

  Widget _buildSectionDivider(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 36,
          child: Divider(height: 0, color: Color(0XFFD7D7D7)),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: controller.typographyServices.captionLargeRegular.value
              .copyWith(color: controller.themeColorServices.textColor.value),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Divider(height: 0, color: Color(0XFFD7D7D7)),
        ),
      ],
    );
  }

  Widget _buildFeeRow({
    required String label,
    String? subLabel,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: controller.typographyServices.captionLargeRegular.value
                    .copyWith(
                      color: Color(0XFF7D7D7D),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (subLabel != null) ...[
                SizedBox(height: 4),
                Text(
                  subLabel,
                  style: controller.typographyServices.captionLargeRegular.value
                      .copyWith(color: Color(0XFFB3B3B3)),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: 8),
        Text(
          value,
          style: controller.typographyServices.captionLargeRegular.value
              .copyWith(
                color: controller.themeColorServices.textColor.value,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildTotalRow({
    required String label,
    required String value,
    required TextStyle valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: controller.typographyServices.captionLargeRegular.value
              .copyWith(
                color: controller.themeColorServices.thirdTextColor.value,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(value, style: valueStyle),
      ],
    );
  }

  Widget _buildPaymentMethodWidget() {
    final payType = controller.orderDetail.value.payType;

    if (payType == 4) {
      return Image.asset("assets/icons/icon_gopay_horizontal.png", height: 21);
    }

    if (payType == 3) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/icons/icon_cash.svg", height: 12, width: 20),
          SizedBox(width: 4),
          Text(
            controller.getPaymentMethodName(),
            style: controller.typographyServices.bodySmallRegular.value
                .copyWith(
                  color: controller.themeColorServices.textColor.value,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      );
    }

    return Text(
      controller.getPaymentMethodName(),
      style: controller.typographyServices.captionLargeRegular.value.copyWith(
        color: controller.themeColorServices.textColor.value,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
