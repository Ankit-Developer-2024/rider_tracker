import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rider_tracker/core/components/widgets/primary_button.dart';
import 'package:rider_tracker/core/components/widgets/status_badge.dart';
import 'package:rider_tracker/core/routing/app_routes.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/styles/app_text_styles.dart';
import 'package:rider_tracker/feature/home/presentation/controller/home_controller.dart';
import 'package:rider_tracker/feature/home/presentation/widgets/permission_hint.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Rider Tracker',style: AppTextStyles.bold26P() ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Trip history',
            onPressed: () {
              Get.toNamed(AppRoutes.tripHistory);
            }
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatusBadge(text: 'READY TO RIDE', color: AppColors.accentBlue),
              const SizedBox(height: 28),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.divider, width: 1),
                        ),
                        child: const Icon(
                          Icons.pedal_bike_rounded,
                          size: 56,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No active trip',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Start a trip to begin live location, distance and speed tracking.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
               PrimaryButton(
              title: "Start Trip",
              onPress: (){
                controller.startTrip();
              },
              titleStyle: AppTextStyles.medium14P(color: AppColors.white),
              leftIcon: const Icon(Icons.play_arrow_rounded,color: AppColors.white ,),
            ),

              const SizedBox(height: 12),
              const PermissionHint(),
            ],
          ),
        ),
      ),
    );
  }
}


