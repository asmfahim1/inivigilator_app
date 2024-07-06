class StudentModel {
  final String studentId;
  final String studentName;
  final String examId;
  final String examName;
  final List<double> faceVector;
  final String createdAt;
  final String updatedAt;

  StudentModel({
    required this.studentId,
    required this.studentName,
    required this.examId,
    required this.examName,
    required this.faceVector,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['student_id'],
      studentName: json['student_name'],
      examId: json['exam_id'],
      examName: json['exam_name'],
      faceVector: List<double>.from(json['face_vector']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'exam_id': examId,
      'exam_name': examName,
      'face_vector': faceVector,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
