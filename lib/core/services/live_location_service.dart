import 'dart:async';


import 'package:location/location.dart' ;
import 'package:get/get.dart';
import 'package:rider_tracker/core/utility/helpers/location_permission_helper.dart';

class LiveLocationService  {

   Rxn<LocationData> liveLocationData=Rxn(null);
   static final Location _location=Location();

   StreamSubscription<LocationData>? _locationSubscription;

   Stream<LocationData> get locationStream => _location.onLocationChanged;

   static Future<bool> checkAndEnabledService()async{
     bool isServiceEnabled =await _location.serviceEnabled();
     if(!isServiceEnabled){
       await _location.requestService();
       bool isService =await _location.serviceEnabled();
       return isService;
     }else{
       return true;
     }
   }

   Future<void> startTracking(void Function(LocationData location) onLocation,) async {

      if(!await LocationPermissionHelper.checkIsLocationPermissionEnable()) return;
      await _location.enableBackgroundMode(enable: true);

     _locationSubscription ??= _location.onLocationChanged.listen(onLocation);
   }


   Future<void> stopTracking() async {
     await _locationSubscription?.cancel();
     _locationSubscription = null;
     await _location.enableBackgroundMode(enable: false);
   }






// static Stream<LocationPointModel> positionStream() {
   //   final settings = AndroidSettings(
   //     accuracy: LocationAccuracy.high,
   //     distanceFilter: 3,
   //     intervalDuration: const Duration(seconds: 2),
   //     foregroundNotificationConfig: const ForegroundNotificationConfig(
   //       notificationTitle: 'Trip in progress',
   //       notificationText: 'Tracking your ride location',
   //       enableWakeLock: true,
   //     ),
   //   );
   //
   //
   //   final stream = Geolocator.getPositionStream(
   //     locationSettings: settings
   //   );
   //
   //
   //
   //   return stream.map((Position position) {
   //     print("-----------------------$position");
   //     return LocationPointModel(
   //       latitude: position.latitude,
   //       longitude: position.longitude,
   //       speed: position.speed < 0 ? 0 : position.speed, // m/s, platform can report -1 when unknown
   //       accuracy: position.accuracy, // meters
   //       timestamp: position.timestamp,
   //     );
   //   }
   //   );
   // }


}