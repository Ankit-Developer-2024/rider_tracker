
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/styles/dimensions.dart';

class ShowConfirmEndTripDialog extends StatelessWidget {
  const ShowConfirmEndTripDialog({super.key, required this.onPress});
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('End this trip?'),
        content: const Text('Tracking will stop and a summary will be saved.'),
        actions: [
          TextButton(
            onPressed: () => Get.delete(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onPress,
            child: const Text(
              'End Trip',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(AppDimensions.radius_12)),
      ),
    );
  }
}
