import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/account_my_evaluation_controller.dart';

class AccountMyEvaluationView extends GetView<AccountMyEvaluationController> {
  const AccountMyEvaluationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.myEvaluation ?? "-",
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      addAutomaticKeepAlives: true,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 78 / 68,
                        crossAxisCount: 4,
                      ),
                      itemBuilder: (context, index) {
                        return Obx(
                          () => GestureDetector(
                            onTap: () {
                              if (controller.selectedIndex.value == index) {
                                controller.selectedIndex.value = 999;
                              } else {
                                controller.selectedIndex.value = index;
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: controller.selectedIndex.value == index
                                    ? Color(0XFFE9E9E9)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Color(0XFFE2E2E2)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.getRatingByIndex(index: index),
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value,
                                  ),
                                  RatingBar.builder(
                                    initialRating: double.parse(
                                      controller.getRatingByIndex(index: index),
                                    ),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 9,
                                    itemPadding: EdgeInsets.only(left: 1),
                                    unratedColor: Color(0XFFB3B3B3),
                                    itemBuilder: (context, _) => SizedBox(
                                      width: 11,
                                      height: 12,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/icon_star.svg",
                                            width: 9.17,
                                            height: 10,
                                            color: controller
                                                .themeColorServices
                                                .sematicColorYellow400
                                                .value,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onRatingUpdate: (rating) {},
                                    glow: false,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "(${controller.getTotalRatingByIndex(index: index)})",
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(height: 0, color: Color(0XFFD5D5D5)),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "${controller.languageServices.language.value.overallRating} (${controller.getTotalRatingByIndex(index: controller.selectedIndex.value)})",
                      style: controller.typographyServices.bodyLargeBold.value,
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            if (controller
                                .getRatingAndReviewListByIndex(
                                  index: controller.selectedIndex.value,
                                )
                                .isEmpty) ...[
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 16 * 3),
                                    SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Placeholder(),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .evaluationNotFoundTitle ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodyLargeBold
                                          .value,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      controller
                                              .languageServices
                                              .language
                                              .value
                                              .evaluationNotFoundDescription ??
                                          "-",
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            for (var ratingAndReviewData
                                in controller.getRatingAndReviewListByIndex(
                                  index: controller.selectedIndex.value,
                                )) ...[
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ratingAndReviewData.customerName ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodySmallBold
                                                .value
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: controller
                                                      .themeColorServices
                                                      .textColor
                                                      .value,
                                                ),
                                          ),
                                          Text(
                                            ratingAndReviewData.time!,
                                            style: controller
                                                .typographyServices
                                                .bodySmallRegular
                                                .value
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0XFF696969),
                                                ),
                                          ),
                                        ],
                                      ),
                                      RatingBar.builder(
                                        initialRating:
                                            ratingAndReviewData.fraction!,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 12,
                                        itemPadding: EdgeInsets.only(left: 4),
                                        unratedColor: controller
                                            .themeColorServices
                                            .neutralsColorSlate100
                                            .value,

                                        itemBuilder: (context, _) => SizedBox(
                                          width: 11,
                                          height: 12,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_star.svg",
                                                width: 9.17,
                                                height: 10,
                                                color: controller
                                                    .themeColorServices
                                                    .sematicColorYellow400
                                                    .value,
                                              ),
                                            ],
                                          ),
                                        ),
                                        onRatingUpdate: (rating) {},
                                        glow: false,
                                      ),
                                    ],
                                  ),
                                  if (ratingAndReviewData.content != null &&
                                      ratingAndReviewData.content != "") ...[
                                    SizedBox(height: 4),
                                    Text(
                                      ratingAndReviewData.content!,
                                      style: controller
                                          .typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(color: Color(0XFFB3B3B3)),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 16),
                              Divider(height: 0, color: Color(0XFFD5D5D5)),
                              SizedBox(height: 16),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
