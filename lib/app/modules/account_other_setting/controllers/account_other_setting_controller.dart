import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';
import 'package:new_evmoto_driver/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountOtherSettingController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final packageVersion = "".obs;
  final cacheSizeInBytes = 0.obs;

  final isFetch = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isFetch.value = true;
    await Future.wait([getPackageInfo(), getCacheSizeInBytes()]);
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

  Future<void> getPackageInfo() async {
    var packageInfo = await PackageInfo.fromPlatform();
    packageVersion.value = packageInfo.version;
  }

  Future<void> getCacheSizeInBytes() async {
    var dir = await getTemporaryDirectory();

    var size = 0;

    if (dir.existsSync()) {
      for (var entity in dir.listSync(recursive: true)) {
        if (entity is File) {
          size += entity.lengthSync();
        }
      }
    }

    cacheSizeInBytes.value = size;
  }

  String getStringSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(0)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    } else {
      final gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(2)} GB';
    }
  }

  Future<void> onTapCleanCache() async {
    await DefaultCacheManager().emptyCache();

    var tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      for (var entity in tempDir.listSync()) {
        try {
          entity.deleteSync(recursive: true);
        } catch (e) {}
      }
    }

    await getCacheSizeInBytes();

    var snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: themeColorServices.sematicColorGreen400.value,
      content: Text(
        "Berhasil membersihkan cache",
        style: typographyServices.bodySmallRegular.value.copyWith(
          color: themeColorServices.neutralsColorGrey0.value,
        ),
      ),
    );
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  Future<void> onTapUpdateVersion() async {
    var url = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.evmoto.driver.app",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Unable launch url update app version';
    }
  }
}
