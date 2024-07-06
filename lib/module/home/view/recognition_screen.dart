import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:invigilator_app/core/ML/Recognition.dart';
import 'package:invigilator_app/module/home/controller/test_controller.dart';

class MyHomePage extends StatelessWidget {
  final TestController testController = Get.find<TestController>();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          if (!testController.isCameraInitialized.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            margin: const EdgeInsets.only(top: 0),
            color: Colors.black,
            child: Stack(
              children: [
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  width: size.width,
                  height: size.height,
                  child: Container(
                    child: AspectRatio(
                      aspectRatio: testController.controller!.value.aspectRatio,
                      child: CameraPreview(testController.controller!),
                    ),
                  ),
                ),
                Obx(() {
                  if (testController.scanResults.isEmpty) {
                    return Container();
                  } else {
                    final imageSize = Size(
                      testController.controller!.value.previewSize!.height,
                      testController.controller!.value.previewSize!.width,
                    );
                    return Positioned(
                      top: 0.0,
                      left: 0.0,
                      width: size.width,
                      height: size.height,
                      child: CustomPaint(
                        painter: FaceDetectorPainter(
                            imageSize, testController.scanResults, testController.camDirec.value),
                      ),
                    );
                  }
                }),
                Positioned(
                  top: size.height - 140,
                  left: 0,
                  width: size.width,
                  height: 80,
                  child: Card(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    color: Colors.blue,
                    child: Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.cached,
                                    color: Colors.white,
                                  ),
                                  iconSize: 40,
                                  color: Colors.black,
                                  onPressed: () {
                                    testController.toggleCameraDirection();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDirec);

  final Size absoluteImageSize;
  final List<Recognition> faces;
  final CameraLensDirection camDirec;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.indigoAccent;

    for (Recognition face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          camDirec == CameraLensDirection.front
              ? (absoluteImageSize.width - face.location.right) * scaleX
              : face.location.left * scaleX,
          face.location.top * scaleY,
          camDirec == CameraLensDirection.front
              ? (absoluteImageSize.width - face.location.left) * scaleX
              : face.location.right * scaleX,
          face.location.bottom * scaleY,
        ),
        paint,
      );

      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 20),
          text: "${face.name}  ${face.distance.toStringAsFixed(2)}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas,
          Offset(face.location.left * scaleX, face.location.top * scaleY));
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return true;
  }
}
