import 'controller.dart';
import 'package:get/get.dart';
class SignInBinding implements Bindings{
  @override
  void dependencies(){
    Get.lazyPut<SignInController>(() => SignInController());

  }
}