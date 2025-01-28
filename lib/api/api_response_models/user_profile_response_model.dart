// To parse this JSON data, do
//
//     final userProfileResponseModel = userProfileResponseModelFromJson(jsonString);

import 'dart:convert';

UserProfileResponseModel userProfileResponseModelFromJson(str) => UserProfileResponseModel.fromJson(json.decode(str));

String userProfileResponseModelToJson(UserProfileResponseModel data) => json.encode(data.toJson());

class UserProfileResponseModel {
  int? status;
  List<String>? studioUrls;
  String? userUrl;

  UserProfileResponseModel({
    this.status,
    this.studioUrls,
    this.userUrl,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) => UserProfileResponseModel(
    status: json["status"],
    studioUrls: json["studio_urls"] == null ? [] : List<String>.from(json["studio_urls"]!.map((x) => x)),
    userUrl: json["user_url"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "studio_urls": studioUrls == null ? [] : List<dynamic>.from(studioUrls!.map((x) => x)),
    "user_url": userUrl,
  };
}
