import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:rider_tracker/core/components/widgets/primary_button.dart';
import 'package:rider_tracker/core/components/widgets/status_badge.dart';
import 'package:rider_tracker/core/enums/enum.dart';
import 'package:rider_tracker/core/routing/app_routes.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/styles/app_text_styles.dart';
import 'package:rider_tracker/core/styles/dimensions.dart';
import 'package:rider_tracker/core/utility/utils.dart';
import 'package:rider_tracker/feature/trip/presentation/contoller/trip_controller.dart';
import 'package:rider_tracker/feature/trip/presentation/widgets/show_confirm_end_trip_dialog.dart';
import 'package:rider_tracker/feature/trip/presentation/widgets/stat_card.dart';
import 'package:rider_tracker/feature/trip/presentation/widgets/trip_data_shimmer_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveTripScreen extends GetView<TripController> {
  const ActiveTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Trip in progress'),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return controller.activeTrip.value == null &&
                            !controller.isTripHaveData.value
                        ? SizedBox(height: 20)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              StatusBadge(
                                text: controller.activeTrip.value!.status==TripStatus.completed
                                    ?"COMPLETED" :"TRACKING",
                                color: controller.activeTrip.value!.status==TripStatus.completed
                                    ? AppColors.green
                                    : AppColors.primary,
                                pulsing: true,
                              ),
                              Text(
                                formatDuration(
                                  controller.activeTrip.value!.duration,
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          );
                  }),
                  const SizedBox(height: AppDimensions.spacing_18),
                  Obx(() {
                    return controller.initialLocation.value == null
                        ? Shimmer.fromColors(
                            baseColor: AppColors.white,
                            highlightColor: AppColors.primaryLight.withAlpha(
                              100,
                            ),
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radius_12,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 300,
                            clipBehavior: Clip.hardEdge,
                            width: MediaQuery.sizeOf(context).width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radius_12,
                              ),
                            ),
                            child: FlutterMap(
                              mapController: controller.mapController,
                              options: MapOptions(
                                initialCenter:
                                    controller.initialLocation.value!,
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
                                  polylines: [...controller.listOfPolyline],
                                ),
                                MarkerLayer(markers: [...controller.marker]),

                                RichAttributionWidget(
                                  // Include a stylish prebuilt attribution widget that meets all requirments
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
                          );
                  }),

                  const SizedBox(height: AppDimensions.spacing_18),

                  Obx(() {
                    return (controller.activeTrip.value == null &&
                            !controller.isTripHaveData.value)
                        ? TripDataShimmerView()
                        : GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.5,
                            children: [
                              StatCard(
                                label: 'CURRENT SPEED',
                                value: controller
                                    .activeTrip
                                    .value!
                                    .currentSpeedKmh
                                    .toStringAsFixed(
                                      1,
                                    ), // trip.currentSpeedKmh.toStringAsFixed(1),
                                unit: 'km/h',
                                icon: Icons.speed_rounded,
                                accent: AppColors.primary,
                              ),
                              StatCard(
                                label: 'MAX SPEED',
                                value: controller.activeTrip.value!.maxSpeedKmh
                                    .toStringAsFixed(
                                      1,
                                    ), //trip.maxSpeedKmh.toStringAsFixed(1),
                                unit: 'km/h',
                                icon: Icons.bolt_rounded,
                                accent: AppColors.warning,
                              ),
                              StatCard(
                                label: 'DISTANCE',
                                value: controller.activeTrip.value!.distanceKm
                                    .toStringAsFixed(
                                      2,
                                    ), // trip.distanceKm.toStringAsFixed(2),
                                unit: 'km',
                                icon: Icons.route_rounded,
                                accent: AppColors.accentBlue,
                              ),
                              StatCard(
                                label: 'GPS POINTS',
                                value:
                                    '${controller.activeTrip.value!.points.length}',
                                unit: 'accepted',
                                icon: Icons.satellite_alt_rounded,
                                accent: AppColors.textSecondary,
                              ),
                            ],
                          );
                  }),

                  Obx(() {
                    return (controller.activeTrip.value != null &&
                            controller.activeTrip.value!.rejectedPointCount > 0)
                        ? Container(
                            margin: EdgeInsets.only(
                              top: AppDimensions.spacing_14,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.warning.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.filter_alt_rounded,
                                  size: 16,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${controller.activeTrip.value!.rejectedPointCount} noisy GPS reading(s) filtered out',
                                    style: const TextStyle(
                                      color: AppColors.warning,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink();
                  }),
                  const SizedBox(height: AppDimensions.spacing_24),
                 Obx((){
                   return (controller.activeTrip.value!=null && controller.activeTrip.value!.status==TripStatus.completed)
                       ?  PrimaryButton(
                     onPress: (){
                       Get.toNamed(
                           AppRoutes.tripSummary,
                           arguments: {"trip":controller.activeTrip.value!}
                       );
                     },
                     title: "Trip Summary",
                     titleStyle: AppTextStyles.medium16P(color: AppColors.white),
                     leftIcon:const Icon(Icons.edit_note_sharp,color: AppColors.white,),
                     backgroundColor: AppColors.primary,
                   )
                       :  Obx((){
                         return PrimaryButton(
                           onPress: () {
                             controller.isLoading.value
                                 ? null
                                 : Get.dialog(ShowConfirmEndTripDialog(onPress: () {
                               controller.endTrip();
                               Get.back();
                             }));
                           },
                           title: controller.isLoading.value ? "Uploading..." : "End Trip",
                           titleStyle: AppTextStyles.medium16P(color: AppColors.white),
                           leftIcon: controller.isLoading.value ? null : const Icon(Icons.stop_rounded,color: AppColors.white,),
                           backgroundColor: AppColors.danger,
                         );
                   });
                 }),
                 Obx((){
                   return (controller.activeTrip.value!=null && controller.activeTrip.value!.status==TripStatus.completed)
                       ? Container(
                         margin: EdgeInsets.only(top: AppDimensions.spacing_10),
                         child: PrimaryButton(
                                              onPress: (){
                                                  controller.startTrip(null);
                                              },
                                              title: "Start Trip Again",
                                              titleStyle: AppTextStyles.medium16P(color: AppColors.white),
                                              leftIcon:const Icon(Icons.play_arrow ,color: AppColors.white,),
                                              backgroundColor: AppColors.lightGreen,
                                            ),
                       )
                       : SizedBox.shrink();
                 })

                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
