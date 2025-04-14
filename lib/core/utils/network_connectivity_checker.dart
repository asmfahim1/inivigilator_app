import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkConnection {
  static NetworkConnection? _instance;

  NetworkConnection._();

  static NetworkConnection get instance => _instance ??= NetworkConnection._();
  bool isInternet = true;

  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return true;
      } else {
        return false;
      }
    } on PlatformException {
      return false;
    } catch (e) {
      return false;
    }
  }

  internetAvailable() async {
    isInternet = await hasInternetConnection();
    debugPrint("isInternet1 :: $isInternet");
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.none) {
        isInternet = false;
        debugPrint("isInternet2 :: $isInternet");
      } else {
        isInternet = true;
        debugPrint("isInternet3 :: $isInternet");
      }
    });

    /// This Delay is require for sync the result value with UI.
    /// In iOS first rebuild the UI after that
    /// the Internet value is process thats why we show the connection Error Dialog
    await Future.delayed(const Duration(seconds: 1));
  }
}
