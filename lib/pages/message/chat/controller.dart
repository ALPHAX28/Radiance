



import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui';

import 'package:Radiance/common/apis/apis.dart';
import 'package:Radiance/common/entities/entities.dart';
import 'package:Radiance/common/routes/names.dart';
import 'package:Radiance/common/store/store.dart';
import 'package:Radiance/common/widgets/toast.dart';
import 'package:Radiance/pages/frame/welcome/state.dart';
import 'package:Radiance/pages/message/chat/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';




class ChatController extends GetxController with WidgetsBindingObserver{
  ChatController();

  final state = ChatState();
  late String doc_id;
  final myInputController = TextEditingController();
  final token = UserStore.to.profile.token;
  final db = FirebaseFirestore.instance;
  var isLoadmore = true;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  ScrollController myScrollController = ScrollController();

  var listener;
  void goMore(){
    state.more_status.value = state.more_status.value?false:true;
  }

  void audioCall(){
    state.more_status.value=false;
    Get.toNamed(AppRoutes.VoiceCall,
      parameters: {
      "to_token":state.to_token.value,
      "to_name": state.to_name.value,
        "to_avatar": state.to_avatar.value,
        "call_role":"anchor",
        "doc_id":doc_id,
      }

    );

  }

  String _online = ''.toString().toLowerCase();

  String online = ''.toString().toLowerCase();


 @override
  void didChangeAppLifecycleState(AppLifecycleState states){
    super.didChangeAppLifecycleState(states);

    if(states == AppLifecycleState.resumed){
      online = 'online'.toString().toLowerCase();
      print("online: $online");
    }
    else{
      online = 'offline'.toString().toLowerCase();
      print("offline: $online");
    }

  }

  Future<bool> requestPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    if(permissionStatus!=PermissionStatus.granted){
      var status = await permission.request();
      if(status!=PermissionStatus.granted){
        toastInfo(msg: "Please enable permission to have video call");
        if(GetPlatform.isAndroid){
          await openAppSettings();
        }
        return false;

      }
    }
    return true;
  }

  void videoCall()async{

    state.more_status.value=false;
    bool micStatus = await requestPermission(Permission.microphone);
    bool camStatus = await requestPermission(Permission.camera);
    if(GetPlatform.isAndroid&&micStatus&&camStatus){
      Get.toNamed(AppRoutes.VideoCall,
          parameters: {
            "to_token":state.to_token.value,
            "to_name": state.to_name.value,
            "to_avatar": state.to_avatar.value,
            "call_role":"anchor",
            "doc_id":doc_id,
          }

      );
    }else{
      Get.toNamed(AppRoutes.VideoCall,
          parameters: {
      "to_token":state.to_token.value,
      "to_name": state.to_name.value,
      "to_avatar": state.to_avatar.value,
      "call_role":"anchor",
      "doc_id":doc_id,
      }
      );

    }

  }

  @override
  void onInit(){
    super.onInit();
    var data = Get.parameters;
    print(data);
    doc_id = data['doc_id']!;
    state.to_token.value = data['to_token']??"";
    state.to_name.value = data['to_name']??"";
    state.to_avatar.value = data['to_avatar']??"";
    state.to_online.value = data['to_online']??"1";
    WidgetsBinding.instance.addObserver(this);
    _online = 'online';
    clearMsgNum(doc_id);

  }

  Future<void> clearMsgNum(String doc_id) async {
    var messageResult = await db.collection("message").doc(doc_id).withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore()
    ).get();

    if(messageResult.data()!=null){
      var item = messageResult.data()!;
      int to_msg_num = item.to_msg_num==null?0:item.to_msg_num!;
      int from_msg_num = item.from_msg_num==null?0:item.from_msg_num!;
      if(item.from_token==token){
        to_msg_num = 0;
      }else{
        from_msg_num = 0;
      }
      await db.collection("message")
          .doc(doc_id)
          .update({
        "to_msg_num":to_msg_num,
        "from_msg_num":from_msg_num,
      });

    }


  }



  @override
  void onReady() {
    super.onReady();
    print("onReady------------");
    state.msgcontent.clear();
    final messages = db.collection("message").doc(doc_id).collection("msglist").withConverter(
      fromFirestore: Msgcontent.fromFirestore,
      toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore(),
    ).orderBy("addtime", descending: true).limit(15);

    listener = messages.snapshots().listen(
          (event) {
        print("current data: ${event.docs}");
        print("current data: ${event.metadata.hasPendingWrites}");
        List<Msgcontent> tempMsgList = <Msgcontent>[];
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              print("added----: ${change.doc.data()}");
              if(change.doc.data()!=null){
                tempMsgList.add(change.doc.data()!);
              }
              break;
            case DocumentChangeType.modified:
              print("Modified City: ${change.doc.data()}");
              break;
            case DocumentChangeType.removed:
              print("Removed City: ${change.doc.data()}");
              break;
          }
        }
        tempMsgList.reversed.forEach((element) {
          state.msgcontent.value.insert(0,element);
        });
        state.msgcontent.refresh();

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (myScrollController.hasClients){
            myScrollController.animateTo(
              myScrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,);
          }

        });

      },
      onError: (error) => print("Listen failed: $error"),
    );



    myScrollController.addListener((){
      // print(myscrollController.offset);
      //  print(myscrollController.position.maxScrollExtent);
      if((myScrollController.offset+10)>myScrollController.position.maxScrollExtent){
        if(isLoadmore){
          state.isloading.value = true;
          isLoadmore = false;
          asyncLoadMoreData(state.msgcontent.length);
        }

      }

    });




  }










  Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 50,
      minWidth: 800,
      minHeight: 800,
    );

    if (result != null) {
      return File(result.path);
    } else {
      throw Exception('Image compression failed');
    }
  }



  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Adjust the aspect ratio as needed
        compressQuality: 50, // Adjust the compression quality as needed
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

  Future<void> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Adjust the aspect ratio as needed
        compressQuality: 50, // Adjust the compression quality as needed
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


  void addEmoji(String emoji) {
    final text = myInputController.text;
    final selectionStart = myInputController.selection.start;
    final selectionEnd = myInputController.selection.end;
    final newText = text.substring(0, selectionStart) +
        emoji +
        text.substring(selectionEnd);
    myInputController.value = myInputController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selectionStart + emoji.length,
      ),
    );
  }

  Future uploadFile()async{
    var result = await ChatAPI.upload_img(file: _photo);
    print(result.data);
    if(result.code==0){
      sendImageMessage(result.data!);
    }else{
      toastInfo(msg: "Image error");
    }
  }
  Future<void> sendMessage() async {



    String sendContent = myInputController.text;
    // print("...$sendContent...");
    if(sendContent.isEmpty){
      toastInfo(msg: "content is empty");
      return;
    }

    final content = Msgcontent(
      token: token,
      content: sendContent,
      type: "text",
      addtime: Timestamp.now(),
    );

    await db.collection("message").doc(doc_id).collection("msglist")
        .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msg,options)=>msg.toFirestore()
    ).add(content).then((DocumentReference doc){
      // print("...base id is ${doc_id}...new message doc id is ${doc.id}");
      myInputController.clear();
    });


    var messageResult = await db.collection("message").doc(doc_id).withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore()
    ).get();




    if(messageResult.data()!=null){
      var item = messageResult.data()!;
      int to_msg_num = item.to_msg_num==null?0:item.to_msg_num!;
      int from_msg_num = item.from_msg_num==null?0:item.from_msg_num!;
      if(item.from_token==token){
        from_msg_num = from_msg_num+1;
      }else{
        to_msg_num = to_msg_num+1;
      }
      await db.collection("message")
          .doc(doc_id)
          .update({
        "to_msg_num":to_msg_num,
        "from_msg_num":from_msg_num,
        "last_msg":sendContent,
        "last_time":Timestamp.now()
      });

    }
    sendNotifications("text");



  }

  asyncLoadMoreData(int page) async{
    final messages = await db.collection("message").doc(doc_id).collection("msglist").withConverter(
      fromFirestore: Msgcontent.fromFirestore,
      toFirestore: (Msgcontent msgcontent, options) => msgcontent.toFirestore(),
    ).orderBy("addtime", descending: true).where("addtime", isLessThan: state.msgcontent.value.last.addtime)
        .limit(10).get();
    print(state.msgcontent.value.last.content);
    print("isGreaterThan-----");
    if(messages.docs.isNotEmpty){
      messages.docs.forEach((element) {
        var data = element.data();
        state.msgcontent.value.add(data);
        print(data.content);
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        isLoadmore = true;
      });
    }
    state.isloading.value = false;
  }



  Future<void> sendImageMessage(String url) async {



    final content = Msgcontent(
      token: token,
      content: url,
      type: "image",
      addtime: Timestamp.now(),
    );

    await db.collection("message").doc(doc_id).collection("msglist")
        .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msg,options)=>msg.toFirestore()
    ).add(content).then((DocumentReference doc){
      // print("...base id is ${doc_id}...new message doc id is ${doc.id}");

    });


    var messageResult = await db.collection("message").doc(doc_id).withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore()
    ).get();


    if(messageResult.data()!=null){
      var item = messageResult.data()!;
      int to_msg_num = item.to_msg_num==null?0:item.to_msg_num!;
      int from_msg_num = item.from_msg_num==null?0:item.from_msg_num!;
      if(item.from_token==token){
        from_msg_num = from_msg_num+1;
      }else{
        to_msg_num = to_msg_num+1;
      }
      await db.collection("message")
      .doc(doc_id)
      .update({
        "to_msg_num":to_msg_num,
        "from_msg_num":from_msg_num,
        "last_msg":"🔥🔥",
        "last_time":Timestamp.now()
      });

    }
    sendNotifications("text");



  }

  sendNotifications(String call_type) async {
    CallRequestEntity callRequestEntity = new CallRequestEntity();
    // text,voice,video,cancel
    callRequestEntity.call_type = call_type;
    callRequestEntity.to_token = state.to_token.value;
    callRequestEntity.to_avatar = state.to_avatar.value;
    callRequestEntity.doc_id = doc_id;
    callRequestEntity.to_name = state.to_name.value;
    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    print(res);
    if (res.code == 0) {
      print("sendNotifications success");
    } else {
      // Get.snackbar("Tips", "Notification error!");
      // Get.offAllNamed(AppRoutes.Message);
    }
  }


  void closeAllPop() async{
    Get.focusScope?.unfocus();
    state.more_status.value = false;
    print("close_all_pop");
  }
  @override
  void onClose(){
    super.onClose();
    listener.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    myInputController.dispose();
    myScrollController.dispose();
    clearMsgNum(doc_id);
  }


}


