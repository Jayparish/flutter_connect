// To parse this JSON data, do
//
//     final userValidateResponseModel = userValidateResponseModelFromJson(jsonString);

import 'dart:convert';

UserValidateResponseModel userValidateResponseModelFromJson(str) => UserValidateResponseModel.fromJson(json.decode(str));

String userValidateResponseModelToJson(UserValidateResponseModel data) => json.encode(data.toJson());

class UserValidateResponseModel {
  int? status;
  String? ableType;
  String? token;
  int? clientId;

  UserValidateResponseModel({
    this.status,
    this.ableType,
    this.token,
    this.clientId,
  });

  factory UserValidateResponseModel.fromJson(Map<String, dynamic> json) => UserValidateResponseModel(
    status: json["status"],
    ableType: json["able_type"],
    token: json["token"],
    clientId: json["client_id"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "able_type": ableType,
    "token": token,
    "client_id": clientId,
  };
}
