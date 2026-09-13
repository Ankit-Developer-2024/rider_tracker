import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rider_tracker/core/utility/utils.dart';


Marker getMapMarker({required LatLng latlng ,required String toastMessage}){
  return Marker(
    point: latlng, // The GPS position
    width: 40.0,
    height: 40.0,
    alignment: Alignment.topCenter,
    child: GestureDetector(
      onTap: () {
        showToast(toastMessage);
      },
      child: const Icon(Icons.location_on, color: Colors.blue, size: 40.0),
    ),
  );
}

