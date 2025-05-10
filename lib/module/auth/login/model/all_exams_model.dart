// To parse this JSON data, do
//
//     final examListModel = examListModelFromJson(jsonString);

import 'dart:convert';

ExamListModel examListModelFromJson(String str) => ExamListModel.fromJson(json.decode(str));

String examListModelToJson(ExamListModel data) => json.encode(data.toJson());

class ExamListModel {
  List<ExamDatum>? data;
  bool? ok;
  int? status;

  ExamListModel({
    this.data,
    this.ok,
    this.status,
  });

  factory ExamListModel.fromJson(Map<String, dynamic> json) => ExamListModel(
    data: json["data"] == null ? [] : List<ExamDatum>.from(json["data"]!.map((x) => ExamDatum.fromJson(x))),
    ok: json["ok"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "ok": ok,
    "status": status,
  };
}

class ExamDatum {
  int? id;
  String? name;
  int? examTypeId;
  DateTime? createAt;
  DateTime? updateAt;
  ExamType? examType;

  ExamDatum({
    this.id,
    this.name,
    this.examTypeId,
    this.createAt,
    this.updateAt,
    this.examType,
  });

  factory ExamDatum.fromJson(Map<String, dynamic> json) => ExamDatum(
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
  int? id;
  String? name;
  DateTime? createAt;
  DateTime? updateAt;

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
