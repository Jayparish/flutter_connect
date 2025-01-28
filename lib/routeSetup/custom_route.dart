import 'package:flutter/material.dart';
import 'package:photomall_connect/routes/splash_screen.dart';
import 'package:provider/provider.dart';
import '../connectivity/connectivity_provider.dart';
import '../constants/common_constants.dart';
import '../constants/route_paths_constants.dart';
import '../routes/home_route.dart';
import '../routes/login_route.dart';

class CustomRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      final isOnLine = Provider.of<ConnectivityProvider>(context).isOnline;
      showLog("the internet onlin $isOnLine");
      if (!isOnLine) {
        return const SplashScreen();
      } else {
        switch (settings.name) {
          case RoutePaths.splash:
            return const SplashScreen();
          case RoutePaths.home:
            return const HomeRoute();
          case RoutePaths.login:
            return const LoginRoute();
          default:
            return Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            );
        }
      }
    });
  }
}
