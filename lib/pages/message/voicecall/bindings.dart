import 'package:Radiance/pages/frame/welcome/controller.dart';
import 'package:Radiance/pages/message/voicecall/controller.dart';
import 'package:get/get.dart';
class VoiceCallBinding implements Bindings{
  @override
  void dependencies(){
    Get.lazyPut<VoiceCallViewController>(() => VoiceCallViewController());

  }
}