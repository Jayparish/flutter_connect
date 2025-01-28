import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photomall_connect/constants/common_constants.dart';
import 'package:photomall_connect/preferences/preference_helper.dart';
import '../constants/key_constants.dart';
import '../preferences/preference_constants.dart';
import 'api_helper.dart';
import 'api_response_models/calls_store_response_model.dart';
import 'api_response_models/device_register_response_model.dart';
import 'api_response_models/otp_api_response_model.dart';
import 'api_response_models/user_profile_response_model.dart';
import 'api_response_models/user_validate_response_model.dart';
import 'api_urls_constants.dart';

class Api {
  BuildContext? context;
  ApiHelper? apiHelper = ApiHelper();

  Api(this.context);

  Future<FakeApi> fetchAlbum() async {
    var response = await apiHelper?.apiRequest(
        'https://jsonplaceholder.typicode.com/albums/1', {},
        get: true);
    return compute(fakeApiFromJson, response);
  }

  Future<DeviceRegisterResponseModel?> devRegApiCall(
      Map<String, dynamic> deviceMap) async {
    var response = await apiHelper!.apiRequest(
      deviceRegisterUrl,
      deviceMap,
    );
    return compute(deviceRegisterResponseModelFromJson, response);
  }

  Future<UserValidateResponseModel?> userValidateApiCall(
      {required String username, required String otpSignature}) async {
    String clientSecret =
        await PreferenceHelper.getString(clientSecretPreferenceKey);

    var map = {
      appVersionCodeKey: "$applicationVersion",
      countryCodeKey: "108",
      isChangeGoogleIdKey: "0",
      clientSecretKey: clientSecret,
      trueCallerKey: "0",
      userNameKey: username,
      otpSignatureKey: otpSignature
    };

    var response = await apiHelper!.apiRequest(
      userValidateUrl,
      map,
    );
    return compute(userValidateResponseModelFromJson, response);
  }

  Future<OtpApiResponseModel?> otpApiCall(
      {required String username,
      required String otp,
      required clientId}) async {
    String clientSecret =
        await PreferenceHelper.getString(clientSecretPreferenceKey);

    var map = {
      otpKey: otp,
      userNameKey: username,
      clientSecretKey: clientSecret,
      "grant_type": "otp_grant",
      "scope": "*",
      appVersionCodeKey: "$applicationVersion",
      trueCallerKey: "0",
      clientIdKey: clientId,
      countryCodeKey: "108",
      // isChangeGoogleIdKey: "0",
    };

    var response = await apiHelper!.apiRequest(
      oneTimePasswordUrl,
      map,
    );
    return compute(otpApiResponseModelFromJson, response);
  }

  Future<CallStoreApiResponseModel?> callStoreApiCall({
    required String callDate,
    required String staffNo,
    required String clientNo,
    required String callType,
    required String duration,
    required String battery,
  }) async {
    String clientSecret =
        await PreferenceHelper.getString(clientSecretPreferenceKey);

    var map = {
      clientSecretKey: clientSecret,
      appVersionCodeKey: "$applicationVersion",
      callDateKey: callDate,
      callStaffNumberKey: staffNo,
      clientNumberKey: clientNo,
      callTypeKey: callType,
      callDurationKey: duration,
      batteryPercentageKey: battery,
      countryCodeKey: "108",
    };

    var response = await apiHelper!.apiRequest(
      callStoreUrl,
      map,
    );
    return compute(callStoreApiResponseModelFromJson, response);
  }
  Future<UserProfileResponseModel?> userProfileApiCall({
    required String phNo,

  }) async {
    String clientSecret =
        await PreferenceHelper.getString(clientSecretPreferenceKey);

    var map = {
      clientSecretKey: clientSecret,
      appVersionCodeKey: "$applicationVersion",
      phoneNumberKey:phNo,
      countryCodeKey: "108",
    };

    var response = await apiHelper!.apiRequest(
      userProfile,
      map,
    );
    return compute(userProfileResponseModelFromJson, response);
  }
}

// To parse this JSON data, do
//
//     final fakeApi = fakeApiFromJson(jsonString);

FakeApi fakeApiFromJson(str) => FakeApi.fromJson(json.decode(str));

String fakeApiToJson(FakeApi data) => json.encode(data.toJson());

class FakeApi {
  int? userId;
  int? id;
  String? title;

  FakeApi({
    this.userId,
    this.id,
    this.title,
  });

  factory FakeApi.fromJson(Map<String, dynamic> json) => FakeApi(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
      };
}
