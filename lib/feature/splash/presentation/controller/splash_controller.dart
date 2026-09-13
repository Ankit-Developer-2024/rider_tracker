import 'package:get/get.dart';
import 'package:rider_tracker/core/routing/app_routes.dart';

class SplashController extends  GetxController{

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init()async{

    await Future.delayed(Duration(seconds: 2));
    Get.offAllNamed(AppRoutes.home);


  }

}