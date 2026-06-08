import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/modules/order_detail/controllers/order_detail_controller.dart';

class OrderDetailFooterSubView extends GetView<OrderDetailController> {
  const OrderDetailFooterSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await controller.onTapOpenGoogleMaps();
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          border: Border.all(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey300
                                .value,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_navigation.svg",
                              width: 21.15,
                              height: 21.15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        await controller.updateCameraAutoFocus();
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          border: Border.all(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey300
                                .value,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_gps.svg",
                              width: 21.15,
                              height: 21.15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await controller.onTapCallEmergency();
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey0
                              .value,
                          border: Border.all(color: Color(0XFFFB958C)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/icon_emergency.png",
                              width: 17,
                              height: 17,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: controller.themeColorServices.neutralsColorGrey0.value,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (controller.orderDetail.value.state == 1) ...[
                  ActionSlider.custom(
                    height: 60,
                    action: (actionController) async {
                      actionController.loading();
                      await controller.updateStateGrabOrder();
                      actionController.success();
                      actionController.reset();
                    },
                    toggleMargin: EdgeInsetsGeometry.all(0),
                    outerBackgroundBuilder: (context, state, child) {
                      return Container(color: Colors.transparent);
                    },
                    foregroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(8.0),
                        child: state.status == SliderStatus.loading()
                            ? CircleAvatar(
                                backgroundColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                child: Center(
                                  child: SizedBox(
                                    width: 24.5,
                                    height: 24.5,
                                    child: CircularProgressIndicator(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: state.position >= 0.5
                                    ? Color(0XFF2579D4)
                                    : controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_arrow_slide_right.svg",
                                    width: 24.5,
                                    height: 24.5,
                                  ),
                                ),
                              ),
                      );
                    },
                    backgroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 60,
                        decoration: BoxDecoration(
                          color: state.position >= 0.5
                              ? Color(0XFF2F8AEC)
                              : Color(0XFFF1F1F1),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: state.position >= 0.5
                                ? Color(0XFF0060C6)
                                : controller
                                      .themeColorServices
                                      .neutralsColorGrey300
                                      .value,
                            width: state.position >= 0.5 ? 5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              state.position >= 0.5
                                  ? "Orderan sudah diambil"
                                  : "Swipe untuk mulai orderan",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: state.position >= 0.5
                                        ? Colors.white
                                        : controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                if (controller.orderDetail.value.state == 2) ...[
                  ActionSlider.custom(
                    height: 60,
                    action: (actionController) async {
                      actionController.loading();
                      await controller.updateStateStartOrderTrip();
                      actionController.success();
                      actionController.reset();
                    },
                    toggleMargin: EdgeInsetsGeometry.all(0),
                    outerBackgroundBuilder: (context, state, child) {
                      return Container(color: Colors.transparent);
                    },
                    foregroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(8.0),
                        child: state.status == SliderStatus.loading()
                            ? CircleAvatar(
                                backgroundColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                child: Center(
                                  child: SizedBox(
                                    width: 24.5,
                                    height: 24.5,
                                    child: CircularProgressIndicator(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: state.position >= 0.5
                                    ? Color(0XFF2579D4)
                                    : controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_arrow_slide_right.svg",
                                    width: 24.5,
                                    height: 24.5,
                                  ),
                                ),
                              ),
                      );
                    },
                    backgroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 60,
                        decoration: BoxDecoration(
                          color: state.position >= 0.5
                              ? Color(0XFF2F8AEC)
                              : Color(0XFFF1F1F1),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: state.position >= 0.5
                                ? Color(0XFF0060C6)
                                : controller
                                      .themeColorServices
                                      .neutralsColorGrey300
                                      .value,
                            width: state.position >= 0.5 ? 5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              state.position >= 0.5
                                  ? controller
                                            .languageServices
                                            .language
                                            .value
                                            .pickingUp ??
                                        "-"
                                  : controller
                                            .languageServices
                                            .language
                                            .value
                                            .departToPickup ??
                                        "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: state.position >= 0.5
                                        ? Colors.white
                                        : controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                if (controller.orderDetail.value.state == 3) ...[
                  ActionSlider.custom(
                    height: 60,
                    action: (actionController) async {
                      actionController.loading();
                      await controller.updateStateArrivedOrigin();
                      actionController.success();
                      actionController.reset();
                    },
                    toggleMargin: EdgeInsetsGeometry.all(0),
                    outerBackgroundBuilder: (context, state, child) {
                      return Container(color: Colors.transparent);
                    },
                    foregroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(8.0),
                        child: state.status == SliderStatus.loading()
                            ? CircleAvatar(
                                backgroundColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                child: Center(
                                  child: SizedBox(
                                    width: 24.5,
                                    height: 24.5,
                                    child: CircularProgressIndicator(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: state.position >= 0.5
                                    ? Color(0XFF2579D4)
                                    : controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_arrow_slide_right.svg",
                                    width: 24.5,
                                    height: 24.5,
                                  ),
                                ),
                              ),
                      );
                    },
                    backgroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 60,
                        decoration: BoxDecoration(
                          color: state.position >= 0.5
                              ? Color(0XFF2F8AEC)
                              : Color(0XFFF1F1F1),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: state.position >= 0.5
                                ? Color(0XFF0060C6)
                                : controller
                                      .themeColorServices
                                      .neutralsColorGrey300
                                      .value,
                            width: state.position >= 0.5 ? 5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              state.position >= 0.5
                                  ? controller
                                            .languageServices
                                            .language
                                            .value
                                            .arriveAtThePickUpLocation ??
                                        "-"
                                  : controller
                                            .languageServices
                                            .language
                                            .value
                                            .arriveAtThePickUpLocation ??
                                        "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: state.position >= 0.5
                                        ? Colors.white
                                        : controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                if (controller.orderDetail.value.state == 4) ...[
                  ActionSlider.custom(
                    height: 60,
                    action: (actionController) async {
                      actionController.loading();
                      await controller.updateStateOnProgress();
                      actionController.success();
                      actionController.reset();
                    },
                    toggleMargin: EdgeInsetsGeometry.all(0),
                    outerBackgroundBuilder: (context, state, child) {
                      return Container(color: Colors.transparent);
                    },
                    foregroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(8.0),
                        child: state.status == SliderStatus.loading()
                            ? CircleAvatar(
                                backgroundColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                child: Center(
                                  child: SizedBox(
                                    width: 24.5,
                                    height: 24.5,
                                    child: CircularProgressIndicator(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: state.position >= 0.5
                                    ? Color(0XFF2579D4)
                                    : controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_arrow_slide_right.svg",
                                    width: 24.5,
                                    height: 24.5,
                                  ),
                                ),
                              ),
                      );
                    },
                    backgroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 60,
                        decoration: BoxDecoration(
                          color: state.position >= 0.5
                              ? Color(0XFF2F8AEC)
                              : Color(0XFFF1F1F1),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: state.position >= 0.5
                                ? Color(0XFF0060C6)
                                : controller
                                      .themeColorServices
                                      .neutralsColorGrey300
                                      .value,
                            width: state.position >= 0.5 ? 5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              state.position >= 0.5
                                  ? controller
                                            .languageServices
                                            .language
                                            .value
                                            .delivering ??
                                        "-"
                                  : controller
                                            .languageServices
                                            .language
                                            .value
                                            .deliveringPassengers ??
                                        "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: state.position >= 0.5
                                        ? Colors.white
                                        : controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                if (controller.orderDetail.value.state == 5) ...[
                  ActionSlider.custom(
                    height: 60,
                    action: (actionController) async {
                      actionController.loading();
                      await controller.updateStateArrivedAtDestination();
                      actionController.success();
                      actionController.reset();
                    },
                    toggleMargin: EdgeInsetsGeometry.all(0),
                    outerBackgroundBuilder: (context, state, child) {
                      return Container(color: Colors.transparent);
                    },
                    foregroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(8.0),
                        child: state.status == SliderStatus.loading()
                            ? CircleAvatar(
                                backgroundColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                child: Center(
                                  child: SizedBox(
                                    width: 24.5,
                                    height: 24.5,
                                    child: CircularProgressIndicator(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey0
                                          .value,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: state.position >= 0.5
                                    ? Color(0XFF2579D4)
                                    : controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/icon_arrow_slide_right.svg",
                                    width: 24.5,
                                    height: 24.5,
                                  ),
                                ),
                              ),
                      );
                    },
                    backgroundBuilder: (context, state, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 60,
                        decoration: BoxDecoration(
                          color: state.position >= 0.5
                              ? Color(0XFF2F8AEC)
                              : Color(0XFFF1F1F1),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: state.position >= 0.5
                                ? Color(0XFF0060C6)
                                : controller
                                      .themeColorServices
                                      .neutralsColorGrey300
                                      .value,
                            width: state.position >= 0.5 ? 5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              state.position >= 0.5
                                  ? controller
                                            .languageServices
                                            .language
                                            .value
                                            .finishedDroppingOffPassenger ??
                                        "-"
                                  : controller
                                            .languageServices
                                            .language
                                            .value
                                            .finishedDroppingOffPassenger ??
                                        "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(
                                    color: state.position >= 0.5
                                        ? Colors.white
                                        : controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                if ([
                  1,
                  2,
                  3,
                  4,
                ].contains(controller.orderDetail.value.state)) ...[
                  SizedBox(height: 16),
                  SizedBox(
                    height: 46,
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0XFFE54C3F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        await controller.onTapCancelOrder();
                      },
                      child: Text(
                        controller.languageServices.language.value.cancel ??
                            "-",
                        style: controller.typographyServices.bodyLargeBold.value
                            .copyWith(color: Color(0XFFE54C3F)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
