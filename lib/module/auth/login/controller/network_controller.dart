// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:invigilator_app/core/utils/dialogue_utils.dart';
//
// class NetworkController extends GetxController {
//   final _connectionStatusInt = 0.obs;
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
//
//   int get connectionStatus => _connectionStatusInt.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     initConnectivity();
//     _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }
//
//   Future<void> initConnectivity() async {
//     List<ConnectivityResult> result;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       result = await _connectivity.checkConnectivity(); // Wrap the result in a list
//     } on PlatformException catch (e) {
//       throw "Error occurred $e";
//       // return;
//     }
//
//     return _updateConnectionStatus(result); // Pass the list to the update function
//   }
//
//   void _updateConnectionStatus(List<ConnectivityResult> result) {
//     // Iterate through the list of ConnectivityResult
//     bool isConnected = false;
//     for (var connectivity in result) {
//       if (connectivity == ConnectivityResult.wifi || connectivity == ConnectivityResult.mobile) {
//         isConnected = true;
//         break;
//       }
//     }
//
//     // Update the connection status based on the result
//     if (isConnected) {
//       _connectionStatusInt.value = 1;
//     } else {
//       _connectionStatusInt.value = 0; // No Internet
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         DialogUtils.showSnackBar('warning'.tr, 'no_internet'.tr);
//       });
//     }
//   }
//
//   @override
//   void onClose() {
//     _connectivitySubscription.cancel();
//     super.onClose();
//   }
// }