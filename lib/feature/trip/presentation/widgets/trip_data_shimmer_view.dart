import 'package:flutter/material.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class TripDataShimmerView extends StatelessWidget {
  const TripDataShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
    ),
        itemBuilder: (context,index){
          return Shimmer.fromColors(
            baseColor: AppColors.white,
            highlightColor: AppColors.primaryLight.withAlpha(100),
            child: Container(
                height: 150,
                padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
            )),
          );
        }
    );

  }
}
