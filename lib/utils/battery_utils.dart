

import 'package:battery_plus/battery_plus.dart';

import '../constants/common_constants.dart';


class BatteryUtils{

 Future<int> getBatteryInfo() async {
    final Battery battery = Battery();

    var res = await battery.batteryLevel;
    showLog('battery power is $res');
    return res;
  }
}