import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:rider_tracker/core/routing/app_routes.dart';
import 'package:rider_tracker/core/services/live_location_service.dart';
import 'package:rider_tracker/core/utility/helpers/location_permission_helper.dart';
import 'package:rider_tracker/core/utility/utils.dart';

class HomeController  extends GetxController {

  final Location _location = Location();

  RxBool isLocationPermissionEnable = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();

  }

  void checkLocationPermission()async{
    try{
      bool checkIsLocationPermissionEnable=await LocationPermissionHelper.checkIsLocationPermissionEnable();
      if(!checkIsLocationPermissionEnable){
        await LocationPermissionHelper.checkLocationPermission();
      }else {
        bool isServiceEnabled = await LiveLocationService.checkAndEnabledService();
        if (isServiceEnabled && checkIsLocationPermissionEnable) {
          isLocationPermissionEnable.value=true;
        } else {
          SystemNavigator.pop();
        }
      }
    }catch(err){
      appLog("Home controller init ${err.toString()}");
    }

  }

  void startTrip(){
    if(isLocationPermissionEnable.value==false) {
      checkLocationPermission();
    } else {
      Get.toNamed(AppRoutes.activeTrip);
    }
  }

}