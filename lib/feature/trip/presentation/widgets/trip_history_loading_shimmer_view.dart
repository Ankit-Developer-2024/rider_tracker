import 'package:flutter/material.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class TripHistoryLoadingShimmerView extends StatelessWidget {
  const TripHistoryLoadingShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.white,
          highlightColor: AppColors.primaryLight.withAlpha(100),
          child: Container(
              height: 100,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.divider),
              )),
        );
      },
    );
  }
}
