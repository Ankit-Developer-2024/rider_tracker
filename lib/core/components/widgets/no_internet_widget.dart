
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rider_tracker/core/components/widgets/primary_button.dart';
import 'package:rider_tracker/core/components/widgets/text_view.dart';
import 'package:rider_tracker/core/components/widgets/universal_media_view.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/styles/app_text_styles.dart';
import 'package:rider_tracker/core/utility/utils.dart';

import '../../styles/dimensions.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onTryAgain;
  const NoInternetWidget({super.key,required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(
          left: AppDimensions.spacing_8,
          right: AppDimensions.spacing_8,
          top: AppDimensions.size_76-kToolbarHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UniversalMediaView(
            imageWidth: Get.width,
            imageHeight: Get.width,
            path: getLocalPng("no_internet"),
          ),
          const SizedBox(height: AppDimensions.size_28),
          const TextView(title: "No Internet Connection!"),
          TextView(
            title: "No internet connection was found. Check your connection or try again.",
            textAlign: TextAlign.center,
            textStyle: AppTextStyles.regular14P(color: AppColors.grey700),
            margin: const EdgeInsets.only(top: AppDimensions.spacing_8),
          ),
          const SizedBox(height: AppDimensions.size_28),
          SizedBox(
            width: AppDimensions.size_150,
            child: PrimaryButton(
              onPress: onTryAgain,
              title: "Try Again",

            ),
          )
        ],
      ),
    );
  }
}
