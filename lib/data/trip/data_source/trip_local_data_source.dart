import 'package:rider_tracker/data/trip/models/trip_model.dart';

abstract interface class TripLocalDataSource {

  Future<List<TripModel>?> fetchTrips();

  Future<TripModel?> fetchTripWithId({required String id});

  Future<bool?> uploadTrip({required TripModel tripModel});

}