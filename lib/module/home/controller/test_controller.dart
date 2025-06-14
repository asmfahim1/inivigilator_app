import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:invigilator_app/core/ML/Recognizer.dart';
import 'package:invigilator_app/core/ML/recognition_v2.dart';
import 'package:invigilator_app/core/utils/db_helper.dart';
import 'package:invigilator_app/module/home/repo/test_repo.dart';

class TestController extends GetxController {
  TestRepo? testRepo;
  TestController({this.testRepo});

  late List<CameraDescription> cameras;
  final dbHelper = DatabaseHelper();

  CameraController? controller;
  RxBool isBusy = false.obs;
  RxBool isDialogueOpen = false.obs;
  RxBool isCameraInitialized = false.obs;
  late Size size;
  late CameraDescription description;
  var camDirec = CameraLensDirection.front.obs;
  var scanResults = <RecognitionV2>[].obs;

  // Declare face detector and recognizer
  late FaceDetector faceDetector;
  late Recognizer recognizer;

  CameraImage? frame;
  img.Image? image;
  RxBool register = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await initializeFaceDetector();
    await initializeRecognizer();
    await initializeCamera();
    await dbHelper.init();
  }

  Future<void> initializeFaceDetector() async {
    var options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableContours: true,
      enableClassification: true,
    );
    faceDetector = FaceDetector(options: options);
  }

  Future<void> initializeRecognizer() async {
    recognizer = Recognizer();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      description = cameras.firstWhere((camera) => camera.lensDirection == camDirec.value, orElse: () => cameras.first);
      controller = CameraController(
        description,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await controller!.initialize();
      controller!.startImageStream((image) {
        if (!isBusy.value && !isDialogueOpen.value) {
          isBusy.value = true;
          frame = image;
          doFaceDetectionOnFrame();
        }
      });
      isCameraInitialized.value = true;
      update();
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing camera: $e");
      }
      isCameraInitialized.value = false;
    }
  }

  Future<void> doFaceDetectionOnFrame() async {
    final inImg = getInputImage();
    final faces = await faceDetector.processImage(inImg!);
    // if (kDebugMode) {
    //   print('--------$faces--------');
    // }
    performFaceRecognition(faces);
  }

  InputImage? getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in frame!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(frame!.width.toDouble(), frame!.height.toDouble());
    final camera = description;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    // if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(frame!.format.raw);
    // if (inputImageFormat == null) return null;

    final planeData = frame!.planes.first;

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: planeData.bytesPerRow,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, metadata: inputImageData);

    return inputImage;
  }

/*  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }*/

  Future<void> performFaceRecognition(List<Face> faces) async {
    scanResults.clear();

    image = convertYUV420ToImage(frame!);
    image = img.copyRotate(image!,
        angle: camDirec.value == CameraLensDirection.front ? 270 : 90);

    if (faces.isNotEmpty) {
      Face closestFace = faces.reduce((curr, next) {
        return (curr.boundingBox.height * curr.boundingBox.width) >
                (next.boundingBox.height * curr.boundingBox.width)
            ? curr
            : next;
      });

      Rect faceRect = closestFace.boundingBox;

      img.Image croppedFace = img.copyCrop(image!,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt());

      RecognitionV2 recognition = recognizer.recognize(croppedFace, faceRect);

      if (recognition.distance <= 1 && recognition.name != 'Unknown') {
        isDialogueOpen.value = true;
        // await stopCamera();
        showFaceRecognitionDialog(recognition);
        scanResults.add(recognition);
        return;
      }
    }

    isBusy.value = false;
  }

  img.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: width, height: height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data!.setPixelR(w, h, yuv2rgb(y, u, v));
      }
    }
    return image;
  }

  int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [0, 255]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  void toggleCameraDirection() async {
    if (camDirec.value == CameraLensDirection.back) {
      camDirec.value = CameraLensDirection.front;
      description = cameras[1];
    } else {
      camDirec.value = CameraLensDirection.back;
      description = cameras[0];
    }
    await controller?.stopImageStream();
    initializeCamera();
  }

  void showFaceRecognitionDialog(RecognitionV2 recognition) {
    Get.defaultDialog(
      title: "Face Recognized",
      content: Column(
        children: [
          Text("Name: ${recognition.name}"),
          Text("Distance: ${recognition.distance.toStringAsFixed(2)}"),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          isDialogueOpen.value = false;
          isBusy.value = false;
          // await resumeCameraPreview();
          await insertAttendanceRecord(recognition);
        },
        child: const Text("OK"),
      ),
    );
  }

  //db insertion and
  Future<void> insertAttendanceRecord(RecognitionV2 recognition) async {
    bool nameExists = await dbHelper.isNameAlreadyPresent(recognition.name);
    if (!nameExists) {
      // Insert data into attendance table
      Map<String, dynamic> record = {
        'name': recognition.name,
        'distance': recognition.distance,
        'timestamp': DateTime.now().toString(),
      };
      await dbHelper.insertAttendanceRecord(record);
    }
  }

/*  Future<void> resumeCameraPreview() async {
    if (kDebugMode) {
      print("Resuming camera preview...");
    }
    // Resume the camera preview
    isBusy.value = false;
    if (controller != null) {
      await controller!.resumePreview();
      await controller!.startImageStream((image) {
        if (!isBusy.value) {
          isBusy.value = true;
          frame = image;
          doFaceDetectionOnFrame();
        }
      });
    } else {
      if (kDebugMode) {
        print("Camera controller is null");
      }
    }
  }

  // Stop the camera and release resources
  Future<void> stopCamera() async {
    if (kDebugMode) {
      print("Stopping camera preview...");
    }
    if (controller != null) {
      await controller!.pausePreview();
      await controller!.stopImageStream();
    } else {
      if (kDebugMode) {
        print("Camera controller is null");
      }
    }
  }*/

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }
}
