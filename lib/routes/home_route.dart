import 'dart:io';
import 'dart:isolate';

import 'package:call_log/call_log.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter/material.dart';
import 'package:photomall_connect/commonWidgets/common_app_bar.dart';
import 'package:photomall_connect/commonWidgets/common_text.dart';
import 'package:photomall_connect/preferences/preference_helper.dart';
import 'package:photomall_connect/viewModel/home_route_view_model.dart';

import '../api/api_call.dart';
import '../commonWidgets/base_widget.dart';
import '../commonWidgets/menu_pop_up.dart';
import '../constants/common_constants.dart';
import '../constants/route_paths_constants.dart';
import '../controllers/background_task_controller.dart';
import '../preferences/preference_constants.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class _HomeRouteState extends State<HomeRoute> {
  ReceivePort? _receivePort;
  MyTaskHandler myTaskHandler = MyTaskHandler();
  BaseWidget<HomeRouteViewModel>? baseWidget;

  final Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      // This function requires `android.permission.SYSTEM_ALERT_WINDOW` permission.
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    // Android 12 or higher, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
    final NotificationPermission notificationPermissionStatus =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        //foregroundServiceType: AndroidForegroundServiceType.DATA_SYNC,
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,


      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<ServiceRequestResult> _startForegroundTask() async {
    var res = await myTaskHandler.callbackDispatcher();
    showLog('message is $res');
    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;


    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: 256,

        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  Future<ServiceRequestResult> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) async {
      if (data is int) {
        showLog('eventCount: $data');
      } else if (data is String) {
        if (data == 'onNotificationPressed') {
          if (!context.mounted) return;
          Navigator.of(context).pushNamed(RoutePaths.home);
        }
      } else if (data is DateTime) {
        showLog('timestamp: ${data.toString()}');
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionForAndroid();
      _initForegroundTask();
      _startForegroundTask();
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget(
      model: HomeRouteViewModel(context),
      onModelReady: (model) async {
        await model.getInitialValues();
      },
      builder: (context, model, child) {
        return WithForegroundTask(
          child: Scaffold(
            //backgroundColor: const Color(photomallConnectColour),
            appBar: CommonAppBar(
              isAppBarTitleWidget: true,
              isMainPage: true,
              title: appName,
              actions: [
                MenuPopUp(
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      onPressed: () async {
                        showLog('logOutController init');
                        _stopForegroundTask();
                        await model.logOutController.setLogOut(context);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      label: const CommonText(
                        text: 'Logout',
                        styleFor: 'card',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: (/*model.isRunning != true*/ false)
                ? introScreen()
                : DoubleBackToCloseApp(
                    snackBar: const SnackBar(
                      content:
                          Text('Press back again to exit the $appName app'),
                    ),
                    child: buildContentView(model)),
          ),
        );
      },
    );
    return baseWidget!;
  }

  Widget buildContentView(HomeRouteViewModel model) {
    buttonBuilder(String text, {VoidCallback? onPressed}) {
      return ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Center(
        child: model.isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                controller: model.scrollController,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (model.children.isNotEmpty)
                        ? model.children
                        : [
                            const CommonText(
                              text: 'No Logs Found..',
                              styleFor: 'body',
                            )
                          ]),
              ),
      ),
    );
  }

  Widget introScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/photomall_logo.png',
              height: 200,
            ),
            ElevatedButton(
                onPressed: () async {
                  await PreferenceHelper.setBool(backgroundTaskKey, true);
                  _startForegroundTask();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    RoutePaths.home,
                  );
                },
                child: const Text('Lets begin')),
          ],
        ),
      ),
    );
  }
}
