// To parse this JSON data, do
//
//     final callStoreApiResponseModel = callStoreApiResponseModelFromJson(jsonString);

import 'dart:convert';

CallStoreApiResponseModel callStoreApiResponseModelFromJson(str) => CallStoreApiResponseModel.fromJson(json.decode(str));

String callStoreApiResponseModelToJson(CallStoreApiResponseModel data) => json.encode(data.toJson());

class CallStoreApiResponseModel {
  bool? status;
  String? message;

  CallStoreApiResponseModel({
    this.status,
    this.message,
  });

  factory CallStoreApiResponseModel.fromJson(Map<String, dynamic> json) => CallStoreApiResponseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
