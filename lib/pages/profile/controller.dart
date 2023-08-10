import 'dart:io';

import 'package:Radiance/common/apis/apis.dart';
import 'package:Radiance/common/entities/entities.dart';
import 'package:Radiance/common/routes/names.dart';
import 'package:Radiance/common/widgets/toast.dart';
import 'package:Radiance/pages/message/state.dart';
import 'package:Radiance/pages/profile/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/store/user.dart';

class ProfileController extends GetxController {
  final state = ProfileState();
  TextEditingController? NameEditingController = TextEditingController();
  TextEditingController? DescriptionEditingController = TextEditingController();
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  ProfileController();

  @override
  void onInit() {
    super.onInit();
    var userItem = Get.arguments;
    if(userItem!=null){
      state.profile_detail.value = userItem;
      if(state.profile_detail.value.name!=null){
        NameEditingController?.text = state.profile_detail.value.name!;
      }
      if(state.profile_detail.value.description!=null){
        DescriptionEditingController?.text = state.profile_detail.value.description!;
      }
    }

  }

  goSave() async {
    if (state.profile_detail.value.name == null ||
        state.profile_detail.value.name!.isEmpty) {
      toastInfo(msg: "name not empty!");
      return;
    }
    if (state.profile_detail.value.description == null ||
        state.profile_detail.value.description!.isEmpty) {
      toastInfo(msg: "description not empty!");
      return;
    }
    if (state.profile_detail.value.avatar == null ||
        state.profile_detail.value.avatar!.isEmpty) {
      toastInfo(msg: "avatar not empty!");
      return;
    }

    LoginRequestEntity updateProfileRequestEntity = LoginRequestEntity();
    var userItem = state.profile_detail.value;
    updateProfileRequestEntity.avatar = userItem.avatar;
    updateProfileRequestEntity.name = userItem.name;
    updateProfileRequestEntity.description = userItem.description;
    updateProfileRequestEntity.online = userItem.online;

    var result = await UserAPI.UpdateProfile(
        params: updateProfileRequestEntity);
    print(result.code);
    print(result.msg);
    if (result.code == 0) {
      UserItem userItem = state.profile_detail.value;
      await UserStore.to.saveProfile(userItem);
      Get.back(result: "finish");
    }
  }

  Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );

    if (result != null) {
      return File(result.path);
    } else {
      throw Exception('Image compression failed');
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Adjust the aspect ratio as needed
        compressQuality: 70, // Adjust the compression quality as needed
        compressFormat: ImageCompressFormat.jpg, // Adjust the compression format as needed
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: '             Edit This Image',
          toolbarColor: Colors.blueAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ),
      );

      if (croppedFile != null) {
        final compressedFile = await compressImage(File(croppedFile.path));
        _photo = compressedFile;
        uploadFile();
      } else {
        print('Image cropping cancelled.');
      }
    } else {
      print('No image selected.');
    }

  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Adjust the aspect ratio as needed
        compressQuality: 70, // Adjust the compression quality as needed
        compressFormat: ImageCompressFormat.jpg, // Adjust the compression format as needed
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: '             Edit This Image',
          toolbarColor: Colors.blueAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ),
      );

      if (croppedFile != null) {
        final compressedFile = await compressImage(File(croppedFile.path));
        _photo = compressedFile;
        uploadFile();
      } else {
        print('Image cropping cancelled.');
      }
    } else {
      print('No image selected.');
    }
  }

  Future uploadFile() async {
    // if (_photo == null) return;
    // print(_photo);
    var result = await ChatAPI.upload_img(file:_photo);
    print(result.data);
    if(result.code==0){

      state.profile_detail.value.avatar = result.data;
      state.profile_detail.refresh();
    }else{
      toastInfo(msg: "image error");
    }
  }

  asyncLoadAllData() async {

  }





    goLogout() async {

    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }

  @override
  void onReady() {
    super.onReady();

  }

  @override
  void dispose() {
    super.dispose();
  }
}
