import 'package:flutter/material.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/styles/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rider illustration
           Icon(Icons.pedal_bike_outlined,size: 200,color: AppColors.white,),
            Text("Rider Tracker",style: AppTextStyles.semiBold30P(color: AppColors.white),),
            SizedBox(height: 20,),
            Text("Track your ride",style: AppTextStyles.medium14P(color: AppColors.white),),
            Text("Live , Safe , Smart",style: AppTextStyles.medium14P(color: AppColors.white),)
          ],
        ),
      ),
    );
  }
}
