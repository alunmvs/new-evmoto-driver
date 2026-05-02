import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/activity_model.dart';
import 'package:new_evmoto_driver/app/repositories/activity_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class MyActivityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ActivityRepository activityRepository;

  MyActivityController({required this.activityRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  TabController? tabController;
  final indexTabBar = 0.obs;

  final activityList = <Activity>[].obs;
  final pageNum = 1.obs;
  final size = 10.obs;
  final isSeeMoreActivityList = true.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    tabController ??= TabController(length: 2, vsync: this);

    await getActivityList();

    tabController!.addListener(() {
      indexTabBar.value = tabController!.index;
    });
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getActivityList() async {
    pageNum.value = 1;
    isSeeMoreActivityList.value = true;

    activityList.value = await activityRepository.getActivityList(
      language: languageServices.languageCodeSystem.value,
      pageNum: pageNum.value,
      size: size.value,
    );

    if (activityList.isEmpty) {
      isSeeMoreActivityList.value = false;
    }
  }

  Future<void> seeMoreActivityList() async {
    pageNum.value += 1;

    var activityList = await activityRepository.getActivityList(
      language: languageServices.languageCodeSystem.value,
      pageNum: pageNum.value,
      size: size.value,
    );

    this.activityList.addAll(activityList);

    if (activityList.isEmpty) {
      isSeeMoreActivityList.value = false;
    }
  }
}
