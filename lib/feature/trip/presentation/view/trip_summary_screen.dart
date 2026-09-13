import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:rider_tracker/core/components/widgets/map_marker.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/styles/dimensions.dart';
import 'package:rider_tracker/core/utility/utils.dart';
import 'package:rider_tracker/data/trip/models/trip_model.dart';
import 'package:rider_tracker/feature/trip/presentation/contoller/trip_controller.dart';
import 'package:rider_tracker/feature/trip/presentation/widgets/stat_card.dart';
import 'package:url_launcher/url_launcher.dart';

class TripSummaryScreen extends GetView<TripController> {
  const TripSummaryScreen({super.key,required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Summary'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () =>  Get.back(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.id,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppDimensions.spacing_4),
              Text(
                '${formatDate(trip.startTime)} · ${formatDuration(trip.duration)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppDimensions.spacing_18),

             Container(
              height: 300,
              clipBehavior: Clip.hardEdge,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppDimensions.radius_12,
                ),
              ),
              child: FlutterMap(
               // mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: LatLng(trip.points[0].latitude, trip.points[0].longitude),
                  initialZoom: 9.2,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                    "com.example.rider_tracker",
                  ),
                  PolylineLayer(
                    polylines: [Polyline(points: controller.getListOfPolylineCoordinate(trip.points),color: AppColors.primary,strokeWidth: 2)],
                  ),
                  MarkerLayer(
                      markers: [
                        getMapMarker(latlng: LatLng(trip.points[0].latitude, trip.points[0].longitude), toastMessage: "Trip Start Location"),
                        getMapMarker(latlng: LatLng(trip.points[trip.points.length-1].latitude, trip.points[trip.points.length-1].longitude), toastMessage: "Trip End Location")

                      ]
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                          Uri.parse(
                            'https://openstreetmap.org/copyright',
                          ),
                        ), // (external)
                      ),
                      // Also add images...
                    ],
                  ),
                ],
              ),
            ),

              const SizedBox(height: AppDimensions.spacing_18),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  StatCard(
                    label: 'DISTANCE',
                    value: trip.distanceKm.toStringAsFixed(2),
                    unit: 'km',
                    icon: Icons.route_rounded,
                    accent: AppColors.accentBlue,
                  ),
                  StatCard(
                    label: 'MAX SPEED',
                    value: trip.maxSpeedKmh.toStringAsFixed(1),
                    unit: 'km/h',
                    icon: Icons.bolt_rounded,
                    accent: AppColors.warning,
                  ),
                  StatCard(
                    label: 'AVG SPEED',
                    value: trip.averageSpeedKmh.toStringAsFixed(1),
                    unit: 'km/h',
                    icon: Icons.timeline_rounded,
                    accent: AppColors.primary,
                  ),
                  StatCard(
                    label: 'DURATION',
                    value: formatDuration(trip.duration),
                    unit: '',
                    icon: Icons.timer_outlined,
                    accent: AppColors.textSecondary,
                  ),
                ],
              ),
              if (trip.rejectedPointCount > 0) ...[
                const SizedBox(height: AppDimensions.spacing_14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${trip.rejectedPointCount} GPS reading(s) filtered as noise/spikes and excluded from distance & speed.',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.spacing_24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
