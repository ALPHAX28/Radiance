import 'package:Radiance/common/routes/names.dart';
import 'package:Radiance/pages/frame/welcome/state.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  WelcomeController();
  final title = "Radiance";
  final state = WelcomeState();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(seconds: 3),() => Get.offAllNamed(AppRoutes.Message));
  }
}
