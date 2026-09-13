

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rider_tracker/core/routing/app_pages.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rider Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: .fromSeed(seedColor: AppColors.primaryLight),
    ),
    initialRoute: AppPages.initialRoute,
    getPages: AppPages.routes,
    );
  }
}