import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/modules/my_activity/controllers/my_activity_controller.dart';
import 'package:new_evmoto_driver/app/modules/my_activity/views/my_activity_view/my_activity_referral_program_income_summary_chart_sub_view.dart';

class MyActivityReferralProgramSubView extends GetView<MyActivityController> {
  const MyActivityReferralProgramSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Estimasi Total Pendapatan",
                  style: controller.typographyServices.bodySmallBold.value,
                ),
                GestureDetector(
                  onTap: () async {
                    await controller.onTapSelectDateRangeReferralProgram(
                      context: context,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      border: Border.all(color: Color(0XFFEEEEEE)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/icon_calendar_date.svg'),
                        SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMMM yyyy').format(
                            controller
                                .referralProgramSelectedDateRange
                                .value!
                                .start,
                          ),
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Rp2.250.000",
                  style: controller.typographyServices.headingMediumBold.value
                      .copyWith(fontSize: 28),
                ),
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0XFF47A056),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_referral_program_arrow_up.svg",
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "12% dari bulan lalu",
                        style: controller
                            .typographyServices
                            .captionLargeRegular
                            .value
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0XFFFBFBFB),
                      border: Border.all(color: Color(0XFFE1ECFA)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Referral",
                          style: controller
                              .typographyServices
                              .captionSmallBold
                              .value
                              .copyWith(color: Color(0XFFB3B3B3)),
                        ),
                        Text(
                          "67 Users",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(color: Color(0XFF272727)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0XFFFBFBFB),
                      border: Border.all(color: Color(0XFFE1ECFA)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Per Register",
                          style: controller
                              .typographyServices
                              .captionSmallBold
                              .value
                              .copyWith(color: Color(0XFFB3B3B3)),
                        ),
                        Text(
                          "Rp15.000",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(color: Color(0XFF272727)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 + 8),
            const MyActivityReferralProgramIncomeSummaryChartSubView(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
