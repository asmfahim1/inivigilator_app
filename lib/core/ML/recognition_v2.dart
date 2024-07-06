import 'dart:ui';

class RecognitionV2 {
  int id;
  String name;
  Rect location;
  List<double> embeddings;
  double distance;
  /// Constructs a Category.
  RecognitionV2(this.id, this.name, this.location,this.embeddings,this.distance);
}