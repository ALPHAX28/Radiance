
import 'package:get/get.dart';

class VideoCallState {
  RxBool isReadyPreview = false.obs;
  RxBool isJoined = false.obs;
  RxBool isShowAvatar = true.obs;
  RxBool switchCamera = true.obs;
  RxBool turnCamera = true.obs;
  RxBool switchview = true.obs;
  RxBool switchRender = true.obs;
  RxSet<int> remoteUid = <int>{}.obs;
  RxInt onRemoteUid = 0.obs;
  RxString call_time_num = "missed video call".obs;
  RxString call_time = "00:00".obs;
  RxBool openMicrophone = true.obs;
  RxBool enableSpeakerphone = true.obs;
  RxBool shareScreen = false.obs;
  var doc_id = "".obs;
  var channelId = "".obs;

  var to_token = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var call_role = "audience".obs;
}
