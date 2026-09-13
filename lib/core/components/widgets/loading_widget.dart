import 'package:flutter/material.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
      // color: AppColors.scrimColor,
      color: Colors.transparent,
        // boxShadow: [
        //       BoxShadow(
        //           blurRadius: 16,
        //           spreadRadius: 0,
        //           offset: const Offset(10, 16),
        //           color: const Color(0xff000000).withOpacity(0.05))
        //     ]
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: AppColors.brownishGold,),
    );
  }
}
