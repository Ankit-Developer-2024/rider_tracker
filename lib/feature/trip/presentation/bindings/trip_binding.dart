import 'package:get/get.dart';
import 'package:rider_tracker/feature/trip/presentation/contoller/trip_controller.dart';

class TripBinding  extends Bindings {
  @override
  void dependencies() {
    if(!Get.isRegistered<TripController>()){
      Get.put<TripController>(TripController());
    }

  }
}