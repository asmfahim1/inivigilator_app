import 'dart:convert';

FaceDetectModel faceDetectModelFromJson(String str) => FaceDetectModel.fromJson(json.decode(str));

String faceDetectModelToJson(FaceDetectModel data) => json.encode(data.toJson());

class FaceDetectModel {
  List<Datum>? data;

  FaceDetectModel({
    this.data,
  });

  factory FaceDetectModel.fromJson(Map<String, dynamic> json) => FaceDetectModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  String? email;
  List<StudentsFaceVector>? studentsFaceVector;

  Datum({
    this.id,
    this.name,
    this.email,
    this.studentsFaceVector,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    studentsFaceVector: json["studentsFaceVector"] == null ? [] : List<StudentsFaceVector>.from(json["studentsFaceVector"]!.map((x) => StudentsFaceVector.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "studentsFaceVector": studentsFaceVector == null ? [] : List<dynamic>.from(studentsFaceVector!.map((x) => x.toJson())),
  };
}

class StudentsFaceVector {
  int? id;
  String? faceVector;
  int? studentId;
  DateTime? createAt;

  StudentsFaceVector({
    this.id,
    this.faceVector,
    this.studentId,
    this.createAt,
  });

  factory StudentsFaceVector.fromJson(Map<String, dynamic> json) => StudentsFaceVector(
    id: json["id"],
    faceVector: json["faceVector"],
    studentId: json["studentId"],
    createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "faceVector": faceVector,
    "studentId": studentId,
    "createAt": createAt?.toIso8601String(),
  };
}
