
class LocationPointModel {
  final double latitude;
  final double longitude;
  final double speed;
  final double accuracy;
  final DateTime timestamp;
  final bool accepted;
  final String? rejectionReason;
  const LocationPointModel({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.accuracy,
    required this.timestamp,
    this.accepted = true,
    this.rejectionReason,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'speed': speed,
    'accuracy': accuracy,
    'timestamp': timestamp.toIso8601String(),
    'accepted': accepted,
    'rejectionReason': rejectionReason,
  };

  factory LocationPointModel.fromJson(Map<String, dynamic> json) =>
      LocationPointModel(
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    speed: json['speed'] as double,
    accuracy: json['accuracy'] as double,
    timestamp: DateTime.parse(json['timestamp'] as String),
    accepted: json['accepted'] as bool? ?? true,
    rejectionReason: json['rejectionReason'] as String?,
  );

  static LocationPointModel createResponseModel(dynamic json){
    return LocationPointModel.fromJson(json);
  }

  static List<LocationPointModel> createResponseModelList(List<dynamic> data){
    return data.map((location)=>LocationPointModel.fromJson(location)).toList();
  }



}
