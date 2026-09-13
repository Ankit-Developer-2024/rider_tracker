import 'package:get/get.dart';
import 'package:rider_tracker/feature/splash/presentation/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
     Get.put<SplashController>(SplashController());
  }
}