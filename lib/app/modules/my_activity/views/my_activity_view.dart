import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/routes/app_pages.dart';
import 'package:new_evmoto_driver/app/widgets/loader_elevated_button_widget.dart';

import '../controllers/my_activity_controller.dart';

class MyActivityView extends GetView<MyActivityController> {
  const MyActivityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.myActivities ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Container(color: Color(0XFFD5D5D5), height: 1.0),
          ),
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
            : Column(
                children: [
                  Container(
                    color: Color(0XFFFFFFFF),
                    child: TabBar(
                      labelColor: controller.themeColorServices.textColor.value,
                      indicatorColor:
                          controller.themeColorServices.primaryBlue.value,
                      unselectedLabelColor:
                          controller.themeColorServices.textColor.value,
                      dividerColor: Colors.transparent,
                      labelStyle:
                          controller.typographyServices.bodySmallBold.value,
                      unselectedLabelStyle: controller
                          .typographyServices
                          .bodySmallBold
                          .value
                          .copyWith(color: Color(0XFFB3B3B3)),
                      isScrollable: true,
                      controller: controller.tabController,
                      tabAlignment: TabAlignment.start,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      onTap: (value) async {},
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Guarantee Income",
                                style: controller
                                    .typographyServices
                                    .bodySmallBold
                                    .value
                                    .copyWith(
                                      color: controller.indexTabBar.value == 0
                                          ? Color(0XFF272727)
                                          : Color(0XFFB3B3B3),
                                    ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.AGREEMENT_GUARANTEE_INCOME,
                                  );
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/icon_question_fill.svg",
                                  color: controller.indexTabBar.value == 0
                                      ? Color(0XFF272727)
                                      : Color(0XFFB3B3B3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Coupon Income",
                                style: controller
                                    .typographyServices
                                    .bodySmallBold
                                    .value
                                    .copyWith(
                                      color: controller.indexTabBar.value == 1
                                          ? Color(0XFF272727)
                                          : Color(0XFFB3B3B3),
                                    ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.AGREEMENT_COUPON_INCOME);
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/icon_question_fill.svg",
                                  color: controller.indexTabBar.value == 1
                                      ? Color(0XFF272727)
                                      : Color(0XFFB3B3B3),
                                ),
                              ),
                            ],
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
                                for (var guaranteeIncome
                                    in controller.activityList) ...[
                                  Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 16),
                                        Text("Aktivitas Guarantee Income"),
                                        RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            text:
                                                guaranteeIncome
                                                    .guaranteeSubsidy
                                                    ?.first
                                                    .content ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  color: Color(0XFFB3B3B3),
                                                ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    " ${guaranteeIncome.guaranteeSubsidy!.first.carryOut ?? "-"}",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          width: 119,
                                          child: LoaderElevatedButton(
                                            buttonColor: Color(0XFF0060C6),
                                            child: Text(
                                              "Lihat Subsidi",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey0
                                                        .value,
                                                  ),
                                            ),
                                            onPressed: () async {},
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 0, color: Color(0XFFD5D5D5)),
                                ],
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
