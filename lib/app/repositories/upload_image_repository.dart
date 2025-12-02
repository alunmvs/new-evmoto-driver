import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_driver/main.dart';

class UploadImageRepository {
  Future<String> uploadImage({required XFile file}) async {
    try {
      var url = "$baseUrl/account/base/driver/img/upload";

      var formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: file.name),
      });

      var dio = Dio();
      var response = await dio.post(url, data: formData);

      print(response.data);

      return response.data["url"];
    } on DioException catch (e) {
      rethrow;
    }
  }
}
