import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim_number_picker/sim_number_picker.dart';
import 'package:simnumber/sim_number.dart';
import 'package:simnumber/siminfo.dart';

import '../api/api_call.dart';
import '../api/api_response_models/device_register_response_model.dart';
import '../commonWidgets/base_widget.dart';
import '../constants/common_constants.dart';
import '../constants/route_paths_constants.dart';
import '../preferences/preference_constants.dart';
import '../preferences/preference_helper.dart';
import '../utils/device_utils.dart';

class SplashScreenController extends BaseObserver {
  BuildContext context;
  //ApiHelper? apiHandler;
  //Api? apiRepo;

  SplashScreenController({
    required this.context,
    //this.apiHandler,
  }) {
    //apiRepo = Api(context);
  }

  bool isLoading = false;
  String deviceId = "";

  bool devRegStatus = false;

  Future<void> getInitialValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.clear();
    Api apis =
    Api(context);
    /*await apis.callStoreApiCall(
        staffNo: '56456456',
        duration: '121',
        clientNo: '5455454',
        callType: 'sdsdsd',
        callDate: 'sjdsdjdhj',
        battery: 'sddsd');*/
    isLoading = true;
    bool isDeviceRegistred = await getDeviceRegisterStatus();
     //printSimCardsData();
    if (!isDeviceRegistred) {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      showLog("close the app");
    }


    var res = await PreferenceHelper.getBool(isLoggedInPreferenceKey);
    showLog('is logged in $res');

    Timer(const Duration(seconds: 5), () {
      isLoading = false;
      (!res)
          ? {
        Navigator.pop(context),
        Navigator.pushNamed(
        context,
        RoutePaths.login,

      )}
          : {
        Navigator.pop(context),
        Navigator.pushNamed(
        context,
        RoutePaths.home,
      ),

      };
    });
  }

  @override
  void onInternetConnectionBack() {
    // TODO: implement onInternetConnectionBack
  }

  Future<bool> getDeviceRegisterStatus() async {
    DateTime date = DateTime.parse("2023-06-07 18:18:44.115648");
    int epochDate = date.millisecondsSinceEpoch;
    showLog("Date time $date \n epoch : $epochDate");

    try {
      devRegStatus =
      await PreferenceHelper.getBool(isDeviceRegisteredPreferenceKey);
      if (!devRegStatus) {
        showLog("Device Registering ...");
        DeviceUtil deviceUtil = DeviceUtil();
        Map<String, dynamic>? deviceMap = await deviceUtil.getDeviceMap();
        DeviceRegisterResponseModel? response =
        await Api(context).devRegApiCall(deviceMap!);
        if (response != null && response.data != null) {
          showLog(
              'the device id where >> {deviceMap["device"]["desktop_device_uuid"]}');
          /*await PreferenceHelper.setString(deviceIdPreferenceKey,
              deviceMap["device"]["desktop_device_uuid"]);*/
          await PreferenceHelper.setBool(isDeviceRegisteredPreferenceKey, true);
          await PreferenceHelper.setString(
              clientSecretPreferenceKey, response.data!.clientSecret!);
        }
      } else {
        showLog("Device already Registered ...");
      }
      return true;
    } catch (e,s) {
      showLog("the error is $s");
      return false;
    }
  }
  void printSimCardsData() async {

    try {
      SimInfo simInfo = await SimNumber.getSimData();
      var phoneNumber;
      for (var s in simInfo.cards) {
        phoneNumber = s.phoneNumber!;
        phoneNumber = phoneNumber.replaceFirst(RegExp(r'^\+?91'), '');
        print('Serial number: ${s.slotIndex} ${s.phoneNumber}');

      }

    } on Exception catch (e) {
      print("error! code: ${e.toString()} - message: ${e.toString()}");
    }
  }
}

Future<String> getPhoneNumbers() async {
  showLog('getPhoneNumbers getPhoneNumbers ');

  final _simNumberPickerPlugin = SimNumberPicker();
  String phoneNumber;
  // Platform messages may fail, so we use a try/catch PlatformException.
  // We also handle the message potentially returning null.
  try {
    phoneNumber = await _simNumberPickerPlugin.getPhoneNumberHint() ??
        'Unknown platform version';
  } on PlatformException {
    phoneNumber = 'Failed to get platform version.';
  }
showLog('getPhoneNumbers getPhoneNumbers $phoneNumber');
  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
  return phoneNumber;

}

Future<void> _checkPhonePermission() async {
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    // Request the permission
    if (await Permission.phone.request().isGranted) {
      // Permission is granted
      showLog("Phone permission granted");
    } else {
      // Permission is denied
      showLog("Phone permission denied");
    }
  } else {
    // Permission is already granted
    showLog("Phone permission already granted");
  }
}
/*
Future<String?> initSimInfoState(String slotIndex) async {
  //await _checkPhonePermission();
   String index = slotIndex;
  final simCardInfoPlugin = SimCardInfo();
  List<SimInfo>? simCardInfo;
  String ? phoneNumber;
  // Platform messages may fail, so we use a try/catch PlatformException.
  // We also handle the message potentially returning null.
  if(!slotIndex.contains('sim')){
    index = '0';
  }
  if(slotIndex.contains('1')){
    index = '0';
  }else{
    index ='1';
  }
  index.replaceAll('sim', '');
  try {
    simCardInfo = await simCardInfoPlugin.getSimInfo() ?? [];
    showLog('initSimInfoStatesimCardInfo $simCardInfo');

    for(SimInfo simInfo in simCardInfo){
      showLog('initSimInfoState ${simInfo.number}');

      if(simInfo.slotIndex==index){
        phoneNumber=simInfo.number;
      }else{
        phoneNumber=simInfo.number;
      }
    }
    return phoneNumber;
  } on PlatformException {
    simCardInfo = [];
    showLog('initSimInfoState PlatformException ');

  }
}*/
