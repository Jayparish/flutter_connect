import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/common_constants.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final T model;
  final Widget? child;
  final Function(T) onModelReady;

  const BaseWidget({
    Key? key,
    required this.builder,
    required this.model,
    this.child,
    required this.onModelReady,
  }) : super(key: key);

  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  T? model;

  @override
  void initState() {
    model = widget.model;

    widget.onModelReady(model!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return ChangeNotifierProvider<T>(
    //create: (context) => model,
    return ChangeNotifierProvider<T>.value(
      value: model!,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

//class for observing internet availability to call api once connection back
abstract class BaseObserver extends BaseModel {
  NetworkBroadcast networkBroadcast = NetworkBroadcast();
  bool isNetworkFailed = false;
  bool started = false; //to avoid second time start to listen internet

  void startNetworkCheck() {
    if (started == false) {
      started = true;
      networkBroadcast.start((hasConnection) async {
        if ((hasConnection == true) && (isNetworkFailed = true)) {
          print("hasConnection :: api $hasConnection");
          networkBroadcast.stop();
          onInternetConnectionBack();
        }
        print("hasConnection :: normal $hasConnection");
      });
    }
  }

  void onInternetConnectionBack();

  void destroy() {
    networkBroadcast.stop();
  }
}

class BaseModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  bool isDisposed = false;

  setBusy(bool value) {
    _busy = value;
    showLog("state: $_busy");
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    showLog('dispose :: base model');
    isDisposed = true;
    super.dispose();
  }
}

class NetworkBroadcast {
  var listener;

  Future<void> start(Function(bool) callback) async {
    /*
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          {
            callback(true);
          }
          break;
        case DataConnectionStatus.disconnected:
          callback(false);
          break;
      }
    });
  */
  }
  void stop() {
    if (listener != null) {
      listener.cancel();
    }
  }
}
