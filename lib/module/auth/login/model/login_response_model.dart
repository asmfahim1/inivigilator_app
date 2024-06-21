import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  final bool? ok;
  final String? message;
  final Data? data;
  final String? token;

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
  final int? id;
  final String? name;
  final String? email;
  final String? address;
  final String? password;
  final String? phone;
  final bool? firstLogin;
  final bool? registretionDone;
  final bool? varify;
  final DateTime? createAt;
  final DateTime? updateAt;

  Data({
    this.id,
    this.name,
    this.email,
    this.address,
    this.password,
    this.phone,
    this.firstLogin,
    this.registretionDone,
    this.varify,
    this.createAt,
    this.updateAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    address: json["address"],
    password: json["password"],
    phone: json["phone"],
    firstLogin: json["first_login"],
    registretionDone: json["registretionDone"],
    varify: json["varify"],
    createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
    updateAt: json["updateAt"] == null ? null : DateTime.parse(json["updateAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "address": address,
    "password": password,
    "phone": phone,
    "first_login": firstLogin,
    "registretionDone": registretionDone,
    "varify": varify,
    "createAt": createAt?.toIso8601String(),
    "updateAt": updateAt?.toIso8601String(),
  };
}
