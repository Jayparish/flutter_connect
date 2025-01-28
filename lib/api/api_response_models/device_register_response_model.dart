// To parse this JSON data, do
//
//     final deviceRegisterResponseModel = deviceRegisterResponseModelFromJson(jsonString);

import 'dart:convert';

DeviceRegisterResponseModel deviceRegisterResponseModelFromJson( str) => DeviceRegisterResponseModel.fromJson(json.decode(str));

String deviceRegisterResponseModelToJson(DeviceRegisterResponseModel data) => json.encode(data.toJson());

class DeviceRegisterResponseModel {
  Data? data;

  DeviceRegisterResponseModel({
    this.data,
  });

  factory DeviceRegisterResponseModel.fromJson(Map<String, dynamic> json) => DeviceRegisterResponseModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  String? clientSecret;
  String? enKey;

  Data({
    this.clientSecret,
    this.enKey,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    clientSecret: json["client_secret"],
    enKey: json["en_key"],
  );

  Map<String, dynamic> toJson() => {
    "client_secret": clientSecret,
    "en_key": enKey,
  };
}
