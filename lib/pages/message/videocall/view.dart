import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:Radiance/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'controller.dart';


class VideoCallPage extends GetView<VideoCallController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary_bg,
        body: SafeArea(
            child:Obx(() {
              return Container(
                  child: controller.state.isReadyPreview.value?Stack(
                    children: [

                      Positioned(
                        child: controller.state.onRemoteUid.value==0?Container():AgoraVideoView(

                            controller: VideoViewController.remote(
                                rtcEngine: controller.engine,
                                canvas:VideoCanvas(uid: controller.state.onRemoteUid .value),
                                connection: RtcConnection(channelId: controller.state.channelId.value))
                        ),
                      ),
                      Positioned(
                        top: 30.h,
                        right: 15.w,
                        child: SizedBox(
                          width: 80.w,
                          height: 120.w,
                          child: controller.state.turnCamera.value
                              ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: controller.engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                              : Container(color: Colors.black),
                        ),
                      ),
                      controller.state.isShowAvatar.value?Container():Positioned(
                          top: 10.h,
                          left: 30.w,
                          right: 30.w,
                          child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top:6.h),
                                  child: Text("${controller.state.call_time.value}",
                                    style: TextStyle(
                                      color: AppColors.primaryElementText,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal,
                                    ),),),
                              ])),
                      controller.state.isShowAvatar.value?Positioned(
                          top: 10.h,
                          left: 30.w,
                          right: 30.w,
                          child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top:6.h),
                                  child: Text("${controller.state.call_time.value}",
                                    style: TextStyle(
                                      color: AppColors.primaryElementText,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal,
                                    ),),),
                                Container(
                                  width: 70.w,
                                  height: 70.w,
                                  margin: EdgeInsets.only(top:150.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.w),
                                    // color: AppColors.primaryElementText
                                  ),
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundImage: NetworkImage(
                                      "${controller.state.to_avatar.value}",
                                    ),
                                  ),

                                ),

                                Container(
                                  margin: EdgeInsets.only(top:6.h),
                                  child: Text("${controller.state.to_name.value}",
                                    style: TextStyle(
                                      color: AppColors.primaryElementText,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.normal,
                                    ),),)
                              ])):Container(),
                      Positioned(
                        bottom: 80.h,
                        left: 20.w,
                        right: 20.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: controller.state.isJoined.value ? controller.turnCamera : null,
                                    child: Container(
                                      width: 60.w,
                                      height: 60.w,
                                      padding: EdgeInsets.all(15.w),
                                      decoration: BoxDecoration(
                                        color: controller.state.turnCamera.value
                                            ? AppColors.primaryElementText
                                            : AppColors.primaryElementText,
                                        borderRadius: BorderRadius.all(Radius.circular(30.w)),
                                      ),
                                      child: controller.state.turnCamera.value
                                          ? Image.asset("assets/icons/video-camera.png")
                                          : Image.asset("assets/icons/no-video.png"),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.h),
                                    child: Text(
                                      "Camera",
                                      style: TextStyle(
                                        color: AppColors.primaryElementText,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: controller.state.isJoined.value ? controller.switchMicrophone : null,
                                    child: Container(
                                      width: 60.w,
                                      height: 60.w,
                                      padding: EdgeInsets.all(15.w),
                                      decoration: BoxDecoration(
                                        color: controller.state.openMicrophone.value
                                            ? AppColors.primaryElementText
                                            : AppColors.primaryText,
                                        borderRadius: BorderRadius.all(Radius.circular(30.w)),
                                      ),
                                      child: controller.state.openMicrophone.value
                                          ? Image.asset("assets/icons/b_microphone.png")
                                          : Image.asset("assets/icons/a_microphone.png"),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.h),
                                    child: Text(
                                      "Microphone",
                                      style: TextStyle(
                                        color: AppColors.primaryElementText,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      width: 60.w,
                                      height: 60.w,
                                      padding: EdgeInsets.all(15.w),
                                      decoration: BoxDecoration(
                                        color: controller.state.switchCamera.value ? AppColors.primaryElementText : AppColors.primaryText,
                                        borderRadius: BorderRadius.all(Radius.circular(30.w)),
                                      ),
                                      child: controller.state.switchCamera.value
                                          ? Image.asset("assets/icons/b_photo.png")
                                          : Image.asset("assets/icons/a_photo.png"),
                                    ),
                                    onTap: controller.switchCamera,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.h),
                                    child: Text(
                                      "switchCamera",
                                      style: TextStyle(
                                        color: AppColors.primaryElementText,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      width: 60.w,
                                      height: 60.w,
                                      padding: EdgeInsets.all(15.w),
                                      decoration: BoxDecoration(
                                        color: controller.state.isJoined.value ? AppColors.primaryElementBg : AppColors.primaryElementStatus,
                                        borderRadius: BorderRadius.all(Radius.circular(30.w)),
                                      ),
                                      child: controller.state.isJoined.value ? Image.asset("assets/icons/a_phone.png") : Image.asset("assets/icons/a_telephone.png"),
                                    ),
                                    onTap: controller.state.isJoined.value ? controller.leaveChannel : controller.joinChannel,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.h),
                                    child: Text(
                                      controller.state.isJoined.value ? "Disconnect" : "Connected",
                                      style: TextStyle(
                                        color: AppColors.primaryElementText,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ):Container()
              );
            })));
  }
}

