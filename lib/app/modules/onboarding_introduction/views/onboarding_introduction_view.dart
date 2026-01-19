import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_introduction_controller.dart';

class OnboardingIntroductionView
    extends GetView<OnboardingIntroductionController> {
  const OnboardingIntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            GestureDetector(
              onTap: () async {
                await controller.onTapSkip();
              },
              child: Text(
                "Lewati",
                style: controller.typographyServices.bodySmallRegular.value
                    .copyWith(
                      color: controller.themeColorServices.textColor.value,
                    ),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: controller.isFetch.value
            ? Center(
                child: CircularProgressIndicator(
                  color: controller.themeColorServices.primaryBlue.value,
                ),
              )
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    "assets/images/img_background_onboarding_introduction.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  CarouselSlider(
                    items: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16 * 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AspectRatio(
                                aspectRatio: 343 / 244,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    "assets/images/img_onboarding_introduction_1.png",
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16 * 2),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .onboardingTitle1 ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .headingSmallBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .textColor
                                        .value,
                                  ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .onboardingDescription1 ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(color: Color(0XFF696969)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16 * 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AspectRatio(
                                aspectRatio: 343 / 244,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    "assets/images/img_onboarding_introduction_2.png",
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16 * 2),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .onboardingTitle2 ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .headingSmallBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .textColor
                                        .value,
                                  ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .onboardingDescription2 ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(color: Color(0XFF696969)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16 * 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AspectRatio(
                                aspectRatio: 343 / 244,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    "assets/images/img_onboarding_introduction_3.png",
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16 * 2),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .onboardingTitle3 ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .headingSmallBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .textColor
                                        .value,
                                  ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .onboardingDescription3 ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeRegular
                                  .value
                                  .copyWith(color: Color(0XFF696969)),
                            ),
                          ],
                        ),
                      ),
                    ],
                    carouselController: controller.carouselSliderController,
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        controller.indexBanner.value = index.toDouble();
                      },
                      height: MediaQuery.of(context).size.height,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                      disableCenter: true,
                      viewportFraction: 1,
                      padEnds: false,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12),
                      Center(
                        child: DotsIndicator(
                          dotsCount: 3,
                          position: controller.indexBanner.value,
                          decorator: DotsDecorator(
                            spacing: EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 4,
                            ),
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey300
                                .value,
                            activeColor:
                                controller.themeColorServices.primaryBlue.value,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    ],
                  ),
                ],
              ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 46,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    controller.onTapNext();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.themeColorServices.primaryBlue.value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    controller.languageServices.language.value.buttonNext ??
                        "-",
                    style: controller.typographyServices.bodySmallBold.value
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
