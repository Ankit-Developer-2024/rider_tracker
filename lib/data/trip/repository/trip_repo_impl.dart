import 'package:rider_tracker/data/trip/data_source/trip_local_data_source.dart';
import 'package:rider_tracker/data/trip/data_source/trip_local_data_source_impl.dart';
import 'package:rider_tracker/data/trip/models/trip_model.dart';
import 'package:rider_tracker/data/trip/repository/trip_repo.dart';

class TripRepoImpl  implements TripRepo {

  final TripLocalDataSource _tripLocalDataSource = TripLocalDataSourceImpl();

  @override
  Future<bool?> uploadTrip({required TripModel tripModel}) async {
    return await _tripLocalDataSource.uploadTrip(tripModel: tripModel);
  }

  @override
  Future<TripModel?> fetchTripWithId({required String id}) async {
    return await _tripLocalDataSource.fetchTripWithId(id: id);
  }

  @override
  Future<List<TripModel>?> fetchTrips() async{
    return await _tripLocalDataSource.fetchTrips();
  }
}