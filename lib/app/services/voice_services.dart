import 'package:get/get.dart';
import 'package:new_evmoto_driver/app/data/models/voice_model.dart';
import 'package:new_evmoto_driver/app/repositories/voice_repository.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';

class VoiceServices extends GetxService {
  final languageServices = Get.find<LanguageServices>();

  final voiceRepository = VoiceRepository();
  final voiceList = <Voice>[].obs;

  Future<void> manualOnInit() async {
    await getVoiceList();
  }

  Future<void> getVoiceList() async {
    voiceList.value = await voiceRepository.getVoiceList(
      language: languageServices.languageCodeSystem.value,
    );
  }
}
