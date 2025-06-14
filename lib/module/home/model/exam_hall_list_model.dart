// To parse this JSON data, do
//
//     final hallListModel = hallListModelFromJson(jsonString);

import 'dart:convert';

HallListModel hallListModelFromJson(String str) => HallListModel.fromJson(json.decode(str));

String hallListModelToJson(HallListModel data) => json.encode(data.toJson());

class HallListModel {
  List<ExamData>? data;
  bool? ok;
  String? message;

  HallListModel({
    this.data,
    this.ok,
    this.message,
  });

  factory HallListModel.fromJson(Map<String, dynamic> json) => HallListModel(
    data: json["data"] == null ? [] : List<ExamData>.from(json["data"]!.map((x) => ExamData.fromJson(x))),
    ok: json["ok"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "ok": ok,
    "message": message,
  };
}

class ExamData {
  int? id;
  String? examDate;
  String? examStart;
  String? examEnd;
  List<Room>? rooms;

  ExamData({
    this.id,
    this.examDate,
    this.examStart,
    this.examEnd,
    this.rooms,
  });

  factory ExamData.fromJson(Map<String, dynamic> json) => ExamData(
    id: json["id"],
    examDate: json["examDate"],
    examStart: json["examStart"],
    examEnd: json["examEnd"],
    rooms: json["rooms"] == null ? [] : List<Room>.from(json["rooms"]!.map((x) => Room.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "examDate": examDate,
    "examStart": examStart,
    "examEnd": examEnd,
    "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
  };
}

class Room {
  int? roomId;
  String? roomNo;
  int? capacity;
  Hall? hall;

  Room({
    this.roomId,
    this.roomNo,
    this.capacity,
    this.hall,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    roomId: json["roomId"],
    roomNo: json["roomNo"],
    capacity: json["capacity"],
    hall: json["hall"] == null ? null : Hall.fromJson(json["hall"]),
  );

  Map<String, dynamic> toJson() => {
    "roomId": roomId,
    "roomNo": roomNo,
    "capacity": capacity,
    "hall": hall?.toJson(),
  };
}

class Hall {
  int? id;
  String? name;
  String? eiin;
  String? address;

  Hall({
    this.id,
    this.name,
    this.eiin,
    this.address,
  });

  factory Hall.fromJson(Map<String, dynamic> json) => Hall(
    id: json["id"],
    name: json["name"],
    eiin: json["eiin"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "eiin": eiin,
    "address": address,
  };
}



/*{
"ok": true,
"message": "susccess",
"data": [
{
"id": 10,
"examDate": "2025-06-08",
"examStart": "10:00 AM",
"examEnd": "12:00 PM",
"rooms": [
{
"roomId": 3,
"roomNo": "C201",
"capacity": 40,
"hall": {
"id": 1,
"name": "Main Hall",
"location": "Building A"
}
}
]
}
]
}*/
