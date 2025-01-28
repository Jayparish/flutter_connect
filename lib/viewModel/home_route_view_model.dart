import 'package:battery_plus/battery_plus.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:photomall_connect/api/api_call.dart';
import 'package:photomall_connect/commonWidgets/base_widget.dart';
import 'package:photomall_connect/commonWidgets/common_button.dart';
import 'package:photomall_connect/utils/battery_utils.dart';
import 'package:photomall_connect/utils/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/common_constants.dart';
import '../controllers/background_task_controller.dart';
import '../controllers/log_out_controller.dart';
import '../controllers/splash_screen_view_model.dart';
import '../preferences/preference_constants.dart';
import '../preferences/preference_helper.dart';

class HomeRouteViewModel extends BaseObserver {
  final BuildContext context;

  HomeRouteViewModel(this.context);

  @override
  void onInternetConnectionBack() {
    // TODO: implement onInternetConnectionBack
  }

  Api api = Api(null);
  ScrollController scrollController = ScrollController();
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  BatteryUtils batteryUtils = BatteryUtils();
  MyTaskHandler myTaskHandler = MyTaskHandler();
  LogOutController logOutController = LogOutController();
  bool isRunning = false;
  final List<Widget> children = <Widget>[];
  bool isLoading = false;

  getInitialValues() async {
    await checkBackgroundTaskRunningOrNot();
    await addCallLogsForView(context);
    //await getPhoneNumbers();
  }

  checkBackgroundTaskRunningOrNot() async {
    bool backgroundTask = await PreferenceHelper.getBool(backgroundTaskKey);
    if (backgroundTask) {
      isRunning = true;
      setBusy(true);
    }
    showLog('backgroundTask model $backgroundTask');
  }

  addCallLogsForView(BuildContext context) async {
    setBusy(true);
    isLoading = true;
    var batteryPercentage = await batteryUtils.getBatteryInfo();
    final Iterable<CallLogEntry> result = await CallLog.get();
    _callLogEntries = result;
    var iterator = _callLogEntries.iterator;
    int count = 0;

    while (iterator.moveNext() && count < 20) {
      CallLogEntry entry = iterator.current;
      String? number =
          ''; //await initSimInfoState(entry!.simDisplayName.toString());

      //myTaskHandler.callbackDispatcher();
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: getIcon(
                  entry.callType.toString().replaceAll('CallType.', '')),
              title: InkWell(
                  onTap: () async {
                    await launchUrl(Uri.parse('tel:${entry.number}'));
                  },
                  child: Text('${entry.number}')),
              trailing: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                        '${getTimeFromTimestamp(DateTime.fromMillisecondsSinceEpoch(entry.timestamp!))}'),
                    IconButton(
                        onPressed: () async {
                          String? url = await getUserProfileFromApi(
                              phNo: entry.number ?? '');
                          if (url != null) {
                            try {
                              launchUrl(Uri.parse(url));
                            } catch (e) {
                              showLog('exception in info $e');
                            }
                          } else {
                            await ToastUtils.getAlert(
                                context, 'User Not Found', Colors.red);
                          }
                        },
                        icon: const Icon(Icons.info)),
                    IconButton(
                        onPressed: () async {
                          String clientNo = entry.number
                              .toString()
                              .replaceAll('91', '')
                              .replaceAll('+', '');
                          clientNo = entry.number
                              .toString()
                              .replaceAll('+91', '')
                              .replaceAll('+', '');
                          String staffNo =
                              await PreferenceHelper.getString(staffNumberKey);
                          var percentage = await batteryUtils.getBatteryInfo();
                          String battery = percentage.toString();
                          showLog('clientNo $clientNo ${clientNo.length}');
                          final RegExp mobileRegExp = RegExp(r'^[6-9]\d{9}$');

                          try {
                            if (clientNo.length == 10 &&
                                mobileRegExp.hasMatch(clientNo)) {
                              var response = await myTaskHandler.callStoreApi(
                                  callDate: DateTime.fromMillisecondsSinceEpoch(
                                          entry.timestamp!)
                                      .toIso8601String(),
                                  staffNo: staffNo,
                                  clientNo: clientNo,
                                  callType: entry.callType!
                                      .toString()
                                      .replaceAll('CallType.', ''),
                                  duration: entry.duration!.toString(),
                                  battery: battery);

                              if (response != null) {
                                await ToastUtils.getSuccessAlert(context,
                                    'call details updated', Colors.green);
                              }
                            } else {
                              await ToastUtils.getAlert(context,
                                  'Please add Valid Mobile Number', Colors.red);
                            }
                          } catch (e) {
                            await ToastUtils.getAlert(
                                context, 'error is $e', Colors.red);
                          }
                        },
                        icon: const Icon(Icons.cloud_upload)),
                  ],
                ),
              ),
            ),
            const Divider(),
            /*  Text(
              ' F. NUMBER  :  ${entry.formattedNumber}',
            ),
            Text(
              ' C.M. NUMBER: ${entry.cachedMatchedNumber}',
            ),
            Text(
              'NUMBER     : ${entry.number}',
            ),
            Text('NAME       : ${entry.name}'),
            Text('TYPE       : ${entry.callType}'),
            Text(
                'DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}'),
            Text('DURATION   : ${entry.duration}'),
            Text('ACCOUNT ID : ${entry.phoneAccountId}'),
            Text('SIM NAME   : ${entry.simDisplayName}'),
            Text('SIM NUMBER   : $number'),*/

            //Text('Battery   : $batteryPercentage%'),
          ],
        ),
      );
      count++;
    }
    showLog('addCallLogsForView $children');
    isLoading = false;

    setBusy(true);
  }

  String getTimeFromTimestamp(DateTime timestamp) {
    final DateFormat formatter =
        DateFormat('hh:mm a'); // 12-hour format with AM/PM
    return formatter.format(timestamp);
  }

  Future<String?> getUserProfileFromApi({required String phNo}) async {
    String filteredNo = phNo.replaceAll('+', '').replaceAll('91', '');
    var response = await api.userProfileApiCall(phNo: filteredNo);
    showLog('getUserProfileFromApi $response');
    if (response != null && response.status != 0) {
      if (response.studioUrls!.isNotEmpty) {
        return response.studioUrls![0];
      } else {
        return response.userUrl;
      }
    } else {
      showLog('user not found');
    }
    return null;
  }

  Icon getIcon(String status) {
    showLog('getIcon $status');
    switch (status) {
      case 'outgoing':
        return const Icon(Icons.call_made);
      case 'missed':
        return const Icon(Icons.call_missed);
      case 'incoming':
        return const Icon(Icons.call_received);
      default:
        return const Icon(Icons.help); // Default icon if status doesn't match
    }
  }

  onPop(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Are you sure want to exit ?'),
              actions: [
                CommonButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    title: 'close'),
                CommonButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    title: 'Back')
              ],
            ));
  }
}
