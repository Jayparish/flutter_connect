// The callback function should always be a top-level function.
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photomall_connect/controllers/splash_screen_view_model.dart';
import 'package:photomall_connect/preferences/preference_helper.dart';
import 'package:photomall_connect/utils/battery_utils.dart';
import 'package:photomall_connect/utils/toast_utils.dart';
import '../api/api_call.dart';
import '../constants/common_constants.dart';
import '../dao/event_listener_dao.dart';
import '../dao/logs_dao.dart';
import '../drift_db/database.dart' as db;
import 'package:drift/drift.dart' as drift;

import '../preferences/preference_constants.dart';

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;
  var num = '';
  BatteryUtils batteryUtils = BatteryUtils();
  EventListenerDao eventListenerDao = EventListenerDao();
  LogsDao logsDao = LogsDao();
  List<db.EventListenerCompanion> eventListenerEntity = [];
  List<db.LogsCompanion> logsEntity = [];

  // Called when the task is started.
  @override
  void onStart(DateTime timestamp) {
    showLog('onStart');
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp) async {
    // Send data to main isolate.
    final Map<String, dynamic> data = {
      "timestampMillis": timestamp.millisecondsSinceEpoch,
    };
    FlutterForegroundTask.sendDataToMain(data);

    var res = await callbackDispatcher();
    var res1 = await batteryUtils.getBatteryInfo();

    showLog('callbackDispatcher ${res?.callType} ');
    showLog('sim');
    //  await upsertEvents();

    await getDifferences();
    await syncWithServer();
    await upsertLogs();

    FlutterForegroundTask.updateService(
      notificationTitle: appName,
      notificationText:
          ' num: ${res?.number} Dur: ${res?.duration}sec \n power :$res1% ${res?.callType}\n ',
    );

    // Send data to the main isolate.


    _eventCount++;
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onDestroy(DateTime timestamp) async {
    showLog('onDestroy');
  }
  // Called when data is sent using [FlutterForegroundTask.sendDataToTask].
  @override
  void onReceiveData(Object data) {
    showLog('onReceiveData: $data');
  }
  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    showLog('onNotificationButtonPressed >> $id');
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }

  Future<CallLogEntry?> callbackDispatcher() async {
    showLog('Background Services are Working!');

    final Iterable<CallLogEntry> cLog = await CallLog.get();
    showLog('Queried call log entries $cLog');
    for (CallLogEntry entry in cLog) {
      showLog('-------------------------------------');
      showLog('F. NUMBER  : ${entry.formattedNumber}');
      showLog('C.M. NUMBER: ${entry.cachedMatchedNumber}');
      showLog('NUMBER     : ${entry.number}');
      showLog('NAME       : ${entry.name}');
      showLog('TYPE       : ${entry.callType}');
      showLog(
          'DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}');
      showLog('DURATION   : ${entry.duration}');
      showLog('ACCOUNT ID : ${entry.phoneAccountId}');
      showLog('ACCOUNT ID : ${entry.phoneAccountId}');
      showLog('SIM NAME   : ${entry.simDisplayName}');
      showLog('-------------------------------------$entry');

      return entry;
    }
    return null;
  }

  callStoreApi({
    required String callDate,
    required String staffNo,
    required String clientNo,
    required String callType,
    required String duration,
    required String battery,
  }) async {
    showLog('call store  api $callDate ');
    Api api = Api(null);
    var response = await api.callStoreApiCall(
      battery: battery,
      callDate: callDate,
      callType: callType,
      clientNo: clientNo.replaceAll('+', ''),
      staffNo: staffNo,
      duration: duration,
    );

    if (response != null) {
      return response.status;
    }
    return null;
  }

  static const MethodChannel _channel =
      MethodChannel('com.example/background_tasks');

  static Future<void> registerBootReceiver() async {
    try {
      await _channel.invokeMethod('registerBootReceiver');
    } on PlatformException catch (e) {
      print("Failed to register boot receiver: '${e.message}'.");
    }
  }

  syncLogsWithServer() async {
    List<db.Log> logs = await logsDao.getLogsWhereNotSynced();
    showLog('syncLogsWithServer length  ${logs.length}');
    String staffNo = await PreferenceHelper.getString(staffNumberKey);
    if (logs.isNotEmpty) {
      for (db.Log log in logs) {

        var dbLog = CallLogJson.fromJson(json.decode(log.callLog));
        showLog('syncLogsWithServer string date ${dbLog.date.toString()}');
        String clientNo = dbLog.number.toString().replaceAll('91', '');
         clientNo = dbLog.number.toString().replaceAll('+91', '');
         clientNo = dbLog.number.toString()..replaceAll('+', '');
         clientNo = dbLog.number.toString().replaceAll(' ', '');
        showLog('client no length is ${clientNo.length} ');

        if (clientNo.length > 10 ) {
          clientNo = clientNo.substring(clientNo.length - 10);
        }
        final RegExp mobileRegExp = RegExp(r'^[6-9]\d{9}$');

        showLog('  client no length is ${mobileRegExp.hasMatch(clientNo)}  ');
        if(clientNo.length == 10 && mobileRegExp.hasMatch(clientNo)) {
          var response = await callStoreApi(
              callDate: dbLog.date.toString(),
              staffNo: staffNo,
              clientNo: clientNo,
              callType: dbLog.callType!.toString().replaceAll('CallType.', ''),
              duration: dbLog.duration!,
              battery: dbLog.battery!.toString());

          if (response != null) {
            await logsDao.updateSyncedStatus(log.id);
          }
        }else{
          Fluttertoast.showToast(
              msg: "${clientNo.length}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );
          showLog('Number must be 10 digits');
          await logsDao.updateSyncedStatus(log.id);

          await logsDao.deleteEventById(log.id);
        }
      }
    } else {
      showLog('already synced');
    }
  }

  upsertLogs() async {
    CallLogEntry? entry = await callbackDispatcher();
    BatteryUtils batteryUtils = BatteryUtils();
    var percentage = await batteryUtils.getBatteryInfo();
    String battery = percentage.toString();
    String? number =
        ''; //await initSimInfoState(entry!.simDisplayName.toString());
    Map<String, dynamic> entryMap =  callLogEntryToMap(entry!);
    entryMap['simNumber'] = number;
    entryMap['battery'] = battery;
    String jsonString = json.encode(entryMap);
    showLog('get battery $jsonString');
    logsEntity.add(db.LogsCompanion(
        callLog: drift.Value(jsonString),
        syncedStatus: const drift.Value(false)));
    List<db.Log> logs = await logsDao.getCallLog();
    if (logs.isNotEmpty) {
      Map<String, dynamic> jsonMapOld = jsonDecode(logs![0].callLog);
      CallLogJson callLogNew = CallLogJson.fromJson(entryMap);
      CallLogJson callLogOld = CallLogJson.fromJson(jsonMapOld);

      showLog('CallLog$jsonMapOld ${callLogOld.date} ,,,,, ${callLogNew.date}');
      if (callLogOld.date != callLogNew.date) {
        if (logsEntity.isNotEmpty) {
          await logsDao.insertLogs(logsEntity);
          logsEntity.clear();

          showLog('upsertLogs successfully');
        }
      } else {
        showLog('already updated');
        logsEntity.clear();
      }
    } else {
      await logsDao.insertLogs(logsEntity);
      logsEntity.clear();
      showLog('first updated');
    }
    await syncLogsWithServer();
  }

/*
  upsertEvents() async {


    final currentDate = DateTime.now().day.toString();
    var lastDay = await PreferenceHelper.getString(currentDateKey) ?? '';
    showLog('lastDay----->$lastDay $currentDate');
    if (currentDate != lastDay) {
      ///delete event listener table
      await eventListenerDao.deleteEventListenerTable();
      showLog(' EventListenerTable deleted ');
      await PreferenceHelper.setString(currentDateKey, currentDate);
      await PreferenceHelper.setDateTime(durationKey, DateTime.now());
      eventListenerEntity.add(db.EventListenerCompanion(
          aliveCondition: const drift.Value(true),
          createdAt: drift.Value(DateTime.now()),
          differences: const drift.Value(false)));
    }

    DateTime dateTime1 = DateTime.now(); // Example DateTime 1
    DateTime? dateTime2 = await PreferenceHelper.getDateTime(durationKey);

    Duration? difference = dateTime2?.difference(dateTime1);
    showLog(
        'dateTime1-----> $dateTime1 ,dateTime2-----> $dateTime2 , mini --- >${difference?.inMinutes}');

    if(difference?.inMinutes == -5){
      showLog('difference?.inMinutes ${difference?.inMinutes}');
      eventListenerEntity.add(db.EventListenerCompanion(
          aliveCondition: const drift.Value(true),
          createdAt: drift.Value(DateTime.now()),
          differences: const drift.Value(false)));
      await eventListenerDao.insertEvents(eventListenerEntity);
      await PreferenceHelper.setDateTime(durationKey, DateTime.now());
      eventListenerEntity.clear();
    }


  }
*/


  syncWithServer() async {
    List<db.EventListenerData> events =
        await eventListenerDao.getEventsWhereNotSynced();
    showLog('syncWithServer ${events.length}\n ${events}');
    if (events != null && events.isNotEmpty) {
      for (db.EventListenerData event in events) {
        var response = '';
        if (response != null) {
          await eventListenerDao.updateSyncedStatus(event.id);
          showLog('syncWithServer updated');
        }
      }
      events.clear();
    } else {
      showLog('events are empty');
    }
  }

  getDifferences() async {
    var lastInTime = await PreferenceHelper.getString(lastInTimeKey);
    if (lastInTime != 'last_inTime_key' && lastInTime != '') {
      showLog('getDifferences if $lastInTime');
      DateTime dateTime1 = DateTime.parse(lastInTime); // Example DateTime 1
      DateTime dateTime2 = DateTime.now(); // Example DateTime 2
      Duration difference = dateTime2.difference(dateTime1);
      showLog(
          'Difference in inMinutes: $dateTime1 \n$dateTime2 ,,,,${difference.inMinutes},${difference.inSeconds} ');
      if (difference.inMinutes > 1) {
        showLog('differences occurred');
        eventListenerEntity.add(db.EventListenerCompanion(
            inTime: drift.Value(dateTime2.toString()),
            outTime: drift.Value(dateTime1.toString()),
            sync: const drift.Value(false)));
        await eventListenerDao.insertEvents(eventListenerEntity);
        await PreferenceHelper.setString(
            lastInTimeKey, DateTime.now().toString());
      } else {
        showLog('no differences occurred');

        await PreferenceHelper.setString(
            lastInTimeKey, DateTime.now().toString());
      }
    } else {
      showLog('getDifferences else');
      await PreferenceHelper.setString(
          lastInTimeKey, DateTime.now().toString());
    }
  }

  Map<String, dynamic> callLogEntryToMap(CallLogEntry entry) {
    return {
      'formattedNumber': "${entry.formattedNumber}",
      'cachedMatchedNumber': "${entry.cachedMatchedNumber}",
      'number': entry.number.toString().replaceAll('91', ''),
      'name': "${entry.name}",
      'callType': entry.callType.toString()..replaceAll('CallType.', ''),
      'date': DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)
          .toIso8601String(),
      'duration': "${entry.duration}",
      'phoneAccountId': "${entry.phoneAccountId}",
      'simDisplayName': "${entry.simDisplayName}",
    };
  }
}

class CallLogJson {
  String? formattedNumber;
  String? cachedMatchedNumber;
  String? number;
  String? name;
  String? date;
  String? callType;
  int? timestamp;
  String? duration;
  String? phoneAccountId;
  String? simDisplayName;
  String? callDateTime;
  String? battery;

  CallLogJson({
    this.formattedNumber,
    this.cachedMatchedNumber,
    this.number,
    this.name,
    this.date,
    this.callType,
    this.timestamp,
    this.duration,
    this.phoneAccountId,
    this.simDisplayName,
    this.callDateTime,
    this.battery,
  });

  factory CallLogJson.fromJson(Map<String, dynamic> json) {
    return CallLogJson(
      formattedNumber: json['formattedNumber'],
      cachedMatchedNumber: json['cachedMatchedNumber'],
      number: json['number'],
      name: json['name'],
      date: json['date'],
      callType: json['callType'],
      timestamp: json['timestamp'],
      duration: json['duration'],
      phoneAccountId: json['phoneAccountId'],
      simDisplayName: json['simDisplayName'],
      callDateTime: json['callDateTime'],
      battery: json['battery'],
    );
  }
}
