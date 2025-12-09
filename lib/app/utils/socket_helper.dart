import 'dart:convert';

Map<String, dynamic> convertBytesToJson({required List<int> bytes}) {
  int payloadLength =
      (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];
  List<int> payloadBytes = bytes.sublist(4, 4 + payloadLength);
  String jsonString = utf8.decode(payloadBytes);
  Map<String, dynamic> jsonData = jsonDecode(jsonString);
  return jsonData;
}
