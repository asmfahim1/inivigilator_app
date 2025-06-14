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

      print("Name: $name, ID: $id, Match: $distance");


    }

    print("Actual Pair distance is : ${pair.distance} and name is ${pair.name}");
    return pair;
  }

  //TODO  looks for the nearest embeeding in the database and returns the pair which contain information of registered face with which face is most similar
  /*
  findNearest(List<double> emb) {
    Pair pair = Pair(0, "Unknown", -5);
    for (MapEntry<String, RecognitionV2> item in registered.entries) {

      // print('registered faces---------------------------------------- ${registered.length}\n');

      final String name = item.key;
      final int id = item.value.studentId;
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
  ===================================================================================================
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


      if (pair.distance == -5 || distance < pair.distance) {
        pair.distance = distance;
        pair.name = name;
        pair.id = id;
      }

      print("Name: $name, ID: $id, Match: $distance");


    }

    print("Actual Pair distance is : ${pair.distance} and name is ${pair.name}");
    return pair;
  }
  */


  /*

  List<double> calculateAverageEmbedding(List<List<double>> embeddings) {
    int length = embeddings[0].length;
    List<double> averageEmbedding = List.filled(length, 0.0);

    // Sum each component across all embeddings
    for (var emb in embeddings) {
      for (int i = 0; i < length; i++) {
        averageEmbedding[i] += emb[i];
      }
    }

    // Divide each component by the number of embeddings to get the average
    int numEmbeddings = embeddings.length;
    for (int i = 0; i < length; i++) {
      averageEmbedding[i] /= numEmbeddings;
    }

    return averageEmbedding;
  }

  Pair findNearest(List<double> emb) {
    // Normalize input embedding
    List<double> normalizedEmb = normalize(emb);
    Pair nearest = Pair(0, "Unknown", -1.0);

    Map<int, List<List<double>> > groupEmb = {};
    Map<int, List<double> > groupEmbAvg = {};
    Map<int, String> groupName = {};

    // for(MapEntry<String, RecognitionV2> entry in registered.entries){
    //   if(groupEmb.containsKey(entry.value.id)){
    //     groupEmb[entry.value.id]!.add(entry.value.embeddings);
    //   }else{
    //     groupEmb[entry.value.id]!.add(entry.value.embeddings);
    //     groupName[entry.value.id] = entry.key;
    //   }
    // }

    for (MapEntry<String, RecognitionV2> entry in registered.entries) {
      if (!groupEmb.containsKey(entry.value.id)) {
        groupEmb[entry.value.id] = [];
        groupName[entry.value.id] = entry.key;
      }
      groupEmb[entry.value.id]!.add(entry.value.embeddings);

      // Store name against each I
    }

    for( var entry in groupEmb.entries){
      groupEmbAvg[entry.key] = calculateAverageEmbedding(groupEmb[entry.key]!);
    }


    for (var entry in groupEmbAvg.entries) {
      String name = groupName[entry.key]!;
      int id = entry.key;

      // Calculate average of all embeddings for this person

      List<double> normalizedAvgEmbedding = normalize(entry.value); // Normalize the average embedding

      // Calculate cosine similarity between input and average embedding
      double dotProduct = 0;
      for (int i = 0; i < normalizedEmb.length; i++) {
        dotProduct += normalizedEmb[i] * normalizedAvgEmbedding[i];
      }

      // Update nearest pair if this similarity is the highest and above threshold
      if (dotProduct > nearest.distance) {
        nearest = Pair(id, name, dotProduct);
      }
      print("Name: $name, ID: $id, Match: $dotProduct");
    }

    print("Closest match similarity: ${nearest.distance}, Name: ${nearest.name}");
    return nearest;
  }

*/


/*  // by voting
  List<double> normalize(List<double> emb) {
    double magnitude = sqrt(emb.fold(0, (sum, e) => sum + e * e));
    return magnitude != 0 ? emb.map((e) => e / magnitude).toList() : emb;
  }
  Pair findNearest(List<double> emb) {
    // Normalize the input embedding
    List<double> normalizedEmb = normalize(emb);

    // Map to hold cumulative similarity scores for each registered person
    Map<int, double> similarityScores = {};
    Map<int, String> idMap = {};  // Keep track of IDs for each person

    for (MapEntry<String, RecognitionV2> entry in registered.entries) {
      String name = entry.key;
      int id = entry.value.id;
      List<double> knownEmb = normalize(entry.value.embeddings); // Normalize known embedding

      // Calculate cosine similarity for each embedding
      double dotProduct = 0;
      for (int i = 0; i < normalizedEmb.length; i++) {
        dotProduct += normalizedEmb[i] * knownEmb[i];
      }


      // Accumulate the similarity score for this person

      if(dotProduct >= .7) {
        if (similarityScores.containsKey(id)) {
          similarityScores[id] = (similarityScores[id]! + (dotProduct))!;
        } else {
          similarityScores[id] = dotProduct;
          idMap[id] = name;
        }
      }

      print("Name: $name, ID: $id, Similarity Score: $dotProduct");
    }

    // Find the person with the highest cumulative similarity score
    String bestMatchName = "Unknown";
    int bestMatchId = 0;
    double highestScore = -1;

    similarityScores.forEach((id, score) {
      if (score > highestScore) {
        highestScore = score;
        bestMatchName = idMap[id]!;
        bestMatchId = id;
      }
    });

    print("Best Match - Name: $bestMatchName, ID: $bestMatchId, Cumulative Similarity: $highestScore");

    return Pair(bestMatchId, bestMatchName, highestScore);
  }
*/



/*
  Pair findNearest(List<double> emb) {
    // Normalize input embedding
    List<double> normalizedEmb = normalize(emb);
    Pair nearest = Pair(0, "Unknown", -1.0);

    for (MapEntry<String, RecognitionV2> entry in registered.entries) {
      String name = entry.key;
      int id = entry.value.id;
      List<double> knownEmb = normalize(entry.value.embeddings); // Normalize known embedding

      // Calculate cosine similarity
      double dotProduct = 0;
      for (int i = 0; i < normalizedEmb.length; i++) {
        dotProduct += normalizedEmb[i] * knownEmb[i];
      }

      // Update nearest pair if this similarity is the highest and above threshold
      if (dotProduct > nearest.distance) {
        nearest = Pair(id, name, dotProduct);
      }
      print("name: ${entry.key}  id: ${entry.value.id} match: ${dotProduct}");
    }



    print("Closest match similarity: ${nearest.distance}, name: ${nearest.name}");
    return nearest;
  }

*/



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