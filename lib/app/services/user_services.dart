import 'dart:async';

import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/user_info_model.dart';
// import 'package:new_evmoto_driver/app/data/models/working_area_model.dart';
import 'package:new_evmoto_driver/app/repositories/user_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';

class UserServices extends GetxService {
  final userRepository = UserRepository();
  final languageServices = Get.find<LanguageServices>();

  final userInfo = UserInfo().obs;
  // final workingAreaList = <WorkingArea>[].obs;

  final isLoadingRefreshHome = false.obs;

  Future<void> manualOnInit() async {
    await getUserInfo();
    // await Future.wait([getUserInfo(), getWorkingArea()]);
  }

  Future<void> getUserInfo() async {
    userInfo.value = (await userRepository.getUserInfoDetail(
      language: languageServices.languageCodeSystem.value,
    ));
  }

  // Future<void> getWorkingArea() async {
  //   workingAreaList.value = (await userRepository.getWorkingAreaList());
  // }

  void clearUserInfo() {
    userInfo.value = UserInfo();
    // workingAreaList.value = [];
  }
}
