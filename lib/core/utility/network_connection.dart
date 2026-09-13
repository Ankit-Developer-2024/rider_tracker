
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rider_tracker/core/utility/utils.dart';


class NetworkConnection {

  static Future<bool> isConnected({bool dataConnectionCheck = false}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    try{
      if (connectivityResult[0] == ConnectivityResult.mobile) {
        return dataConnectionCheck ? await _dataConnectionChecker() : true;
      } else if (connectivityResult[0] == ConnectivityResult.wifi) {
        return dataConnectionCheck ? await _dataConnectionChecker() : true;
      } else if (connectivityResult[0] == ConnectivityResult.vpn) {
        return dataConnectionCheck ? await _dataConnectionChecker() : true;
      } else {
        return false;
      }
    }catch(exception){
      appLog(exception.toString());
      return false;
    }
  }

  static Future<bool> _dataConnectionChecker() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      appLog('not connected');
      return false;
    }
  }


}