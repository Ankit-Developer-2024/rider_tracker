import 'dart:convert';

import 'package:rider_tracker/core/utility/constant/storage_tags.dart';
import 'package:rider_tracker/core/utility/utils.dart';
import 'package:rider_tracker/data/trip/data_source/trip_local_data_source.dart';
import 'package:rider_tracker/data/trip/models/trip_model.dart';
import 'package:rider_tracker/wrapper/preferences/app_preferences.dart';

class TripLocalDataSourceImpl implements TripLocalDataSource {
  
  @override
  Future<TripModel?> fetchTripWithId({required String id}) async {

    try{

      await Future.delayed(Duration(seconds: 2));

      String? tripsData = AppPreferences.instance.getValue(StorageTags.trips);
      if(tripsData==null || tripsData.isEmpty)  return null;

      List<dynamic>  jsonData= jsonDecode(tripsData);

      List<TripModel?> trips= TripModel.createResponseModelList(jsonData);

      TripModel? trip = trips.firstWhere((tp)=>(tp!=null && tp.id==id) , orElse: ()=> null);
      return  trip;

    }catch(e){
      appLog("**********FetchTripWithId error********");
      return null;
    }

  }

  @override
  Future<List<TripModel>?> fetchTrips() async{
    try{
      await Future.delayed(Duration(seconds: 2));

      String? tripsData = AppPreferences.instance.getValue(StorageTags.trips);
      if(tripsData==null || tripsData.isEmpty)  return null;
      List<dynamic>  jsonData= jsonDecode(tripsData);

      List<TripModel> trips= TripModel.createResponseModelList(jsonData);

      return trips;
    }catch(e){
      appLog("**********Fetch Trips error********");
      return null;
    }

  }

  @override
  Future<bool?> uploadTrip({required TripModel tripModel}) async {

    try{
      await Future.delayed(Duration(seconds: 2));

      String? tripsData = AppPreferences.instance.getValue(StorageTags.trips);
      List<dynamic>  jsonData=[];
      if( tripsData!=null && tripsData.isNotEmpty) jsonData = jsonDecode(tripsData);

      jsonData.insert(0, tripModel.toJson());

      String data = jsonEncode(jsonData);

      await AppPreferences.instance.putValue(StorageTags.trips,data);

      return true;

    }catch(e){
      appLog("**********UploadTrip error********");
      return false;
    }

  }
}