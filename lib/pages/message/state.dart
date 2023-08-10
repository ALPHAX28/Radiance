import 'package:Radiance/common/entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MessageState{
  var head_detail = UserItem().obs;
  RxBool tabStatus = true.obs;
  RxList<Message> msgList = <Message>[].obs;
  RxList<CallMessage> callList = <CallMessage>[].obs;
  var to_token = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var to_online = "".obs;
  RxBool more_status = false.obs;
  RxList<Msgcontent> msgcontent = <Msgcontent>[].obs ;
  RxBool isloading = false.obs;

}