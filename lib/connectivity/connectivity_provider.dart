import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../constants/common_constants.dart';

class ConnectivityProvider with ChangeNotifier{
  bool ? _isOnline;
  bool get isOnline => _isOnline ?? true;

  ConnectivityProvider(){
    Connectivity connectivity = Connectivity();

    connectivity.onConnectivityChanged.listen((result) async{
      InternetConnectionStatus data =
      await InternetConnectionChecker().connectionStatus;
      showLog("the internet connection $data");
      if(data == InternetConnectionStatus.connected){
        _isOnline = true;
        notifyListeners();
      }else{
        _isOnline = false;
        notifyListeners();
      }
    });
  }
}



class InternetChecker{
  bool hasInternet = false;

  InternetChecker();

  networkChecker({required Function onTap,required BuildContext context}) async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet) {
      showLog("Internet permission granted to archived $hasInternet");
      onTap();
    }
    else{
      showLog("Internet permission denied");
      //ToastUtil toast = ToastUtil();
      //ToastContext().init(context);
      //toast.showShortToast(context, S.of(context).yourOffline);
      return;
    }
  }

  Future<bool>checkConnectivity() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    InternetConnectionStatus data =
    await InternetConnectionChecker().connectionStatus;
    if (hasInternet) {
      return true;
    }
    else{return false;}
  }

}