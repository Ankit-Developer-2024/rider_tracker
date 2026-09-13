import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rider_tracker/core/components/widgets/primary_button.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/styles/app_text_styles.dart';
import 'package:rider_tracker/core/styles/dimensions.dart';

class LocationPermissionAlertBox extends StatelessWidget {
  const LocationPermissionAlertBox({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text("Location Permission",style: AppTextStyles.medium16P(color: AppColors.grey600),textAlign: TextAlign.center,),
        content: Text(""
            "We need access to your location data, This emphasizes efficiency and speed of service\n\n"
            "Your location helps us track your ride, even when the app is in the background or the screen looked.\n\n Choose 'ALWAYS ALLOW / ALLOW ALL THE TIME ' ",style: AppTextStyles.regular14P(color: AppColors.grey900)),

        actions: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing_4),
            child: PrimaryButton(
              onPress: ()async{
                await openAppSettings();
                Get.back();
              },
              title:"Open Settings",
              titleStyle: AppTextStyles.medium16P(color: AppColors.tileBackColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing_4),
            child: PrimaryButton(
              backgroundColor: AppColors.grey400,
              onPress: (){
                SystemNavigator.pop();
              },
              title:"Cancel",
              titleStyle: AppTextStyles.medium16P(color: AppColors.tileBackColor),
            ),
          )
        ],
        titlePadding: const EdgeInsets.only(left: AppDimensions.spacing_12,top: AppDimensions.spacing_12,right: AppDimensions.spacing_12,bottom: AppDimensions.spacing_8),
        contentPadding: const EdgeInsets.only(left: AppDimensions.spacing_12,right: AppDimensions.spacing_12,bottom: AppDimensions.spacing_16),
        actionsPadding: const EdgeInsets.only(left: AppDimensions.spacing_12,right: AppDimensions.spacing_12,bottom: AppDimensions.spacing_12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius_12)
        ),
      ),
    );
  }
}
