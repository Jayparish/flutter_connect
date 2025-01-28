import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photomall_connect/routeSetup/custom_route.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'connectivity/connectivity_provider.dart';
import 'constants/common_constants.dart';
import 'constants/route_paths_constants.dart';
import 'controllers/background_task_controller.dart';
import 'drift_db/database.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterForegroundTask.initCommunicationPort();

  //MyTaskHandler myTaskHandler = MyTaskHandler();
 // var res = await myTaskHandler.callbackDispatcher();
  //showLog('get permission $res');

  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  HttpOverrides.global = MyHttpOverrides();
  startApplication();
}

startApplication() async {
  //await Firebase.initializeApp();
 // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  showLog('fcm  token $fcmToken');
  showLog(' notification step 1 :: ');
  try {
    final dbFolder = await getApplicationDocumentsDirectory();

    File dbFile = File('$dbFolder/photomallConnectDb.sqlite');
    if (dbFile.existsSync()) {
      showLog("yes the file is exist >>");
      dbFile.deleteSync();
    } else {
      showLog("yes the file is not exist >>${DateTime.now()}");
    }
  } catch (e) {
    showLog("Can't delete database $e");
  }
  try {
    AppDatabase database = AppDatabase();

    await (database.select(database.eventListener)).get();
  } catch (e) {
    showLog('Exception while activate database $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider.value(
            value: true,
          ),
          ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ],
        child: Consumer<ConnectivityProvider>(
          builder: (context, model, widget) {
            return ToastificationWrapper(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateRoute: CustomRoute.generateRoute,
                initialRoute: RoutePaths.splash,
                theme: ThemeData(
                    fontFamily: 'OpenSans',
                    textTheme: Theme.of(context)
                        .textTheme
                        .apply(fontFamily: 'OpenSans')),
              ),
            );
          },
        ));
  }

}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
