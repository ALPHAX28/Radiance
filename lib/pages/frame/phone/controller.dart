import 'package:Radiance/common/utils/data.dart';
import 'package:Radiance/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:Radiance/common/routes/routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:Radiance/common/widgets/toast.dart';
import 'index.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PhoneController extends GetxController {
  final state = PhoneState();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController? PhoneEditingController = TextEditingController();
  FixedExtentScrollController? fixedExtentScrollController = FixedExtentScrollController(initialItem: 0);
  PhoneController();


  // 执行登录操作
  handlePhone() async {

    try {
      String phone = state.phone_number.value.trim();
      Get.focusScope?.unfocus();
      if(phone.isEmpty){
        toastInfo(msg: "phone number not empty!");
        return;
      }
      String dialCode = state.choose_index_dialCode.value;
      print(phone);
      print(dialCode);


      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${dialCode} ${phone}',
        verificationCompleted: (PhoneAuthCredential credential) async{
          toastInfo(msg: "verified");

        },
        verificationFailed: (FirebaseAuthException e) {
          toastInfo(msg: "verification failed");
          print(e);
          if (e.code == 'invalid-phone-number') {
            toastInfo(msg: "Please enter a valid phone no");
          }

        },
        codeSent: (String verificationId, int? resendToken) {
          toastInfo(msg: "Code sent");
          print(verificationId);
          Get.toNamed(AppRoutes.SendCode,parameters: {"verificationId":verificationId});
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('codeAutoRetrievalTimeout-------------');
          print(verificationId);
        },
        timeout: Duration(milliseconds: 10000),
      );

    } catch (error) {
      toastInfo(msg: 'login error');
      print("Login--------------------------");
      print(error);
    }

  }


  saveAddress() async {

    state.choose_index_flag.value = state.CountryList.elementAt(state.choose_index.value).flag??"";
    state.choose_index_dialCode.value = state.CountryList.elementAt(state.choose_index.value).dialCode??"";

    Get.back();
  }

  @override
  void onReady() {
    super.onReady();

    state.CountryList.value = Countries.list;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
