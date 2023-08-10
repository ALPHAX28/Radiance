import 'package:Radiance/common/apis/apis.dart';
import 'package:flutter/material.dart';
import 'package:Radiance/common/entities/entities.dart';
import 'package:Radiance/common/routes/routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:Radiance/common/store/store.dart';
import 'package:Radiance/common/utils/security.dart';
import 'package:Radiance/common/values/server.dart';
import 'package:Radiance/common/widgets/toast.dart';
import 'index.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:Radiance/pages/frame/register/controller.dart';


class SendCodeController extends GetxController {
  final state = SendCodeState();
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController? EmailEditingController = TextEditingController();
  SendCodeController();
  String verificationId = "";


  void submitOTP() async{
    /// get the `smsCode` from the user
    String smsCode = state.verifycode.value;
    if(smsCode.isEmpty){
      toastInfo(msg: "smsCode not empty!");
      return;
    }
    Get.focusScope?.unfocus();
    var phoneAuthCredential = await PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

    _login(phoneAuthCredential);

  }

  Future<void> _login(AuthCredential phoneAuthCredential) async {
    try {
      var user = await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      print("user-------------");
      print(user);
      if(user.user!=null){

        String displayName = "user" ;
        String email = user.user!.phoneNumber??"phone@email.com";
        String id = user.user!.uid;
        String photoUrl = "https://images.freeimages.com/images/large-previews/028/close-up-bridge-and-clowds-1640793.jpg";
        print(photoUrl);
        print("phone uid----");
        print(id);
        LoginRequestEntity loginPageListRequestEntity = new LoginRequestEntity();
        loginPageListRequestEntity.avatar = photoUrl;
        loginPageListRequestEntity.name = displayName;
        loginPageListRequestEntity.email = email;
        loginPageListRequestEntity.open_id = id;
        loginPageListRequestEntity.type = 5;
        asyncPostAllData(loginPageListRequestEntity);

      }else{
        toastInfo(msg: 'apple login error');
      }

    } catch (e) {

      print(e.toString());
    }
  }


  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    EasyLoading.show(indicator: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.black,
        )
    ),maskType: EasyLoadingMaskType.clear,dismissOnTap: true);
    var result = await UserAPI.Login(params: loginRequestEntity);
    print(result);
    if(result.code==0){
      await UserStore.to.saveProfile(result.data!);
      EasyLoading.dismiss();
      Get.offAllNamed(AppRoutes.Message);
    }else{
      EasyLoading.dismiss();
      toastInfo(msg: 'internet error');
    }

  }


  @override
  void onReady() {
    super.onReady();
    var data = Get.parameters;
    print(data);
    verificationId = data["verificationId"]??"";
  }

  @override
  void dispose() {
    super.dispose();
  }
}
