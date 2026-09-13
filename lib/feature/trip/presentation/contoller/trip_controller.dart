import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:rider_tracker/core/components/widgets/map_marker.dart';
import 'package:rider_tracker/core/enums/enum.dart';
import 'package:rider_tracker/core/routing/app_routes.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/utility/constant/storage_tags.dart';
import 'package:rider_tracker/core/services/live_location_service.dart';
import 'package:rider_tracker/core/utility/helpers/location_permission_helper.dart';
import 'package:rider_tracker/core/utility/utils.dart';
import 'package:rider_tracker/data/trip/models/location_point_model.dart';
import 'package:rider_tracker/data/trip/models/trip_model.dart';
import 'package:rider_tracker/data/trip/repository/trip_repo.dart';
import 'package:rider_tracker/data/trip/repository/trip_repo_impl.dart';
import 'package:rider_tracker/wrapper/preferences/app_preferences.dart';

class TripController  extends GetxController with WidgetsBindingObserver {

  final Location _location = Location();
  MapController mapController=MapController();
  final LiveLocationService _liveLocationService =
  LiveLocationService();
  StreamSubscription<LocationData>? _locationSubscription;
  final TripRepo _tripRepo = TripRepoImpl();



  RxList<Marker> marker=<Marker>[].obs;
  RxList<Polyline> listOfPolyline=<Polyline>[].obs;
  List<LatLng> polylineLatLng=<LatLng>[].obs;

  Rxn<TripModel> activeTrip = Rxn(null);
  RxBool isTripHaveData = false.obs;

  static const double maxAccuracyMeters = 30;
  static const double maxPlausibleSpeedMps = 55;
  static const double minDistanceMeters = 3;

  Rxn<LatLng> initialLocation = Rxn(null);

  double? _lastLat;
  double? _lastLng;
  DateTime? _lastAcceptedTime;

  RxList<TripModel> trips = <TripModel>[].obs;
  RxBool isLoading = false.obs;


  @override
  void onInit() {
      super.onInit();
      WidgetsBinding.instance.addObserver(this);

      ever(activeTrip, (TripModel? trip) {
        if (trip != null && trip.status == TripStatus.active) {
          String tripJson = jsonEncode(trip.toJson());
          AppPreferences.instance.putValue(StorageTags.pendingTrip, tripJson);
        } else {
           AppPreferences.instance.remove(StorageTags.pendingTrip);
        }
      });


      if(Get.currentRoute==AppRoutes.tripHistory){
        fetchTrips();
      }else{

        String? pendingTripData = AppPreferences.instance.getValue(StorageTags.pendingTrip);
        if(pendingTripData!=null && pendingTripData.isNotEmpty){
          Map<String,dynamic> tripMapData= jsonDecode(pendingTripData);
           TripModel pendingTrip = TripModel.fromJson(tripMapData);
           startTrip(pendingTrip);

        }else{
          getCurrentLocation();
        }


      }

  }

  void getCurrentLocation()async{
    try{
      bool checkIsLocationPermissionEnable=await LocationPermissionHelper.checkIsLocationPermissionEnable();
      if(!checkIsLocationPermissionEnable){
        await LocationPermissionHelper.checkLocationPermission();
      }else {
        bool isServiceEnabled = await LiveLocationService.checkAndEnabledService();
        if (isServiceEnabled && checkIsLocationPermissionEnable) {
          final LocationData data = await _location.getLocation();
          if (data.latitude != null && data.longitude != null) {
            initialLocation.value =LatLng(data.latitude, data.longitude);
            marker.clear();
            marker.add(
                getMapMarker(latlng: LatLng(data.latitude, data.longitude), toastMessage: "Start Trip Location")
            );
            startTrip(null);
          }
        } else {
          SystemNavigator.pop();
        }
      }
    }catch(err){
      appLog("Home controller init ${err.toString()}");
    }

  }

  Future<void> startTrip(TripModel? pendingTrip) async{

    if(pendingTrip!=null){
      await AppPreferences.instance.remove(StorageTags.pendingTrip);
      activeTrip.value = pendingTrip;
      _lastAcceptedTime = pendingTrip.startTime;
      initialLocation.value = LatLng(pendingTrip.points[0].latitude, pendingTrip.points[0].longitude);
      _lastLat = pendingTrip.points[pendingTrip.points.length-1].latitude;
      _lastLng = pendingTrip.points[pendingTrip.points.length-1].longitude;

    }else{
      final trip = TripModel(
        id: 'TRIP-${DateTime.now().millisecondsSinceEpoch}',
        startTime: DateTime.now(),
      );
      activeTrip.value = trip;
      _lastAcceptedTime = trip.startTime;
      _lastLat = null;
      _lastLng = null;
    }



    await _liveLocationService.startTracking((location) {
       LocationPointModel point=  LocationPointModel(
               latitude: location.latitude,
               longitude: location.longitude,
               speed: location.speed! < 0 ? 0 : location.speed!,
               accuracy: location.accuracy!,
               timestamp: DateTime.fromMillisecondsSinceEpoch(location.time!.toInt()).toLocal(),
             );

       _handleIncomingLocationPoint(point);

      });
  }

  void endTrip() {
    if (activeTrip.value == null) return;
    _liveLocationService.stopTracking();
    activeTrip.value= activeTrip.value!.copyWith(status: TripStatus.completed);
    activeTrip.value= activeTrip.value!.copyWith(endTime: DateTime.now());
    marker.add(getMapMarker(latlng: LatLng(_lastLat!, _lastLng!), toastMessage: "End Trip Location"));
    //activeTrip.refresh();

    uploadTrip();

  }

  Future<void> _handleIncomingLocationPoint(LocationPointModel point) async{

    if (activeTrip.value == null) return;

    final evaluated = await _evaluatePoint(activeTrip.value!, point);

    if (evaluated.accepted) {
      _applyAcceptedPoint(activeTrip.value!, evaluated);
      if(listOfPolyline.isNotEmpty){
        Polyline poly=Polyline(points: [...listOfPolyline[0].points,LatLng(point.latitude, point.longitude)],color: AppColors.primary,strokeWidth: 2);
        RxList<Polyline> polyList=[poly].obs;
        listOfPolyline.value = polyList;
      }else{
        RxList<Polyline> polyList=[Polyline(
          points: [LatLng(point.latitude, point.longitude)],
          color: AppColors.primary,
          strokeWidth: 2
        )].obs;
        listOfPolyline.value = polyList;
        isTripHaveData.value=true;
      }
    }
    else {
       activeTrip.value?.copyWith(rejectedPointCount:activeTrip.value!.rejectedPointCount++);
       activeTrip.refresh();
    }

  }


  Future<LocationPointModel> _evaluatePoint(TripModel trip, LocationPointModel p) async{
    if (p.accuracy > maxAccuracyMeters) {
      return _reject(p, 'low accuracy (${p.accuracy.toStringAsFixed(0)}m)');
    }

    // First-ever point for this trip: nothing to compare against yet
    if (_lastLat == null || _lastLng == null) {
      return p;
    }

    final lastTime = _lastAcceptedTime ?? trip.startTime;
    if (!p.timestamp.isAfter(lastTime)) {
      return _reject(p, 'out-of-order timestamp');
    }

    final dtSeconds = p.timestamp.difference(lastTime).inMilliseconds / 1000;
    final distance = await _haversineMetersOrGeolocator(_lastLat!, _lastLng!, p.latitude, p.longitude);
    final impliedSpeed = dtSeconds > 0 ? distance / dtSeconds : 0;

    if (impliedSpeed > maxPlausibleSpeedMps) {
      return _reject(p, 'implausible speed (${(impliedSpeed * 3.6).toStringAsFixed(0)} km/h)');
    }
    if (distance < minDistanceMeters) {
      return _reject(p, 'jitter (<${minDistanceMeters.toInt()}m)');
    }
    return p;
  }


  LocationPointModel _reject(LocationPointModel p, String reason) => LocationPointModel(
    latitude: p.latitude,
    longitude: p.longitude,
    speed: p.speed,
    accuracy: p.accuracy,
    timestamp: p.timestamp,
    accepted: false,
    rejectionReason: reason,
  );


  void _applyAcceptedPoint(TripModel trip, LocationPointModel p) async{
    if (_lastLat != null && _lastLng != null) {
      final distance = await _haversineMetersOrGeolocator(_lastLat!, _lastLng!, p.latitude, p.longitude);
      trip.totalDistanceMeters += distance;
    }
    trip.currentSpeedMps = p.speed;
    if(p.speed>trip.maxSpeedMps) trip.maxSpeedMps=p.speed;
    trip.points.add(p);

    activeTrip.value?.copyWith(
      totalDistanceMeters: trip.totalDistanceMeters,
      currentSpeedMps: trip.currentSpeedMps,
      maxSpeedMps: trip.maxSpeedMps,
      points: trip.points
    );
    activeTrip.refresh();


    _lastLat = p.latitude;
    _lastLng = p.longitude;
    _lastAcceptedTime = p.timestamp;
  }


  Future<double> _haversineMetersOrGeolocator(double lat1, double lon1, double lat2, double lon2) async{
    // const r = 6371000.0;
    // final dLat = _deg2rad(lat2 - lat1);
    // final dLon = _deg2rad(lon2 - lon1);
    // final a = sin(dLat / 2) * sin(dLat / 2) +
    //     cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    // final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distanceInMeters = await Geolocator .distanceBetween(
      lat1, lon2, // Start latitude, longitude
      lat2, lon2, // End latitude, longitude
    );

    return distanceInMeters;
  }

  double _deg2rad(double deg) => deg * pi / 180;

  Future<void> uploadTrip()async{

     try{
       if(activeTrip.value!=null){
         isLoading.value=true;
         bool? isUpload = await _tripRepo.uploadTrip(tripModel: activeTrip.value!);
         isLoading.value=false;
         if(isUpload!=null && isUpload) {
           showToast("Trip saved/upload successfully");
         } else {
           showToast("Trip not saved/upload successfully");
         }
       }else{
         showToast("Trip not saved/upload successfully");
       }

     }catch(e){
       showToast("Trip not saved/upload successfully");
     }

  }

  Future<void> fetchTrips()async{

    try{
        isLoading.value=true;
        List<TripModel>? tripsData = await _tripRepo.fetchTrips();
        isLoading.value=false;
        if(tripsData!=null) {
          trips.value = tripsData;
          showToast("Trip fetch successfully");
        } else {
          showToast("Trip not fetch successfully");
        }

    }catch(e){
      showToast("Trip not fetch successfully");
    }

  }

  List<LatLng> getListOfPolylineCoordinate(List<LocationPointModel> position){

    List<LatLng> polyline = position.map((p)=>LatLng(p.latitude, p.longitude)).toList();
    return polyline;
  }


  @override
  void dispose() {

    _liveLocationService.stopTracking();
    _locationSubscription?.cancel();
    _locationSubscription=null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



}