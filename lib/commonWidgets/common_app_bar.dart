import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photomall_connect/commonWidgets/common_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/common_constants.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  CommonAppBar({
    Key? key,
    this.title,
    this.isMainPage = false,
    this.actions = const [SizedBox()],
    this.isTransparentAppBar = false,
    this.isAppBarTitleWidget = false,
    this.titleWidget,
    this.isCenterTitle = false,
    this.isTransparent = false,
    this.menuKey,
    this.qrKey,
  });
  final Key? menuKey;
  final Key? qrKey;
  final double preferredHeight = 80.0;
  final String? title;
  final bool isMainPage;
  final List<Widget> actions;
  final bool isTransparentAppBar;
  final bool isAppBarTitleWidget;
  final Widget? titleWidget;
  final bool isCenterTitle;
  final bool isTransparent;

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight); // default is 56.0

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);
  List<Widget> actions = [
    SizedBox(),

    /*Container(
      height: 50,
      width: 50,
      color: Colors.blue,
    )*/
  ];
  StreamSubscription? listener;
  //var keyMenu = GlobalKey();
  // var keyQr = GlobalKey();
  //var keyChat = GlobalKey();

  @override
  void initState() {
    showLog("Common appbar connection:: checkInternetConnectivity showing");
    checkInternetConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    //...
    super.dispose();
    listener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            AppBar(
              centerTitle: widget.isCenterTitle,
              titleSpacing: -5,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              actions: actions,
              // pinned: true,
              // expandedHeight: 60,
              flexibleSpace: widget.isTransparent
                  ? Container(
                color: Colors.black,
              )
                  : Container(
                height: 100,
                decoration: BoxDecoration(
        
                ),
              ),
              // title of appbar
              title: CommonText(
                text:'${widget.title}' ?? "",styleFor: 'title',
              ),
              elevation: 0,
        
              leading: widget.isMainPage
                  ? Row(
                    children: [
                      SizedBox(width: 5,),
                      Image.asset('assets/images/photomall_logo.png',height: 30,),
                    ],
                  )
                  : null,
              iconTheme: IconThemeData(color: Colors.blue),
        
            ),
          ],
        ),
      ),
    );
  }

/*  Future<bool> isLoggedIn() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool('$isUserLoggedInPreferenceKey') ?? false;
  }*/

  Future<void> checkInternetConnectivity() async {
    showLog("app bar internet method ");

    InternetConnectionStatus data =
    await InternetConnectionChecker().connectionStatus;

    if (data == InternetConnectionStatus.connected ||
        widget.isMainPage == true) {

      actions = widget.actions;
      setState(() {});
    } else {
      actions = [
        //SizedBox(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.red,
                        width: 2,
                      )),
                  child: const Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 20,
                          color: Colors.yellow,
                        ),
                        /*CommonText(
                          text: " Offline",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.red),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ];
      setState(() {});
    }
    listener = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          {
            if (widget.isMainPage == true) {
              //actions = widget.actions;
            } else {
              actions = widget.actions;
            }
            /*actionss = [
              Container(
                height: 50,
                width: 50,
                color: Colors.green,
                child: Text("data"),

              )
            ];*/
            setState(() {});
            isConnected.value = true;
            showLog(
                "main common appbar true data <> :: ${isConnected.value} :: $status");
          }
          break;
        case InternetConnectionStatus.disconnected:
          {
            actions = [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          /*border: Border.all(
                              color: Colors.red,
                              width: 2,
                            )*/
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_off,
                                size: 20,
                                color: Colors.yellow,
                              ),
                              /*  CommonText(
                                text: " Offline",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.red),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
            setState(() {});
            isConnected.value = false;
            showLog(
                "main common appbar false data >> :: ${isConnected.value} :: $status");
          }
          break;
      }
    });
  }
}
