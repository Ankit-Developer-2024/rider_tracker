import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/styles/app_text_styles.dart';
import 'package:rider_tracker/core/styles/dimensions.dart';
import 'package:rider_tracker/core/utility/utils.dart';
import 'package:rider_tracker/feature/trip/presentation/contoller/trip_controller.dart';
import 'package:rider_tracker/feature/trip/presentation/view/trip_summary_screen.dart';
import 'package:rider_tracker/feature/trip/presentation/widgets/trip_history_loading_shimmer_view.dart';

class TripHistoryScreen extends GetView<TripController> {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (isPop,data){
        controller.endTrip();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Trip History')),
        body: Obx(() {
          return controller.isLoading.value == true
              ? TripHistoryLoadingShimmerView()
              : controller.trips.isEmpty
              ? Center(
                  child: Text(
                    'No completed trips yet',
                    style: AppTextStyles.semiBold20P(color: AppColors.textSecondary),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.trips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spacing_12),
                  itemBuilder: (context, index) {
                    final trip = controller.trips[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TripSummaryScreen(trip: trip),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.spacing_16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppDimensions.spacing_16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(112),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.pedal_bike_rounded,
                                color: AppColors.primary,
                                size: AppDimensions.size_22,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacing_14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${trip.distanceKm.toStringAsFixed(2)} km',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    formatDate(trip.startTime),
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${trip.maxSpeedKmh.toStringAsFixed(0)} km/h',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.warning,
                                  ),
                                ),
                                const Text(
                                  'max speed',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }
}
