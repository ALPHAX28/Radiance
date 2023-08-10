
import 'dart:io';

import 'package:Radiance/common/routes/names.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:Radiance/common/widgets/widgets.dart';
import 'package:Radiance/pages/message/chat/widgets/chat_list.dart';
import 'package:path_provider/path_provider.dart';
import 'index.dart';
import 'package:Radiance/common/values/values.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:audioplayers/audioplayers.dart';





class ChatPage extends GetView<ChatController> {
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryBackground,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Get.back();
        },
      ),
      title: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => {
                Get.back()
              },
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primarySecondaryBackground,
                  borderRadius: BorderRadius.all(Radius.circular(22.w)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    controller.state.to_avatar.value == null
                        ? Image(
                      image: AssetImage('assets/images/account_header.png'),
                      fit: BoxFit.cover,
                    )
                        : CachedNetworkImage(
                      imageUrl: controller.state.to_avatar.value,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22.w)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Image(
                        image: AssetImage('assets/images/account_header.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 2.0,
                      right: 2.0,
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.state.to_online.value == '1' ? Colors.green:Colors.grey // Replace `isOnline` with your actual condition for determining online status
                        ),
                      ),
                    ),
                  ],
                ),
              )

              ,
            ),
            SizedBox(width: 10.w), // Adjust the spacing between the name and avatar
            GestureDetector(
              onTap: () {
                Get.dialog(
                  Material(
                    color: Colors.white, // Set the background color to white
                    child: Container(
                      width: 200.0, // Custom width
                      height: 300.0, // Custom height
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Back button and profile name
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  Get.back(); // Close the dialog
                                },
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Align(
                                  alignment: Alignment(-0.2, 0.1),
                                  child: Text(
                                    "Profile",
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0), // Space between the back button/profile name and the avatar
                          // Avatar
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.Photoimgview, parameters: {"url": controller.state.to_avatar.value});
                            },
                            child: CircleAvatar(
                              radius: 85.0, // Increase the radius for a larger avatar
                              child: ClipOval(
                                child: Container(
                                  width: 170.w,
                                  height: 170.w,
                                  color: Colors.white,
                                  child: controller.state.to_avatar.value == null
                                      ? Image(
                                    image: AssetImage('assets/images/account_header.png'),
                                    fit: BoxFit.cover,
                                  )
                                      : CachedNetworkImage(
                                    imageUrl: controller.state.to_avatar.value,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Image(
                                      image: AssetImage('assets/images/account_header.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0), // Space between the avatar and the name
                          // Name
                          Text(
                            "${controller.state.to_name}",
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              color: AppColors.primaryText,
                              fontSize: 25.sp,
                            ),
                          ),
                          SizedBox(height: 16.0),
                     // Space between the name and online/offline status
                        if(controller)Text(
                          "online", // Replace with the actual online/offline status
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // Customize the color for online status
                            fontSize: 12.sp,
                          ),
                        )else
                          Text(
                            "offline", // Replace with the actual online/offline status
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey, // Customize the color for online status
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 8.0),// Space between the name and the icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Audio Call Icon
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0), // Add a horizontal gap
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.phone, size: 30.0),
                                      onPressed: () {
                                        controller.audioCall();
                                      },
                                    ),
                                    Text(
                                      'Audio Call',
                                      style: TextStyle(
                                        fontFamily: 'Avenir',
                                        color: AppColors.primaryText,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Video Call Icon
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0), // Add a horizontal gap
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.video_call, size: 30.0),
                                      onPressed: () {
                                        controller.videoCall();
                                      },
                                    ),
                                    Text(
                                      'Video Call',
                                      style: TextStyle(
                                        fontFamily: 'Avenir',
                                        color: AppColors.primaryText,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Message Icon
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0), // Add a horizontal gap
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.message, size: 30.0),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                    Text(
                                      'Message',
                                      style: TextStyle(
                                        fontFamily: 'Avenir',
                                        color: AppColors.primaryText,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0), // Space between the icons and the gallery
                          // Expanded(
                          //   child: GridView.count(
                          //     crossAxisCount: 3, // Number of columns in the grid
                          //     children: List.generate(6, (index) {
                          //       // Replace '6' with the number of images you want to display in the gallery
                          //       return Container(
                          //         decoration: BoxDecoration(
                          //           image: DecorationImage(
                          //             image:AssetImage('assets/images/love.jpeg') ,
                          //             fit: BoxFit.cover,
                          //           ),
                          //         ),
                          //       );
                          //     }),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 0.w),
                child: Column(
                  children: [
                    Text(
                      "${controller.state.to_name}",
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 2.0), // Space between the name and online status
                    if (controller.state.to_online.value == '1')
                      Text(
                        "Online",
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 12.sp,
                        ),
                      ),
                  ],
                ),
              )

            )




















            ,
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call),
          onPressed: () {
            controller.audioCall();
          },
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {
            controller.videoCall();
          },
        ),
      ],
    );
  }



  // void startRecord() async {
  //   bool hasPermission = await checkPermission();
  //   if(hasPermission){
  //     recordFilePath = await getFilePath();
  //     RecordMp3.instance.start(recordFilePath, (type){
  //       setState(() {});
  //     });
  //   }else{}
  //   setState(() {});
  // }
  late String recordFilePath;

  // uploadAudio() async {
  //   UploadTask uploadTask = chatProvider.uploadAudio(File(recordFilePath),
  //     "audio/${DateTime.now().microsecondsSinceEpoch.toString()}"
  //   );
  //   try{
  //     TaskSnapshot snapshot = await uploadTask;
  //     audioURL = await snapshot.ref.getDownloadURL();
  //     String strVal = audioURL.toString();
  //     setState(() {
  //       audioController.isSending.value = false;
  //       onSendMessage(strVal,TypeMessage.audio,duration: audioController.total);
  //     });
  //
  //   }on FirebaseException catch(e){
  //     setState((){
  //       audioController.isSending.value = false;
  //     });
  //     Fluttertoast.showToast(msg: e.message??e.toString());
  //   }
  // }

  // void stopRecord() async {
  //   bool stop = RecordMp3.instance.stop();
  //   audioController.end.value = DateTime.now();
  //   audioController.calcDuration();
  //   var ap = AudioPlayer();
  //   await ap.play(AssetSource("assets/beep-6-96243.mp3"));
  //   ap.onPlayerComplete.listen((a) {
  //     if(stop){
  //       audioController.isRecording.value = false;
  //       audioController.isSending.value = true;
  //       await uploadAudio();
  //     }
  //   })
  // }

  int i = 0;

  // Future<String> getFilePath() async{
  //   Directory storageDirectory = await getApplicationDocumentsDirectory();
  //   String sdPath = "${storageDirectory.path}/records${DateTime.now().microsecondsSinceEpoch}.acc";
  //   var d = Directory(sdPath);
  //   if(!d.existsSync()){
  //     d.createSync(recursive: true);
  //   }
  //   return "$sdPath/text_${i++}.mp3"
  // }


  

  @override
  Widget build(BuildContext context) {
    Widget sendButton = Padding(
      padding: EdgeInsets.all(8.w),
      child: GestureDetector(
        child: Container(
          width: 24.w,
          height: 24.h,
          child: Image.asset(
              "assets/icons/send-message.png"),
        ), onTap: () {
        controller.sendMessage();
      },
      ),
    );

    // Widget micButton = Padding(
    //   padding: EdgeInsets.all(8.w),
    //   child: GestureDetector(
    //     child: Icon(Icons.mic,color: AppColors.primaryElement,size: 28,),
    //     onLongPress: () async {
    //       var audioPlayer = AudioPlayer();
    //       await audioPlayer.play(AssetSource("assets/beep-6-96243.mp3"));
    //       audioPlayer.onPlayerComplete.listen((a) {
    //         audioController.start.value = DateTime.now();
    //         startRecord();
    //         audioController.isRecording.value = true;
    //       });
    //
    //     },
    //     onLongPressEnd: (details){
    //       stopRecord();
    //     },
    //   ),
    // );
    return Scaffold(
        appBar: _buildAppBar(),
        body: Obx(() =>
            SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      const Expanded(child: ChatList()),                      Positioned(
                        bottom: 0.h,
                        child: Container(
                          width: 360.w,
                          constraints: BoxConstraints(
                              maxHeight: 90.h,
                              minHeight: 70.h
                          ),
                          padding: EdgeInsets.only(
                              left: 10.w, right: 20.w, bottom: 10.h, top: 10.h),
                          color: AppColors.primaryBackground,
                          child: Column(
                            children: [
                              Container(
                                child: Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          width: 265.w,
                                          padding: EdgeInsets.only(
                                            top: 10.h,
                                            bottom: 10.h,
                                            left: 5.w,
                                          ),
                                          // padding: EdgeInsets.only(top:5.h,bottom: 5.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.w),
                                            color: AppColors.primaryBackground,
                                            border: Border.all(
                                              color: AppColors.primarySecondaryElementText,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                            // Positioned(
                                            //   left: 8.w,
                                            //   top: 6.w,
                                            //   bottom: 6.w,
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.all(8.0),
                                            //     child: GestureDetector(
                                            //       onTap: () {
                                            //         // controller.state.isEmojiVisible.value=!controller.state.isEmojiVisible.value;
                                            //       },
                                            //       // child: Icon(Icons.emoji_emotions_outlined, // Replace with your emoji icon
                                            //       //   size: 30.w,
                                            //       // ),
                                            //     ),
                                            //   ),
                                            // ),
                                            Expanded(
                                              child: Container(
                                                width: 220.w,
                                                constraints: BoxConstraints(
                                                    maxHeight: 150.h,
                                                    minHeight: 20.h
                                                ),

                                                child: Expanded(
                                                  child: TextFormField(
                                                    controller: controller.myInputController,
                                                    maxLines: null,
                                                    keyboardType: TextInputType.multiline,
                                                    autofocus: false,
                                                    onChanged: (value){
                                                      if(value.isNotEmpty){
                                                        controller.state.setIsTextFieldEmpty.value = false;
                                                      }else {
                                                        controller.state.setIsTextFieldEmpty.value = true;
                                                      }
                                                      
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: "Message...",
                                                      contentPadding: EdgeInsets.only(
                                                        left: 25.w,
                                                        top: 0,
                                                        bottom: 0,
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(30.w),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      filled: true,
                                                      fillColor: AppColors.primaryBackground,
                                                      hintStyle: TextStyle(
                                                        color: AppColors.primarySecondaryElementText,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if(controller.state.setIsTextFieldEmpty.value)Padding(padding: EdgeInsets.all(8.w),
                child: const Icon(Icons.mic,size: 28,color: AppColors.primaryElement,)) else sendButton ,
                                                

                                          ],
                                          )
                                      ),



                                      GestureDetector(
                                          child: Container(
                                              height: 45.w,
                                              width: 45.w,
                                              padding: EdgeInsets.all(8.w),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryElement,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 2,
                                                    offset: Offset(1,
                                                        1), // changes position of shadow
                                                  ),
                                                ],
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(40.w)),
                                              ),
                                              child: controller.state.more_status.value
                                                  ? Image.asset("assets/icons/by.png")
                                                  : Image.asset(
                                                  "assets/icons/add.png")), onTap: () {
                                        controller.goMore();
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                              // Obx(() => Offstage(
                              //   offstage: !controller.state.isEmojiVisible.value,
                              //   child: SizedBox(
                              //     height: 250,
                              //     child: EmojiPicker(
                              //       onEmojiSelected: (category, emoji) {
                              //
                              //       },
                              //       onBackspacePressed: () {},
                              //       config: const Config(
                              //           columns: 7,
                              //           verticalSpacing: 0,
                              //           horizontalSpacing: 0,
                              //           initCategory: Category.SMILEYS,
                              //           bgColor: Color(0xFFF2F2F2),
                              //           indicatorColor: Colors.blue,
                              //           iconColor: Colors.grey,
                              //           iconColorSelected: Colors.blue,
                              //           noRecents: Text("no recents"),
                              //           recentsLimit: 28,
                              //           tabIndicatorAnimDuration: kTabScrollDuration,
                              //           categoryIcons: CategoryIcons(),
                              //           buttonMode: ButtonMode.MATERIAL),
                              //     ),
                              //   ),
                              // ))

                            ],
                          ),


                        ),
                      ),

                      controller.state.more_status.value ? Positioned(
                          right: 20.w,
                          bottom: 70.h,
                          height: 100.w,
                          width: 40.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                child: Container(
                                    height: 40.w,
                                    width: 40.w,
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(1,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.w)),
                                    ),
                                    child: Image.asset(
                                        "assets/icons/file.png")), onTap: () {
                                controller.imgFromGallery();
                              },),
                              GestureDetector(
                                child: Container(
                                    height: 40.w,
                                    width: 40.w,
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(1,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(40.w)),
                                    ),
                                    child: Image.asset(
                                        "assets/icons/photo.png")), onTap: () {
                                controller.imgFromCamera();
                              },),
                            ],)) : Container()
                              // GestureDetector(
                              //   child: Container(
                              //       height: 40.w,
                              //       width: 40.w,
                              //       padding: EdgeInsets.all(10.w),
                              //       decoration: BoxDecoration(
                              //         color: AppColors.primaryBackground,
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color: Colors.grey.withOpacity(0.2),
                              //             spreadRadius: 2,
                              //             blurRadius: 2,
                              //             offset: Offset(1,
                              //                 1), // changes position of shadow
                              //           ),
                              //         ],
                              //         borderRadius:
                              //         BorderRadius.all(Radius.circular(40.w)),
                              //       ),
                              //       child: Image.asset(
                              //           "assets/icons/call.png")), onTap: () {
                              //   controller.audioCall();
                              // },),
                              // GestureDetector(
                              //   child: Container(
                              //       height: 40.w,
                              //       width: 40.w,
                              //       padding: EdgeInsets.all(10.w),
                              //       decoration: BoxDecoration(
                              //         color: AppColors.primaryBackground,
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color: Colors.grey.withOpacity(0.2),
                              //             spreadRadius: 2,
                              //             blurRadius: 2,
                              //             offset: Offset(1,
                              //                 1), // changes position of shadow
                              //           ),
                              //         ],
                              //         borderRadius:
                              //         BorderRadius.all(Radius.circular(40.w)),
                              //       ),
                              //       child: Image.asset(
                              //           "assets/icons/video.png")), onTap: () {
                              //   controller.videoCall();
                              // },),

                    ],
                  ),
                ))));
  }
}
