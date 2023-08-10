// import 'package:Radiance/pages/frame/welcome/controller.dart';
import 'package:get/get.dart';
import 'package:Radiance/pages/contact/index.dart';

import 'controller.dart';
class ContactBinding implements Bindings{
  @override
  void dependencies(){
    Get.lazyPut<ContactController>(() => ContactController());

  }
}