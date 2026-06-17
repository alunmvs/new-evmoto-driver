import 'package:intl/intl.dart';
import 'package:new_evmoto_driver/app/utils/dialog_helper.dart';
import 'package:new_evmoto_driver/app/utils/dialog_tags.dart';

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
  DialogHelper.showLoading(tag: DialogTags.loading);
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
