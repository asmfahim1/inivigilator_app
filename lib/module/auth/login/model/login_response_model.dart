// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  bool? ok;
  String? message;
  Data? data;
  String? token;

  LoginResponseModel({
    this.ok,
    this.message,
    this.data,
    this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    ok: json["ok"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "message": message,
    "data": data?.toJson(),
    "token": token,
  };
}

class Data {
  int? id;
  String? name;
  String? positions;
  String? email;
  String? password;
  String? phone;
  String? address;
  bool? firstLogin;
  DateTime? createAt;
  DateTime? updateAt;

  Data({
    this.id,
    this.name,
    this.positions,
    this.email,
    this.password,
    this.phone,
    this.address,
    this.firstLogin,
    this.createAt,
    this.updateAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    positions: json["positions"],
    email: json["email"],
    password: json["password"],
    phone: json["phone"],
    address: json["address"],
    firstLogin: json["first_login"],
    createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
    updateAt: json["updateAt"] == null ? null : DateTime.parse(json["updateAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "positions": positions,
    "email": email,
    "password": password,
    "phone": phone,
    "address": address,
    "first_login": firstLogin,
    "createAt": createAt?.toIso8601String(),
    "updateAt": updateAt?.toIso8601String(),
  };
}
