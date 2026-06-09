import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/controllers/history_guarantee_income_controller.dart';

class HistoryGuaranteeIncomeCardSummarySubView
    extends GetView<HistoryGuaranteeIncomeController> {
  final bool? enableBorder;
  const HistoryGuaranteeIncomeCardSummarySubView({
    super.key,
    this.enableBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: controller.themeColorServices.neutralsColorGrey0.value,
        borderRadius: BorderRadius.circular(12),
        border: enableBorder == true
            ? Border.all(color: Color(0XFFE5E5E5))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0XFF34A853),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Dibayarkan",
                  style: controller.typographyServices.captionLargeRegular.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                      ),
                ),
              ),
              Text(
                "*Per jam Rp20.000",
                style: controller.typographyServices.captionLargeRegular.value
                    .copyWith(color: Color(0XFF7D7D7D)),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "(09:00 - 10:00)",
            style: controller.typographyServices.bodySmallBold.value.copyWith(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Yang di dapatkan:",
                style: controller.typographyServices.bodySmallRegular.value
                    .copyWith(),
              ),
              Text(
                "Rp10.000",
                style: controller.typographyServices.headingSmallBold.value
                    .copyWith(color: Color(0XFF34A853)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
