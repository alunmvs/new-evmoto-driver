import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/history_guarantee_income/controllers/history_guarantee_income_controller.dart';

class HistoryGuaranteeIncomeDateListSubView
    extends GetView<HistoryGuaranteeIncomeController> {
  const HistoryGuaranteeIncomeDateListSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: 16),
              for (var recommendationDateTime
                  in controller.recommendationDateTimeList.reversed) ...[
                GestureDetector(
                  onTap: () async {
                    if (controller.isFetchDate.value == false) {
                      controller.selectedDateTime.value =
                          recommendationDateTime;
                      await controller.getGuaranteeIncomeApprovalList();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: controller.isDateSelected(recommendationDateTime)
                          ? controller.themeColorServices.primaryBlue.value
                          : Colors.transparent,
                      border: controller.isDateSelected(recommendationDateTime)
                          ? Border.all(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            )
                          : Border.all(color: Color(0XFFDEDEDE)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat(
                            'EEE',
                            'id_ID',
                          ).format(recommendationDateTime),
                          style: controller
                              .typographyServices
                              .captionLargeRegular
                              .value
                              .copyWith(
                                color:
                                    controller.isDateSelected(
                                      recommendationDateTime,
                                    )
                                    ? controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value
                                    : Color(0XFFB3B3B3),
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          recommendationDateTime.day.toString(),
                          style: controller
                              .typographyServices
                              .bodySmallBold
                              .value
                              .copyWith(
                                color:
                                    controller.isDateSelected(
                                      recommendationDateTime,
                                    )
                                    ? controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value
                                    : Color(0XFFB3B3B3),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
