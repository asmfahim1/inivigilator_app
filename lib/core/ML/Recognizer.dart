import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:invigilator_app/core/ML/recognition_v2.dart';
import 'package:invigilator_app/core/utils/db_helper.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 112;
  static const int HEIGHT = 112;
  final dbHelper = DatabaseHelper();
  Map<String, RecognitionV2> registered = {};
  String get modelName => 'assets/trainned_model/mobile_face_net.tflite';

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
    initDB();
  }

  initDB() async {
    await dbHelper.init();
    loadRegisteredFaces();
  }

  void loadRegisteredFaces() async {
    registered.clear();
    final allRows = await dbHelper.queryAllRows();
    // debugPrint('query all rows:');
    for (final row in allRows) {
      if (kDebugMode) {
        print("------------${row[DatabaseHelper.student_name]}-------------");
      }
      // String studentId = row[DatabaseHelper.studentId];
      String name = row[DatabaseHelper.student_name];
      List<double> embd =  List<double>.from(jsonDecode(row[DatabaseHelper.columnEmbedding]) as Iterable);
      RecognitionV2 recognition =
      RecognitionV2(row[DatabaseHelper.studentId],"${row[DatabaseHelper.student_name]}_${row[DatabaseHelper.studentId]}", Rect.zero, embd, 0);
      registered.putIfAbsent(name, () => recognition);
      if (kDebugMode) {
        print("R = $name");
      }
    }
  }

  void registerFaceInDB(String name, List<double> embedding) async {
    Map<String, dynamic> row = {
      DatabaseHelper.student_name: name,
      DatabaseHelper.columnEmbedding: embedding.join(",")
    };
    final id = await dbHelper.insert(row);
    if (kDebugMode) {
      print('inserted row id: $id');
    }
    loadRegisteredFaces();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      if (kDebugMode) {
        print(
            'Unable to create interpreter, Caught Exception: ${e.toString()}');
      }
    }
  }

  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage =
    img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!
        .expand((channel) => [channel.r, channel.g, channel.b])
        .map((value) => value.toDouble())
        .toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) /
                  127.5;
        }
      }
    }
    return reshapedArray.reshape([1, 112, 112, 3]);
  }

  RecognitionV2 recognize(img.Image image, Rect location) {
    //TODO crop face from image resize it and convert it to float array
    var input = imageToArray(image);

    //TODO output array
    List output = List.filled(1 * 192, 0).reshape([1, 192]);

    //TODO performs inference
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    // print('=======Time to run inference: $run ms ==========');

    //TODO convert dynamic list to double list
    List<double> outputArray = output.first.cast<double>();

    //TODO looks for the nearest embedding in the database and returns the pair
    Pair pair = findNearest(outputArray);

    return RecognitionV2(
        pair.id, pair.name, location, outputArray, pair.distance);
  }

  //TODO  looks for the nearest embedding in the database and returns the pair which contain information of registered face with which face is most similar
  findNearest(List<double> emb) {
    Pair pair = Pair(0, "Unknown", -5);
    for (MapEntry<String, RecognitionV2> item in registered.entries) {

      // print('registered faces---------------------------------------- ${registered.length}\n');

      final String name = item.key;
      final int id = item.value.id;
      List<double> knownEmb = item.value.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] - knownEmb[i];
        distance += diff * diff;
      }
      distance = sqrt(distance);
      if (kDebugMode) {
        print('---Distance is : $distance Name : $name');
      }


      if (pair.distance == -5 || distance < pair.distance) {
        pair.distance = distance;
        pair.name = name;
        pair.id = id;
      }
    }
    return pair;
  }

  void close() {
    interpreter.close();
  }
}

class Pair {
  int id;
  String name;
  double distance;
  Pair(this.id, this.name, this.distance);
}