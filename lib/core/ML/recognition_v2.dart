import 'dart:ui';

class RecognitionV2 {
  int studentId;
  String studentName;
  Rect location;
  List<double> embeddings;
  double distance;
  /// Constructs a Category.
  RecognitionV2(this.studentId, this.studentName, this.location,this.embeddings,this.distance);
}