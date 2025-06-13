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


/*
{
"ok": true,
"message": "susccess",
"data": [
{
"id": 101,
"studentId": 1,
"rollNo": "A1001",
"registerNo": "REG2025-01",
"seat_done": true,
"attendece_done": true,
"proxy_attendece": false,
"student": {
"id": 1,
"name": "Rahim Uddin",
"email": "rahim@example.com",
"photo_path": [],
"studentsFaceVector": []
}
}
]
}
*/