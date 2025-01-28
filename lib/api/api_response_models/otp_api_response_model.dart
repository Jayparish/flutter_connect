// To parse this JSON data, do
//
//     final otpApiResponseModel = otpApiResponseModelFromJson(jsonString);

import 'dart:convert';

OtpApiResponseModel otpApiResponseModelFromJson(str) => OtpApiResponseModel.fromJson(json.decode(str));

String otpApiResponseModelToJson(OtpApiResponseModel data) => json.encode(data.toJson());

class OtpApiResponseModel {
  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;

  OtpApiResponseModel({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
  });

  factory OtpApiResponseModel.fromJson(Map<String, dynamic> json) => OtpApiResponseModel(
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
  );

  Map<String, dynamic> toJson() => {
    "token_type": tokenType,
    "expires_in": expiresIn,
    "access_token": accessToken,
    "refresh_token": refreshToken,
  };
}
