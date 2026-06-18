import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/utils/common_helper.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';
import 'package:slide_countdown/slide_countdown.dart';

class HomeGuaranteeIncomeProgressBarCardFullScreenSubView
    extends GetView<HomeController> {
  const HomeGuaranteeIncomeProgressBarCardFullScreenSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0XFFFFEFC0),
          border: Border.all(color: Color(0XFFEFDFAF), width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "(${controller.startTimeAdjustTz.value} - ${controller.endTimeAdjustTz.value})",
              style: controller.typographyServices.bodyLargeBold.value.copyWith(
                fontWeight: FontWeight.w900,
                color: Color(0XFF6E3500),
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Jaminan Pendapatan Hari Ini",
              style: controller.typographyServices.captionLargeRegular.value
                  .copyWith(color: Color(0XFF624A06)),
            ),
            if (controller.endTimeLocal.value != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0XFF6E3500),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/icons/icon_clock_outlined.svg'),
                    SizedBox(width: 4),
                    SlideCountdown(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(color: Colors.transparent),
                      duration: () {
                        final remaining = controller.endTimeLocal.value!
                            .difference(DateTime.now());
                        return remaining.isNegative ? Duration.zero : remaining;
                      }(),
                      shouldShowMinutes: (duration) => duration.inDays == 0,
                      onDone: () async {
                        controller.updateGuaranteeIncomeProgressBarVisibility();
                        await controller.getEnsureIncomeRuleId();
                        await controller.getGuaranteeIncomeProgressBarList();
                      },
                      style: controller
                          .typographyServices
                          .captionLargeRegular
                          .value
                          .copyWith(
                            color: Color(0XFFFFFFFF),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Jaminan Pendapatan berlaku saat online minimal ',
                style: controller.typographyServices.bodySmallRegular.value
                    .copyWith(color: Color(0XFF624A06)),
                children: <TextSpan>[
                  TextSpan(
                    text: formatDuration(
                      controller
                              .activeGuaranteeIncomeProgressBar
                              .value
                              ?.onLineTime ??
                          0,
                    ),
                    style: controller.typographyServices.bodySmallRegular.value
                        .copyWith(
                          color: Color(0XFF6E3500),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text: ", menerima pesanan, dan tidak melakukan pembatalan.",
                    style: controller.typographyServices.bodySmallRegular.value
                        .copyWith(color: Color(0XFF624A06)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Stack(
              children: [
                SizedBox(
                  height: 25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 11,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: LinearProgressIndicator(
                              value: controller.guaranteeIncomeProgress.value,
                              borderRadius: BorderRadius.circular(9999),
                              minHeight: 11,
                              color: Color(0XFF744F18),
                              backgroundColor: Color(0XFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller
                            .activeGuaranteeIncomeProgressBar
                            .value!
                            .onLineTime !=
                        null &&
                    controller.endTimeLocal.value != null &&
                    controller.startTimeLocal.value != null) ...[
                  Positioned(
                    left:
                        (MediaQuery.of(context).size.width -
                            (16 * 2) -
                            (16 * 2) -
                            (4 * 2)) *
                        (controller
                                .activeGuaranteeIncomeProgressBar
                                .value!
                                .onLineTime! /
                            (controller.endTimeLocal.value!
                                .difference(controller.startTimeLocal.value!)
                                .inMinutes)),
                    child: SizedBox(
                      height: 25,
                      child: Center(
                        child: SizedBox(
                          height: 15,
                          child: VerticalDivider(color: Color(0XFFB3B3B3)),
                        ),
                      ),
                    ),
                  ),
                ],
                Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    (controller
                                        .activeGuaranteeIncomeProgressBar
                                        .value
                                        ?.onlineDurationMinutes ==
                                    null &&
                                controller
                                        .activeGuaranteeIncomeProgressBar
                                        .value
                                        ?.onLineTime ==
                                    null) ||
                            (controller
                                    .activeGuaranteeIncomeProgressBar
                                    .value!
                                    .onlineDurationMinutes! <
                                controller
                                    .activeGuaranteeIncomeProgressBar
                                    .value!
                                    .onLineTime!)
                        ? 'assets/icons/icon_progress_bar_finish_grey.svg'
                        : 'assets/icons/icon_progress_bar_finish_brown.svg',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            LoaderElevatedButton(
              buttonColor: Color(0XFF6E3500),
              onPressed: () async {
                Get.toNamed(Routes.MY_ACTIVITY);
              },
              child: Text(
                "Lihat Detail",
                style: controller.typographyServices.bodyLargeBold.value
                    .copyWith(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                    ),
              ),
            ),
            SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                controller.isActiveGuaranteeIncomeProgressBarOpen.value = false;
              },
              child: Container(
                height: 6 + 12,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(1.0, -1.0),
                      child: SvgPicture.asset(
                        'assets/icons/icon_arrow_down_1.svg',
                        width: 10.42,
                        height: 6,
                        color: Color(0XFF553F00),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
