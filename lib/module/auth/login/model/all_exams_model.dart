// To parse this JSON data, do
//
//     final examNameList = examNameListFromJson(jsonString);

import 'dart:convert';

List<ExamNameList> examNameListFromJson(String str) => List<ExamNameList>.from(json.decode(str).map((x) => ExamNameList.fromJson(x)));

String examNameListToJson(List<ExamNameList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExamNameList {
  final int? id;
  final String? name;
  final int? examTypeId;
  final DateTime? createAt;
  final DateTime? updateAt;
  final ExamType? examType;

  ExamNameList({
    this.id,
    this.name,
    this.examTypeId,
    this.createAt,
    this.updateAt,
    this.examType,
  });

  factory ExamNameList.fromJson(Map<String, dynamic> json) => ExamNameList(
    id: json["id"],
    name: json["name"],
    examTypeId: json["examTypeId"],
    createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
    updateAt: json["updateAt"] == null ? null : DateTime.parse(json["updateAt"]),
    examType: json["exam_type"] == null ? null : ExamType.fromJson(json["exam_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "examTypeId": examTypeId,
    "createAt": createAt?.toIso8601String(),
    "updateAt": updateAt?.toIso8601String(),
    "exam_type": examType?.toJson(),
  };
}

class ExamType {
  final int? id;
  final String? name;
  final DateTime? createAt;
  final DateTime? updateAt;

  ExamType({
    this.id,
    this.name,
    this.createAt,
    this.updateAt,
  });

  factory ExamType.fromJson(Map<String, dynamic> json) => ExamType(
    id: json["id"],
    name: json["name"],
    createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
    updateAt: json["updateAt"] == null ? null : DateTime.parse(json["updateAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "createAt": createAt?.toIso8601String(),
    "updateAt": updateAt?.toIso8601String(),
  };
}
