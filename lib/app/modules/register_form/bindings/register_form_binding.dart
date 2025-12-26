import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/repositories/register_repository.dart';
import 'package:new_evmoto_driver/app/repositories/upload_image_repository.dart';

import '../controllers/register_form_controller.dart';

class RegisterFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterFormController>(
      () => RegisterFormController(
        uploadImageRepository: UploadImageRepository(),
        registerRepository: RegisterRepository(),
      ),
    );
  }
}
