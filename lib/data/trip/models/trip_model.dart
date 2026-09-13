import 'package:rider_tracker/core/enums/enum.dart';
import 'package:rider_tracker/data/trip/models/location_point_model.dart';


class TripModel {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  TripStatus status;
  List<LocationPointModel> points;
  double totalDistanceMeters;
  double currentSpeedMps;
  double maxSpeedMps;
  int rejectedPointCount;

  TripModel({
    required this.id,
    required this.startTime,
    this.endTime,
    this.status = TripStatus.active,
    List<LocationPointModel>? points,
    this.totalDistanceMeters = 0,
    this.currentSpeedMps = 0,
    this.maxSpeedMps = 0,
    this.rejectedPointCount = 0,
  }) : points = points ?? [];



  Duration get duration =>
      (endTime ?? DateTime.now()).difference(startTime);

  double get averageSpeedMps {
    final seconds = duration.inSeconds;
    if (seconds == 0) return 0;
    return totalDistanceMeters / seconds;
  }

  double get distanceKm => totalDistanceMeters / 1000;
  double get currentSpeedKmh => currentSpeedMps * 3.6;
  double get maxSpeedKmh => maxSpeedMps * 3.6;
  double get averageSpeedKmh => averageSpeedMps * 3.6;



  static List<TripModel> createResponseModelList(List<dynamic> data){
    return data.map((json)=>TripModel.fromJson(json)).toList();
  }


  factory TripModel.fromJson(Map<String, dynamic> json) {

    return TripModel(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime']==null ? null : DateTime.parse(json['endTime'] as String ),
      status: getTripStatus(json['status']),
      points: json['points']!=null ? LocationPointModel.createResponseModelList(json['points']) :[],
      totalDistanceMeters: (json['totalDistanceMeters'] as num?)?.toDouble() ?? 0,
      currentSpeedMps: (json['currentSpeedMps'] as num?)?.toDouble() ?? 0,
      maxSpeedMps: (json['maxSpeedMps'] as num?)?.toDouble() ?? 0,
      rejectedPointCount: (json['rejectedPointCount'] as num?)?.toInt() ?? 0,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status.name,
      'points': points.map((point) => point.toJson()).toList(),
      'totalDistanceMeters': totalDistanceMeters,
      'currentSpeedMps': currentSpeedMps,
      'maxSpeedMps': maxSpeedMps,
      'rejectedPointCount': rejectedPointCount,
    };
  }




  TripModel copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    TripStatus? status,
    List<LocationPointModel>? points,
    double? totalDistanceMeters,
    double? currentSpeedMps,
    double? maxSpeedMps,
    int? rejectedPointCount,
  }) {
    return TripModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      points: points ?? List<LocationPointModel>.from(this.points),
      totalDistanceMeters:
      totalDistanceMeters ?? this.totalDistanceMeters,
      currentSpeedMps: currentSpeedMps ?? this.currentSpeedMps,
      maxSpeedMps: maxSpeedMps ?? this.maxSpeedMps,
      rejectedPointCount:
      rejectedPointCount ?? this.rejectedPointCount,
    );
  }


  static TripStatus getTripStatus(String status){
    switch(status){
      case "active":
        return TripStatus.active;
      case "completed":
        return TripStatus.completed;
      case "idle":
        return TripStatus.idle;
      default:
        return TripStatus.idle;
    }
  }


}
