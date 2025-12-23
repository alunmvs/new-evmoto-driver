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
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
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
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            items: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 100),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 45,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 285 / 160,
                                      child: SizedBox(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        child: Placeholder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 135),
                                  Text(
                                    "Dukungan Operasional untuk Aktivitas Mitra Driver",
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
                                    "Semua layanan dan informasi driver tersedia dalam satu aplikasi!",
                                    style: controller
                                        .typographyServices
                                        .bodyLargeRegular
                                        .value
                                        .copyWith(color: Color(0XFF696969)),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 100),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 45,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 285 / 160,
                                      child: SizedBox(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        child: Placeholder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 135),
                                  Text(
                                    "Solusi Berkendara untuk Mitra Driver",
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
                                    "EV Moto Hadir untuk mendukung mitra driver dalam setiap perjalanan agar tetap lancar dan nyaman.",
                                    style: controller
                                        .typographyServices
                                        .bodyLargeRegular
                                        .value
                                        .copyWith(color: Color(0XFF696969)),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 100),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 45,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 285 / 160,
                                      child: SizedBox(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        child: Placeholder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 135),
                                  Text(
                                    "Temani Perjalanan Kerja Setiap Hari",
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
                                    "Menjadi bagian dari aktivitas kerja mitra driver melalui solusi mobilitas yang sederhana dan mudah.",
                                    style: controller
                                        .typographyServices
                                        .bodyLargeRegular
                                        .value
                                        .copyWith(color: Color(0XFF696969)),
                                  ),
                                ],
                              ),
                            ],
                            carouselController:
                                controller.carouselSliderController,
                            options: CarouselOptions(
                              onPageChanged: (index, reason) {
                                controller.indexBanner.value = index.toDouble();
                              },
                              height: MediaQuery.of(context).size.height / 1.4,
                              enableInfiniteScroll: false,
                              autoPlay: false,
                              disableCenter: true,
                              viewportFraction: 1,
                              padEnds: false,
                            ),
                          ),
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
                                activeColor: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          color: controller.themeColorServices.neutralsColorGrey0.value,
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
                    "Lanjutkan",
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
