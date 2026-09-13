import 'package:get/get.dart';
import 'package:rider_tracker/feature/home/presentation/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
     Get.put<HomeController>(HomeController());
  }
}