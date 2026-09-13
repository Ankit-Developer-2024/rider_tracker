import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rider_tracker/core/components/dialog/location_permission_dialog.dart';

class LocationPermissionHelper {

  static Future<void> checkLocationPermission()async{
    final PermissionStatus permissionStatus=await Permission.locationWhenInUse.status;
    if(permissionStatus==PermissionStatus.granted){
      final PermissionStatus locationPermission = await Permission.locationAlways.status;
      if(locationPermission == PermissionStatus.permanentlyDenied){
       await Get.dialog(const LocationPermissionAlertBox(),barrierDismissible: false);
      }else if(locationPermission == PermissionStatus.denied){
        await Permission.locationAlways.request();
        await checkLocationPermission();
      }
    }else if(permissionStatus!=PermissionStatus.granted){
      final PermissionStatus locationPermission = await Permission.locationWhenInUse.request();
      if(locationPermission == PermissionStatus.permanentlyDenied){
        await Get.dialog(const LocationPermissionAlertBox(),barrierDismissible: false);
      }else if(locationPermission == PermissionStatus.denied){
        await Permission.locationWhenInUse.request();
        await checkLocationPermission();
      }
    }
  }

  static Future<bool> checkIsLocationPermissionEnable()async{
    final PermissionStatus permissionStatus=await Permission.locationAlways.status;
    return permissionStatus==PermissionStatus.granted;
  }

}