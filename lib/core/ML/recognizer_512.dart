import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:invigilator_app/core/ML/recognition_v2.dart';
import 'package:invigilator_app/core/utils/db_helper.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Recognition512 {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 160;
  static const int HEIGHT = 160;
  final dbHelper = DatabaseHelper();
  Map<String, RecognitionV2> registered = Map();
  String get modelName => 'assets/facenet.tflite';

  Recognition512({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel().then((_) {
      // loadRegisteredFaces();
    });
  }

  // initDB() async {
  //   await dbHelper.init();
  //
  // }

  // final String bearerToken =
  //     'Ez6ChKkntsIiWjjb1MCxLerwCqW4q6t1eN7fSeSM';
  // Future<ApiResponse> fetchEmployees() async {
  //   final url = Uri.parse(
  //       'https://grypas.inflack.xyz/grypas-api/api/v1/employee/trained'); // Replace with your API endpoint
  //   final headers = {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer $bearerToken"
  //   };
  //   final body = jsonEncode({
  //     "type": "",
  //     "customer_id": 19
  //   });
  //   final response = await http.post(url, headers: headers, body: body);
  //
  //   print('-------- response from api : ${response.body}');
  //
  //   if (response.statusCode == 200) {
  //     return ApiResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load employees');
  //   }
  // }

  // void loadRegisteredFaces() async {
  //   ApiResponse apiResponse = await fetchEmployees();
  //
  //   print('--------- response stored --------');
  //   for (int i = 0; i < apiResponse.data.length; i++) {
  //     final employee = apiResponse.data[i];
  //     for (int j = 0; j < employee.descriptors.length; j++) {
  //       final descriptor = employee.descriptors[j];
  //
  //       try {
  //         List<double> embd = descriptor.descriptor.map((e) => e.toDouble()).toList();
  //         print('Parsed name: ${employee.user}_$j');
  //         print('Parsed Embeddings: ${embd.length}');
  //
  //         RecognitionV2 recognizerV2 = RecognitionV2(employee.id, "${employee.user}_$j", Rect.zero, embd, 0);
  //         registered.putIfAbsent(employee.user, () => recognizerV2);
  //
  //       } catch (e) {
  //         print('Error parsing descriptor for ${employee.user}: $e');
  //       }
  //     }
  //   }
  // }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage =
    img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
    //List<double> flattenedList = flattenImageData(inputImage);
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
    return reshapedArray.reshape([1, 160, 160, 3]);
  }

  RecognitionV2 recognize(img.Image image, Rect location) {
    //TODO crop face from image resize it and convert it to float array
    var input = imageToArray(image);

    //TODO output array
    List output = List.filled(1 * 512, 0).reshape([1, 512]);

    //TODO performs inference
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    print('=======Time to run inference: $run ms ==========');

    //TODO convert dynamic list to double list
    List<double> outputArray = output.first.cast<double>();

    //TODO looks for the nearest embeeding in the database and returns the pair
    Pair pair = findNearest(outputArray);

    return RecognitionV2(pair.id, pair.name, location, outputArray, pair.distance);
  }

  //TODO  looks for the nearest embeeding in the database and returns the pair which contain information of registered face with which face is most similar
  findNearest(List<double> emb) {
    Pair pair = Pair(0, "Unknown", -5);
    for (MapEntry<String, RecognitionV2> item in registered.entries) {
      final String name = item.key;
      final int id = item.value.studentId;
      List<double> knownEmb = item.value.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] - knownEmb[i];
        distance += diff * diff;
      }
      distance = sqrt(distance);
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
