import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../constants/common_constants.dart';
import '../preferences/preference_constants.dart';
import '../preferences/preference_helper.dart';

class DeviceUtil {

  Future<Map<String, dynamic>?> getDeviceMap() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic>? deviceMap;
    String deviceId;
    try {
      if (DeviceUtils.isWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        showLog('kIsWeb true');
        deviceMap = {
          "app": {
            "device": {
              "name": webBrowserInfo.appName,
              "android_version": webBrowserInfo.appVersion,
              "device_manufacturer": webBrowserInfo.vendor
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {"type": "android_device", "id": "3"},
            {"type": "notification", "id": "sad"}
          ]
        };
      }

      else if (Platform.isAndroid) {
        //get android device info
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        await PreferenceHelper.setString(
            deviceIdPreferenceKey, androidInfo.id.toString());
        deviceId = androidInfo.id.toString();
        deviceMap = {
          "app": {
            "device": {
              "name": androidInfo.device.toString(),
              "android_version": androidInfo.version.sdkInt.toString(),
              "device_manufacturer": androidInfo.manufacturer.toString(),
              "android_device": deviceId,
              "fcm_notification_token":
              await FirebaseMessaging.instance.getToken()
              //await FirebaseMessaging.instance.getToken(),
            }
          },
        /*  "attributes": [
            {"type": "google_ad", "id": "asd"},
            {
              "type": "android_device",
              "id": deviceId,
            },
            //{"type": "notification", "id": "sad"},
            {
              "type": "fcm",
              //"id": await FirebaseMessaging.instance.getToken(),
              "id": "sddf"
            },
          ],*/
        };
      }
      else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        await PreferenceHelper.setString(
            deviceIdPreferenceKey, iosInfo.identifierForVendor.toString());
        deviceId = iosInfo.identifierForVendor.toString();
        deviceMap = {
          "app": {
            "device": {
              "name": iosInfo.name.toString(),
              "android_version": iosInfo.systemVersion.toString(),
              "device_manufacturer": "Apple",
              "android_device": deviceId,
              "fcm_notification_token": await FirebaseMessaging.instance.getToken()
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {
              "type": "android_device",
              "id": iosInfo.identifierForVendor.toString()
            },
            {"type": "notification", "id": "sad"}
          ]
        };
      }
      else if (Platform.isLinux) {
        //need to change default to dynamic
        LinuxDeviceInfo linuxDeviceInfo = await deviceInfo.linuxInfo;
        deviceMap = {
          "app": {
            "device": {
              "name": linuxDeviceInfo.name,
              "android_version": linuxDeviceInfo.version,
              "device_manufacturer": "Linux"
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {"type": "android_device", "id": "2"},
            {"type": "notification", "id": "sad"}
          ]
        };
      }
      else if (Platform.isWindows) {
        //need to change default to dynamic
        WindowsDeviceInfo windowsDeviceInfo = await deviceInfo.windowsInfo;
        deviceMap = {
          "app": {
            "device": {
              "name": windowsDeviceInfo.computerName,
              "android_version": windowsDeviceInfo.numberOfCores,
              "device_manufacturer": "Windows"
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {"type": "android_device", "id": "2"},
            {"type": "notification", "id": "sad"}
          ]
        };
      }
      else if (Platform.isMacOS) {
        //need to change default to dynamic
        MacOsDeviceInfo macDeviceInfo = await deviceInfo.macOsInfo;
        deviceMap = {
          "app": {
            "device": {
              "name": macDeviceInfo.computerName,
              "android_version": macDeviceInfo.osRelease,
              "device_manufacturer": "Mac"
            }
          },
          "attributes": [
            {"type": "google_ad", "id": "asd"},
            {"type": "android_device", "id": "2"},
            {"type": "notification", "id": "sad"}
          ]
        };
      }
      else {}

      // //Device Register Api request
      // var apiHandler = Provider.of<ApiHelper>(context, listen: false);
      // var response = await apiHandler.apiJsonRequest(
      //     deviceRegisterUrl, deviceMap, context);
      // return compute(deviceRegisterModelFromJson, response);
    } catch (e,s) {
      showLog('exception on device register: $s');
    }
    return deviceMap;
  }
}


class DeviceUtils {

  static bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);

  static bool get isMobile => !isWeb && (isAndroid || isIOS);

  static bool get isWeb => kIsWeb;

  static bool get isWindows => Platform.isWindows;

  static bool get isLinux => Platform.isLinux;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isAndroid => Platform.isAndroid;

  static bool get isFuchsia => Platform.isFuchsia;

  static bool get isIOS => Platform.isIOS;


}