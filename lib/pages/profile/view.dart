import 'package:Radiance/common/values/colors.dart';
import 'package:Radiance/pages/frame/welcome/controller.dart';
import 'package:Radiance/pages/message/controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);


  AppBar _buildAppbar(){
    return AppBar(
      title: Text(
        "Profile",
        style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal
        ),
      ),
    );
  }

  Widget _buildDescripeInput() {
    return Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(bottom: 20.h, top: 0.h),
        padding: EdgeInsets.all(0.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          keyboardType: TextInputType.multiline,
          controller: controller.DescriptionEditingController,
          decoration: InputDecoration(
            hintText: controller.state.profile_detail.value.description==null?"Enter a description":controller.state.profile_detail.value.description,
            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            hintStyle: TextStyle(
              color: AppColors.primarySecondaryElementText,
            ),
          ),
          style: TextStyle(
            color: AppColors.primaryText,
            fontFamily: "Avenir",
            fontWeight: FontWeight.normal,
            fontSize: 14.sp,
          ),
          maxLines: 1,
          onChanged: (value){
            controller.state.profile_detail.value.description = value;
          },
          autocorrect: true,
          obscureText: false,
        ));
  }

  Widget _buildSeleteStatusInput() {
    return Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(bottom: 20.h, top: 0.h),
        padding: EdgeInsets.all(0.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              margin: EdgeInsets.only(left: 15.w),
              decoration: BoxDecoration(
                color: controller.state.profile_detail.value.online==1?AppColors.primaryElementStatus:AppColors.primarySecondaryElementText,
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
              ),
            ),
            Container(
                width: 200.w,
                height: 44.h,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: controller.state.profile_detail.value.online==1?"Online":"Offline",
                    hintStyle:TextStyle(color: AppColors.primarySecondaryElementText),
                    contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  autocorrect: false, // 自动纠正
                  obscureText: false, // 隐藏输入内容, 密码框
                )),
            Container(
              width: 50.w,
              height: 30.w,
              padding: EdgeInsets.only(left: 0.w),
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        width: 2.w, color: AppColors.primarySecondaryBackground),
                  )),
              child: DropdownButtonHideUnderline(
                  child:DropdownButton(icon: Icon(Icons.arrow_drop_down), iconSize: 35,iconEnabledColor: AppColors.primarySecondaryElementText,
                      hint: Text(''),
                      elevation:0,
                      isExpanded: true,
                      // underline:Container(),
                      items: [
                        DropdownMenuItem(child: Text('Online'), value: 1),
                        DropdownMenuItem(child: Text('Offline'), value: 2),
                      ], onChanged: (value) {
                        controller.state.profile_detail.value.online = value;
                        controller.state.profile_detail.refresh();
                      })),
            )
          ],
        ));
  }

  Widget _buildLogo(BuildContext context) {
    return GestureDetector(
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: 150.w,
          height: 150.w,
          margin: EdgeInsets.only(top: 10.h, bottom: 40.h),
          decoration: BoxDecoration(
            color: AppColors.primarySecondaryBackground,
            shape: BoxShape.circle,
          ),
          child: CachedNetworkImage(
            imageUrl: controller.state.profile_detail.value.avatar!,
            height: 120.w,
            width: 120.w,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover, // Set the fit property to cover
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50.w,
          right: 0.w,
          height: 35.w,
          child: Container(
            height: 35.w,
            width: 35.w,
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: AppColors.primaryElement,
              borderRadius: BorderRadius.all(Radius.circular(40.w)),
            ),
            child: Image.asset(
              "assets/icons/edit.png",
            ),
          ),
        )
      ]),
      onTap: (){
        _showPicker(context);
      }
    );
  }



  Widget _buildCompleteBtn(){
    return GestureDetector(
      child: Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(top: 60.h,bottom: 30.h),
        decoration: BoxDecoration(
              color: AppColors.primaryElement,
            borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1)
                )
            ]
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Complete",
              style: TextStyle(
                  color: AppColors.primaryElementText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal
              ),
            ),
          ],
        ),

      ),
      onTap: (){
        controller.goSave();
      },
    );
  }

  Widget _buildNameInput() {
    return Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(bottom: 20.h, top: 0.h),
        padding: EdgeInsets.all(0.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          keyboardType: TextInputType.multiline,
          controller: controller.NameEditingController,
          decoration: InputDecoration(
            hintText: controller.state.profile_detail.value.name,
            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            hintStyle: TextStyle(
              color: AppColors.primarySecondaryElementText,
            ),
          ),
          style: TextStyle(
            color: AppColors.primaryText,
            fontFamily: "Avenir",
            fontWeight: FontWeight.normal,
            fontSize: 14.sp,
          ),
          maxLines: 1,
          onChanged: (value){
            controller.state.profile_detail.value.name=value;
          },
          autocorrect: false, // 自动纠正
          obscureText: false, // 隐藏输入内容, 密码框
        ));
  }


  Widget _buildLogOutBtn(){
    return GestureDetector(
      child: Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(top: 0.h,bottom: 30.h),
        decoration: BoxDecoration(
            color: AppColors.primarySecondaryElementText,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1)
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Logout",
              style: TextStyle(
                  color: AppColors.primaryElementText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal
              ),
            ),
          ],
        ),

      ),
      onTap: (){
        Get.defaultDialog(
          title: "Are you sure to log out?",
          content: Container(),
          onConfirm: (){
            controller.goLogout();
          },
          onCancel: (){

          },
          textConfirm: "Confirm",
          textCancel: "Cancel",
          confirmTextColor: Colors.white
        );
      },
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Colors.blue,
                  size: 32.0,
                ),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  controller.imgFromGallery();
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  color: Colors.blue,
                  size: 32.0,
                ),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  controller.imgFromCamera();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: _buildAppbar(),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildLogo(context),
                        _buildNameInput(),
                        _buildSeleteStatusInput(),
                        _buildDescripeInput(),
                        _buildCompleteBtn(),
                        _buildLogOutBtn(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
   );
  }
}
