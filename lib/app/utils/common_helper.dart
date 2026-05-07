import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

String formatDouble(double value) {
  if (value == value.toInt()) {
    return value.toInt().toString();
  } else {
    return value
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}

void showLoadingDialog() {
  var themeColorServices = Get.find<ThemeColorServices>();

  Get.dialog(
    PopScope(
      canPop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: SizedBox(
                width: 70,
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: themeColorServices.primaryBlue.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}

DateTime parseToToday(DateTime base, String time) {
  final parts = time.split(":");
  return DateTime(
    base.year,
    base.month,
    base.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

DateTime parseTime(String time) {
  final parts = time.split(":");
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);

  return DateTime(2020, 1, 1, hour, minute);
}

DateTime convertToLocal(String time) {
  // Ambil tanggal hari ini
  final now = DateTime.now();

  // Parse jam & menit
  final parts = time.split(":");
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);

  // Buat DateTime di GMT+7
  // final jakarta = tz.getLocation('Asia/Jakarta');
  final sourceTime = DateTime(now.year, now.month, now.day, hour, minute);

  // // Convert ke local device
  // final localTime = sourceTime.toLocal();

  return sourceTime;
}

String formatTime(DateTime dt) {
  return DateFormat('HH:mm').format(dt);
}

String formatDuration(int totalMinute) {
  int hour = totalMinute ~/ 60;
  int minute = totalMinute % 60;

  if (hour > 0 && minute > 0) {
    return '$hour jam $minute menit';
  } else if (hour > 0) {
    return '$hour jam';
  } else {
    return '$minute menit';
  }
}
