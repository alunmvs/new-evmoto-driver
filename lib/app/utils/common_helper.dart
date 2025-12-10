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
