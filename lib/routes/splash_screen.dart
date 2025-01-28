import 'package:flutter/material.dart';

import '../commonWidgets/base_widget.dart';
import '../constants/common_constants.dart';
import '../controllers/splash_screen_view_model.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BaseWidget<SplashScreenController>? baseWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLog("Splash screen view");

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    baseWidget = BaseWidget<SplashScreenController>(
      model: SplashScreenController(context: context),
      onModelReady: (model) => model.getInitialValues(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            showLog("poping");
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            body: showSplash(height, width, model),
          ),
        );
      },
    );
    return baseWidget!;
  }

  showSplash(double height, double width, SplashScreenController model) {
    return Container(
      color: const Color(photomallConnectBgColour),
      height: height,
      width: width,
      child: Center(child: Image.asset('assets/images/photomall_logo.png',height: 350,)
      ),
    );
  }
}
