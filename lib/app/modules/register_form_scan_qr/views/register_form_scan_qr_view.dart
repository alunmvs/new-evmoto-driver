import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_form_scan_qr_controller.dart';

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const scanSize = 250.0;
    const radius = 16.0;

    final left = (size.width - scanSize) / 2;
    final top = (size.height - scanSize) / 2;

    // Path overlay + lubang tengah
    final overlayPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, scanSize, scanSize),
          const Radius.circular(radius),
        ),
      );

    // Paint overlay hitam transparan
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.5);

    canvas.drawPath(overlayPath, overlayPaint);

    // Border kotak rounded
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0
      ..color = Colors.transparent;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, scanSize, scanSize),
        const Radius.circular(radius),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RegisterFormScanQrView extends GetView<RegisterFormScanQrController> {
  const RegisterFormScanQrView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Scan Kode Referral",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  CameraPreview(controller.cameraController!),
                  CustomPaint(
                    size: Size.infinite,
                    painter: ScannerOverlayPainter(),
                  ),
                ],
              ),
      ),
    );
  }
}
