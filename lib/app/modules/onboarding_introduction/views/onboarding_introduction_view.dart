import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
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
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: controller.isFetch.value
            ? Center(
                child: CircularProgressIndicator(
                  color: controller.themeColorServices.primaryBlue.value,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      items: controller.systemImageList
                          .map(
                            (systemImage) =>
                                CachedNetworkImage(imageUrl: systemImage.url!),
                          )
                          .toList(),

                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          controller.indexBanner.value = index.toDouble();
                        },
                        height: MediaQuery.of(context).size.height / 2,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        disableCenter: true,
                        viewportFraction: 1,
                        aspectRatio: 720 / 1080,
                        padEnds: false,
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: DotsIndicator(
                        dotsCount: controller.systemImageList.length,
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
                    SizedBox(height: 12),
                    SizedBox(
                      height: 46,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              controller.themeColorServices.primaryBlue.value,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: controller
                                  .themeColorServices
                                  .sematicColorBlue200
                                  .value,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          "Enter Now",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
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
