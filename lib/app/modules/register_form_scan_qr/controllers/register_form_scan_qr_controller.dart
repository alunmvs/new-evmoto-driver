import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:new_evmoto_driver/app/services/language_services.dart';
import 'package:new_evmoto_driver/app/services/theme_color_services.dart';
import 'package:new_evmoto_driver/app/services/typography_services.dart';

class RegisterFormScanQrController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  late CameraController? cameraController;
  final barcodeScanner = BarcodeScanner();

  final isFetch = false.obs;
  final isProcessing = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    var cameraList = await availableCameras();
    cameraController = CameraController(
      cameraList[0],
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup
                .nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );
    await cameraController!.initialize();

    await cameraController!.startImageStream((CameraImage image) async {
      if (isProcessing.value == false) {
        isProcessing.value = true;
        final barcodes = await barcodeScanner.processImage(
          (inputImageFromCameraImage(image, cameraList[0]))!,
        );
        for (final barcode in barcodes) {
          await cameraController?.stopImageStream();
          Get.back(result: barcode.displayValue);
          break;
        }
        isProcessing.value = false;
      }
    });

    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    await cameraController?.dispose();
  }

  InputImage? inputImageFromCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = 0;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888))
      return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}
