import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:invigilator_app/core/ML/Recognition.dart';
import 'package:invigilator_app/core/ML/Recognizer.dart';
import 'package:invigilator_app/core/utils/db_helper.dart';
import 'package:invigilator_app/module/home/repo/test_repo.dart';

class TestController extends GetxController {
  TestRepo? testRepo;
  TestController({this.testRepo});

  late List<CameraDescription> cameras;
  final dbHelper = DatabaseHelper();

  CameraController? controller;
  var isBusy = false.obs;
  var isCameraInitialized = false.obs;
  late Size size;
  late CameraDescription description;
  var camDirec = CameraLensDirection.front.obs;
  var scanResults = <Recognition>[].obs;

  // Declare face detector and recognizer
  late FaceDetector faceDetector;
  late Recognizer recognizer;

  CameraImage? frame;
  img.Image? image;
  var register = false.obs;

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
      description = cameras.firstWhere(
              (camera) => camera.lensDirection == camDirec.value,
          orElse: () => cameras.first);
      controller = CameraController(
        description,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await controller!.initialize();
      controller!.startImageStream((image) {
        if (!isBusy.value) {
          isBusy.value = true;
          frame = image;
          doFaceDetectionOnFrame(image);
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

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }

  Future<void> doFaceDetectionOnFrame(CameraImage image) async {
    final inImg = _convertCameraImageToInputImage(image);
    final faces = await faceDetector.processImage(inImg);
    performFaceRecognition(faces, image);
  }

  InputImage _convertCameraImageToInputImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final inputImageData = InputImageData(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      imageRotation:
      _rotationIntToImageRotation(controller!.description.sensorOrientation),
      inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21,
      planeData: image.planes.map((Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      }).toList(),
    );

    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
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
  }

  Future<void> performFaceRecognition(List<Face> faces, CameraImage cameraImage) async {
    scanResults.clear();

    // Convert CameraImage to Image and rotate it
    image = convertYUV420ToImage(cameraImage);
    image = img.copyRotate(image!,
        angle: camDirec.value == CameraLensDirection.front ? 270 : 90);

    if (faces.isNotEmpty) {
      // Find the closest face based on the size of the bounding box
      Face closestFace = faces.reduce((curr, next) {
        return (curr.boundingBox.height * curr.boundingBox.width) >
            (next.boundingBox.height * curr.boundingBox.width)
            ? curr
            : next;
      });

      Rect faceRect = closestFace.boundingBox;
      // Crop the face
      img.Image croppedFace = img.copyCrop(image!,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt());

      // Pass cropped face to face recognition model
      Recognition recognition = recognizer.recognize(croppedFace, faceRect);

      // New logic to handle recognition
      if (recognition.distance <= 1) {
        // Stop the camera before showing the dialog
        await stopCamera();
        showFaceRecognitionDialog(recognition);
        scanResults.add(recognition);
        return; // Stop further processing
      } else {
        recognition.name = "Unknown";
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

  void showFaceRecognitionDialog(Recognition recognition) {
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
          Get.back(); // Close the dialog
          await resumeCameraPreview();
          await insertAttendanceRecord(recognition);
        },
        child: const Text("OK"),
      ),
    );
  }

  //db insertion and
  Future<void> insertAttendanceRecord(Recognition recognition) async {
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

  Future<void> resumeCameraPreview() async {
    print("Resuming camera preview...");
    // Resume the camera preview
    isBusy.value = false;
    if (controller != null) {
      await controller!.resumePreview();
      await controller!.startImageStream((image) {
        if (!isBusy.value) {
          isBusy.value = true;
          frame = image;
          doFaceDetectionOnFrame(image);
        }
      });
    } else {
      print("Camera controller is null");
    }
  }

  // Stop the camera and release resources
  Future<void> stopCamera() async {
    print("Stopping camera preview...");
    if (controller != null) {
      await controller!.pausePreview();
      await controller!.stopImageStream();
    } else {
      print("Camera controller is null");
    }
  }
}

