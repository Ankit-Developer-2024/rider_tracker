import 'package:get/get.dart';
import 'package:rider_tracker/core/routing/app_routes.dart';
import 'package:rider_tracker/feature/trip/presentation/bindings/trip_binding.dart';
import 'package:rider_tracker/feature/trip/presentation/view/active_trip_screen.dart';
import 'package:rider_tracker/feature/home/presentation/bindings/home_binding.dart';
import 'package:rider_tracker/feature/home/presentation/view/home_screen.dart';
import 'package:rider_tracker/feature/splash/presentation/bindings/splash_binding.dart';
import 'package:rider_tracker/feature/splash/presentation/view/splash_screen.dart';
import 'package:rider_tracker/feature/trip/presentation/view/trip_history_screen.dart';
import 'package:rider_tracker/feature/trip/presentation/view/trip_summary_screen.dart';

class AppPages  {

  static String initialRoute=AppRoutes.splash;
  static List<GetPage> routes =[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.activeTrip,
      page: () => const ActiveTripScreen(),
      binding: TripBinding(),
    ),
    GetPage(
      name: AppRoutes.tripSummary,
      page: (){
        final args = Get.arguments as Map<String, dynamic>?;
        final trip = args?['trip'];
        return TripSummaryScreen(trip: trip);
      },
    ),
    GetPage(
      name: AppRoutes.tripHistory,
      page: () => const TripHistoryScreen(),
      binding: TripBinding(),
    ),

  ];

}